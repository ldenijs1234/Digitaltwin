%   dx/dt = function(GH, i)
GH = GH ;

function VentilationRate = VentilationRate(GH, i)
    G_l = 2.29e2 * (1 - exp(-GH.u.OpenWindowAngle/21.1)) ; % leeside
    G_w = 1.2e-3 * GH.u.OpenWindowAngle * exp(GH.u.OpenWindowAngle/211) ; % windward side
    v_wind = (G_l + G_w) * GH.p.WindowArea * GH.d.WindSpeed(i) ;
    H = GH.p.WindowHeight * (sind(GH.p.RoofAngle)- sind(GH.p.RoofAngle - GH.u.OpenWindowAngle)) ;
    v_temp = GH.p.C_f * GH.p.WindowLength/3 * (abs(GH.p.Gravity*GH.p.BetaAir*(GH.x.AirTemperature(i) ... 
    - GH.d.OutsideTemperature(i))))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * (GH.p.NumberOfWindows/GH.p.GHFloorArea) * (v_wind^2 + v_temp^2)^(0.5) ;
end

function [GH, AirTemperatureDot] = ODE_AirTemperature(GH, i)
    C_AirVolumeGH = GH.p.GHVolume * GH.p.rho_air * GH.p.cp_air ;

    Q_Heating = GH.u.Heating(i) ; %W
    Q_RoofConv = GH.p.h_WallInside * GH.p.GHTotalArea * (GH.x.WallTemperature(i) - GH.x.AirTemperature(i)) ; %W
    Q_ConvFloorAir = GH.p.h_Floor * GH.p.GHFloorArea * (GH.x.FloorLayer(i,1) - GH.x.AirTemperature(i)) ; %W
    Q_ConvPlantAir = GH.p.h_Plant * GH.p.GHPlantArea * (GH.x.PlantTemperature(i) - GH.x.AirTemperature(i)) ; %W
    VRate = VentilationRate(GH, i) ;
    Q_vent = - GH.p.WindowArea * VRate * (GH.x.AirTemperature(i) - GH.d.OutsideTemperature(i)) * GH.p.cp_air * GH.p.rho_air ;
    % Q_RadAirSky = - GH.p.EmittanceGlassSky * GH.p.StefBolzConst * GH.p.GHTotalArea * ... 
    % ((GH.x.AirTemperature(i) + GH.p.Kelvin)^4 - (GH.d.SkyTemperature(i) + GH.p.Kelvin)^4) ; %W

    GH.t.Q_HeatingA(i) = Q_Heating ; GH.t.Q_RoofConvA(i) = Q_RoofConv ; GH.t.Q_ConvFloorAirA(i) = Q_ConvFloorAir ; 
    GH.t.Q_ConvPlantAirA(i) = Q_ConvPlantAir ; GH.t.Q_ventA(i) = Q_vent ;% GH.t.Q_RadAirSkyA(i) = Q_RadAirSky ;
    
    Q = Q_RoofConv + Q_Heating + Q_ConvFloorAir + Q_ConvPlantAir + Q_vent ;%+ Q_RadAirSky ;% Q_sky  + Q_lamp + Q_soil + Q_vent + ...
    AirTemperatureDot = Q/C_AirVolumeGH ;

end
 
function [GH, WallTemperatureDot] = ODE_WallTemperature(GH, i)
    C_WallsGH = GH.p.GHTotalArea * GH.p.GHWallThickness * GH.p.rho_glass * GH.p.cp_glass ;

    Q_RoofConvIn = -GH.p.h_WallInside * GH.p.GHTotalArea * (GH.x.WallTemperature(i) - GH.x.AirTemperature(i)) ; %W
    Q_RoofConvOut = -GH.p.h_WallOutside * GH.p.GHTotalArea * (GH.x.WallTemperature(i) - GH.d.OutsideTemperature(i)) ; %W
    Q_solarWall = GH.p.AlfaGlass* GH.p.GHFloorArea*GH.d.SolarIntensity(i) ; %W
    Q_radWallSky = - GH.p.EmittanceGlass * GH.p.StefBolzConst * GH.p.GHTotalArea * ... 
    ((GH.x.WallTemperature(i) + GH.p.Kelvin)^4 - (GH.d.SkyTemperature(i)+ GH.p.Kelvin)^4) ; %W
    Q_RadFloorWall = (1-GH.p.TauGlass) * GH.p.GHFloorArea * GH.p.EmittanceFloor * GH.p.StefBolzConst ... 
    * ((GH.x.FloorLayer(i,1) + GH.p.Kelvin)^4 - (GH.x.WallTemperature(i) + GH.p.Kelvin)^4) ; %W
    Q_RadPlantWall = (1-GH.p.TauGlass) * GH.p.GHPlantArea * GH.p.EmittancePlant * GH.p.StefBolzConst * ... 
    ((GH.x.PlantTemperature(i) + GH.p.Kelvin)^4 - (GH.x.WallTemperature(i) + GH.p.Kelvin)^4) ; %W
 
    GH.t.Q_RoofConvW(i) = Q_RoofConvIn ; GH.t.Q_RoofCovOutW(i) = Q_RoofConvOut ; 
    GH.t.Q_solarWallW(i) = Q_solarWall ; GH.t.Q_radWallSkyW(i) = Q_radWallSky ;

    Q = Q_RoofConvIn + Q_RoofConvOut + Q_solarWall + Q_radWallSky + Q_RadFloorWall + Q_RadPlantWall;
    WallTemperatureDot = Q/C_WallsGH ;

end


function FloorTemperatureDot = ODE_FloorTemperature(GH, i)
    C_FloorGH = GH.p.GHFloorArea * GH.p.GHFloorThickness * GH.p.rho_floor * GH.p.cp_floor ;  %DUMMY!!!!!

    Q_SolarFloor = GH.p.TauGlass * GH.p.EmittanceFloor * GH.p.GHFloorArea * GH.d.SolarIntensity(i) ; %W  
    Q_ConvFloorAir = - GH.p.h_Floor * GH.p.GHFloorArea * (GH.x.FloorTemperature(i) - GH.x.AirTemperature(i)) ; %W
    Q_RadFloorWall = - (1-GH.p.TauGlass) * GH.p.GHFloorArea * GH.p.EmittanceFloor * GH.p.StefBolzConst ... 
    * ((GH.x.FloorTemperature(i) + GH.p.Kelvin)^4 - (GH.x.WallTemperature(i) + GH.p.Kelvin)^4) ; %W
    Q_CondFloorGround = GH.p.GHFloorArea * GH.p.AlfaGround * (GH.d.GroundTemperature(i) - GH.x.FloorTemperature(i)) / GH.p.LFloorGround ;

    Q = Q_SolarFloor + Q_ConvFloorAir  +  Q_CondFloorGround + Q_RadFloorWall ;
    FloorTemperatureDot = Q/C_FloorGH ;

end


function FloorLayerDot = ODE_FloorLayer(GH, i)
    C_FloorLayer = GH.p.GHFloorArea * GH.p.GHFloorThickness * GH.p.rho_floor * GH.p.cp_floor ; %calculate heat capacity of a single floorlayer
    FloorLayerDot = zeros(1, width(GH.x.FloorLayer)) ;

    %Equations for middle layers:
    %Because 1st and last entry are top and ground layer with their own temperature determination, only take 2nd to 1st to last entries in loop.
    for j = 2: width(GH.x.FloorLayer)-1 
        Q_Floorup = (GH.x.FloorLayer(i, j-1) - GH.x.FloorLayer(i, j)) * GH.p.GHFloorThickness / GH.p.KFloor ; 
        Q_Floordown = (GH.x.FloorLayer(i, j+1) - GH.x.FloorLayer(i, j)) * GH.p.GHFloorThickness / GH.p.KFloor ;
        FloorLayerDot(j) = (Q_Floordown + Q_Floorup) / C_FloorLayer ;
    end
    
    %Equations for top layer:
    Q_SolarFloor = GH.p.TauGlass * GH.p.GHFloorArea * GH.d.SolarIntensity(i) ; %W  
    Q_ConvFloorAir = - GH.p.h_Floor * GH.p.GHFloorArea * (GH.x.FloorLayer(i,1) - GH.x.AirTemperature(i)) ; %W
    Q_RadFloorWall = - GH.p.TauGlass * GH.p.GHFloorArea * GH.p.EmittanceFloor * GH.p.StefBolzConst ... 
    * ((GH.x.FloorLayer(i,1) + GH.p.Kelvin)^4 - (GH.x.WallTemperature(i) + GH.p.Kelvin)^4) ; %W
    Q_Floor2_1 = (GH.x.FloorLayer(i,2)-GH.x.FloorLayer(i,1)) * GH.p.GHFloorThickness / GH.p.KFloor ;
    
    Q = Q_Floor2_1 + Q_SolarFloor + Q_ConvFloorAir + Q_RadFloorWall ;

    FloorLayerDot(1) = Q/C_FloorLayer ;
end


function PlantTemperatureDot = ODE_PlantTemperature(GH, i)
    C_Plant = GH.x.MassPlant(i) * GH.p.cp_lettuce;  

    Q_SolarPlant = GH.p.TauGlass * GH.p.EmittancePlant * GH.p.GHPlantArea * GH.d.SolarIntensity(i) ; %W
    Q_ConvPlantAir = - GH.p.h_Plant * GH.p.GHPlantArea * (GH.x.PlantTemperature(i) - GH.x.AirTemperature(i)) ; %W
    Q_RadPlantWall = - (1-GH.p.TauGlass) * GH.p.GHPlantArea * GH.p.EmittancePlant * GH.p.StefBolzConst * ... 
    ((GH.x.PlantTemperature(i) + GH.p.Kelvin)^4 - (GH.x.WallTemperature(i) + GH.p.Kelvin)^4) ; %W

    Q = Q_SolarPlant + Q_ConvPlantAir + Q_RadPlantWall  ; 
    PlantTemperatureDot = Q/C_Plant ;

end

function HumidityDot = ODE_Humiditybalance(GH, i)
    CAP_Water = GH.p.GHVolume / GH.p.GHFloorArea; %m
    
    G_c = max(0, (1.8e-3 * (GH.x.AirTemperature(i) - GH.x.WallTemperature(i))^(1/3))) ; %m/s

    %W_Trans = (1 - exp(-GH.p.C_pld * GH.x.DryMassPlant(i)) * GH.p.C_vplai * ...
    %(GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (GH.x.AirTemperature(i) + GH.p.Kelvin))) ...
    %* exp(GH.p.C_v2 * GH.x.AirTemperature(i) / (GH.x.AirTemperature(i) + GH.p.C_v3)) ...
    %- GH.x.AirHumidity(i))  ;%kg m^-2 s^-1
    W_cond = (G_c * (0.2522 * exp(0.0485 * GH.x.AirTemperature(i)) * (GH.x.AirTemperature(i) ... 
    - GH.d.OutsideTemperature(i)) - ((5.5638 * exp(0.0572 * GH.x.AirTemperature(i)))*1000 - GH.x.AirHumidity(i)*1000)))/1000 ; %kg m^-2 s^-1
    W_vent = VentilationRate(GH, i) * (GH.x.AirHumidity(i) - GH.d.OutsideHumidity(i)) ; %kg m^-2 s^-1
   
    W = - W_vent - W_cond ; %W_Trans 
    HumidityDot = W / CAP_Water ; %kg m^-3 s^-1

end

function CO2Dot = ODE_CO2balance(GH, i)
    CAP_CO2 = GH.p.GHVolume / GH.p.GHFloorArea; %m
    
    C_Trans = (1 - exp(-GH.p.C_pld * GH.x.DryMassPlant(i))) * ((GH.p.C_RadPhoto * GH.d.SolarIntensity(i) * ... 
    (-GH.p.C_CO21 * GH.x.AirTemperature(i)^2 + GH.p.C_CO22 * GH.x.AirTemperature(i) - GH.p.C_CO23) * (GH.x.CO2Air(i) * GH.p.C_R)) / ... 
    (GH.p.C_RadPhoto * GH.d.SolarIntensity(i) + (-GH.p.C_CO21 * GH.x.AirTemperature(i)^2 + GH.p.C_CO22 * GH.x.AirTemperature(i) - ... 
    GH.p.C_CO23) * (GH.x.CO2Air(i) * GH.p.C_R))) ;
    C_vent = VentilationRate(GH, i) * (GH.x.CO2Air(i) - GH.d.OutsideCO2(i)) ; %kg m^-2 s^-1

    C = - C_Trans - C_vent ;
    CO2Dot = C / CAP_CO2 ; %kg m^-3 s^-1

end

function DryWeightDot = ODE_DryWeight(GH, i)
    C_Trans = (1 - exp(-GH.p.C_pld * GH.x.DryMassPlant(i))) * ((GH.p.C_RadPhoto * GH.d.SolarIntensity(i) * ... 
    (-GH.p.C_CO21 * GH.x.AirTemperature(i)^2 + GH.p.C_CO22 * GH.x.AirTemperature(i) - GH.p.C_CO23) * (GH.x.CO2Air(i) * GH.p.C_R)) / ... 
    (GH.p.C_RadPhoto * GH.d.SolarIntensity(i) + (-GH.p.C_CO21 * GH.x.AirTemperature(i)^2 + GH.p.C_CO22 * GH.x.AirTemperature(i) - ... 
    GH.p.C_CO23) * (GH.x.CO2Air(i) * GH.p.C_R))) ;

    DryWeightDot = GH.p.YieldFactor*C_Trans - GH.p.C_resp*GH.x.DryMassPlant(i) * 2^(0.1*GH.x.AirTemperature(i)- 2.5) ;
end


% Euler Integration
for i = 1: (length(GH.d.Time)-1)
    GH.x.VentilationRate(i) = VentilationRate(GH, i) ;
    [GH, AirTemperatureDot] = ODE_AirTemperature(GH, i) ;
    GH.x.AirTemperature(i+1) = GH.x.AirTemperature(i) + AirTemperatureDot*dt ;
    [GH, WallTemperatureDot] = ODE_WallTemperature(GH, i) ;
    GH.x.WallTemperature(i+1) = GH.x.WallTemperature(i) + WallTemperatureDot*dt ;
    FloorLayerDot = ODE_FloorLayer(GH, i) ;
    for j= 1: width(GH.x.FloorLayer) - 1
        GH.x.FloorLayer = [GH.x.FloorLayer;zeros(1, width(GH.x.FloorLayer))] ; %append row of zeros
        GH.x.FloorLayer(i+1, j) = GH.x.FloorLayer(i,j) + FloorLayerDot(j)*dt ;
    end
    
    GH.x.PlantTemperature(i+1) = GH.x.PlantTemperature(i) + ODE_PlantTemperature(GH, i)*dt ;
    GH.x.AirHumidity(i+1) = max(0, (GH.x.AirHumidity(i) + ODE_Humiditybalance(GH, i)*dt)) ;
    GH.x.CO2Air(i+1) = max(0, (GH.x.CO2Air(i) + ODE_CO2balance(GH, i)*dt)) ;
    % GH.x.DryMassPlant(i+1) = GH.x.DryMassPlant(i) + ODE_DryWeight(GH, i)*dt ;
    % GH.x.MassPlant(i+1) = GH.x.DryMassPlant(i+1) / 0.05 ;
end



% Plotting
figure;
hold on
plot(GH.d.Time/3600, GH.x.AirTemperature)
plot(GH.d.Time/3600, GH.x.WallTemperature, "r-")
plot(GH.d.Time/3600, GH.x.FloorLayer(:,1), "c-")
plot(GH.d.Time/3600, GH.x.PlantTemperature, "g-")
plot(GH.d.Time/3600, GH.d.OutsideTemperature, "b--")
legend('Air Temperature', 'Wall Temperature', 'Floor Temperature', 'Plant Temperature' ,'Outside Temperature')
hold off

figure;
hold on
plot(GH.d.Time/dt, GH.u.Heating, "r-")
plot(GH.d.Time/dt, GH.d.SolarIntensity, "y-")
legend('Heating', 'Solar Intensity')
hold off


% figure;
% hold on
% plot(GH.d.Time/dt, GH.x.AirHumidity, "b-")
% plot(GH.d.Time/dt, GH.x.CO2Air)
% legend('Humdity', 'CO2')
% hold off

% figure;
% hold on
% plot(GH.d.Time/dt, GH.x.DryMassPlant, "g-")
% plot(GH.d.Time/dt, GH.x.MassPlant, "b-")
% legend('Dry Mass Plant', 'Total Mass Plant')

tTime = GH.d.Time(1: end-1) ;
figure;
hold on
plot(tTime/3600, GH.t.Q_HeatingA)
plot(tTime/3600, GH.t.Q_RoofConvA)
plot(tTime/3600, GH.t.Q_ConvFloorAirA)
plot(tTime/3600, GH.t.Q_ConvPlantAirA)
plot(tTime/3600, GH.t.Q_ventA)
% plot(tTime/3600, GH.t.Q_RadAirSkyA)
legend('Heating', 'Roof', 'Floor', 'Plant', 'vent', 'Radiation')
title('Air heat flows')
hold off

figure;
hold on
plot(tTime/3600, GH.t.Q_RoofConvW)
plot(tTime/3600, GH.t.Q_RoofCovOutW)
plot(tTime/3600, GH.t.Q_solarWallW)
plot(tTime/3600, GH.t.Q_radWallSkyW)
legend('Roof in', 'Roof out', 'solar', 'Radiation')
title('Roof heat flows')
hold off