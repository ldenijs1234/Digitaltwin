%state 1: Air
%state 2: cover
%state 3: wall
%state 4: floor
%state 5: plant

function q = Fq_rad_out(emissivity, T)                          %imput: emissivity array and T(:,i)
    q = 5.670374419*10^-8 * emissivity .* ((T + 273.15).^4);    %emittance of components
end                                                             %q(:,i) = F


function Q = FQ_rad_in(absorbance, diffuse, Area, Viewf, qrad)      %imput: parameter arrays, viewfactor matrix and q radiance array(:,i)
    Q = absorbance .* (Area .* Viewf * qrad);                       %how much each object absorbs
    Q(1,:) = sum(diffuse .* Area .* Viewf * qrad);                   %inside air recieves diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun)     %input: transmission of the cover, parameter arrays and I_sun(i)
    Q = transmission .* absorbance .* Areasun * Isun; %absorbed sun radiation by each object
    Q(1,:) = sum(diffuse(4:end,:) .* Areasun(4:end,:) * Isun)     ;          %inside air recieves diffused sun radiation of everything except cover
end

function Q = FQ_sky(Area, absorbance, emissivity, TSky, T) %input: parameter arrays, effective sky temperature and Temperature of walls and roof
    Q = 5.670374419*10^-8 * Area .* (absorbance * (TSky + 273.15).^4 - emissivity .* ((T + 273.15).^4) ); %absorbance of sky emmision minus emittance of walls and roof 
end

function J = SkyEmit(T_dew, T_out)
    epsilon = 0.741 + 0.0062 * T_dew;
    J = epsilon * (T_out + 273.15)^4;
end

function Q = convection(hin, hout, T, T_out, Area)   % Convective heat flow array from with coefficient h with dt-matrix
    Convection_matrix = - eye(length(T));
    Convection_matrix(:, 1) = 1;
    Convection_matrix(1,1) = 0;
    dT = Convection_matrix * T ;
    Q  = Area .* hin .* dT ;
    Q(1) = -sum(Q) ;                                % Convective heat flow to air
    Q_out = Area(2:3) .* hout .* ([T_out; T_out] - T(2:3)) ;       % Convection with outside air
    Q(2:3) = Q(2:3) + Q_out; 
end

function [Q, QFloor] = FGroundConduction(GH, FloorTemperature, T)
    
    s = height(FloorTemperature) ;
    matrix1 = -2* eye(s) ;
    matrix2 = zeros(s) ; matrix2(2:end, 1:end-1) = eye(s-1) ;
    matrix3 = zeros(s) ; matrix3(1:end-1, 2:end) = eye(s-1) ;
    matrix = matrix1+matrix2+matrix3 ;
    matrix(end, :) = 0 ; matrix(1,1) = -1 ;

    QFloor = matrix * FloorTemperature / GH.p.GHFloorThickness * GH.p.KFloor ;

    Q = zeros(height(T), 1) ;
    Q(4) = QFloor(1) ;

end

function Q = LatentHeat(mv)    % Latent heat of evaporation of water mass flow mv
    Q = 2.45e6 * mv ;
end

function Q = HeatByVentilation(GH, T_air, T_out, VentilationRate)
    massflow = GH.p.rho_air * GH.p.NumberOfWindows*GH.p.WindowArea * VentilationRate ;
    Q = (T_out - T_air) * massflow * GH.p.cp_air ;
end

function [W_trans, W_cond, W_vent] = vaporflows(GH, T_air, T_wall, T_out, H_air, H_out, DryMassPlant, VentilationRate)
    
    G_c = 1.8e-3 * (max(0, (T_air - T_wall)))^(1/3) ; %m/s

    W_trans = (1 - exp(-GH.p.C_pld * DryMassPlant)) * GH.p.C_vplai * ...
    ((GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (T_air + 273.15))) ...
    * exp(GH.p.C_v2 * T_air / (T_air + GH.p.C_v3)) ...
    - H_air)  ;%kg m^-2 s^-1
    W_cond = (G_c * (0.2522 * exp(0.0485 * T_air) * (T_air ... 
    - T_out) - ((5.5638 * exp(0.0572 * T_air)) - H_air*1000)))/1000 ; %kg m^-2 s^-1
    W_vent = VentilationRate * (H_air - H_out) * GH.p.NumberOfWindows*GH.p.WindowArea/GH.p.GHFloorArea ; %kg m^-2 s^-1
   

end

function h_af = ConvFloor(T_floor, T_in)
    if T_floor > T_in
        h_af = 1.7 * (T_floor - T_in)^(1/3) ;
    else 
        h_af = 1.7 * (T_in - T_floor)^(1/4);
    end
end

function HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent)
    CAP_Water = GH.p.GHVolume / GH.p.GHFloorArea; %m

    W = - W_vent - W_cond + W_trans; %kg m^-2 s^-1 
    HumidityDot = W / CAP_Water ; %kg m^-3 s^-1
end

function [C_trans, C_vent] = CO2flows(GH, DryMassPlant, SolarIntensity, T_air, C_in, C_out, VentilationRate)
    
    C_trans = (1 - exp(-GH.p.C_pld * DryMassPlant)) * ((GH.p.C_RadPhoto * SolarIntensity * ... 
    (-GH.p.C_CO21 * T_air^2 + GH.p.C_CO22 * T_air - GH.p.C_CO23) * (C_in * GH.p.C_R)) / ... 
    (GH.p.C_RadPhoto * SolarIntensity + (-GH.p.C_CO21 * T_air^2 + GH.p.C_CO22 * T_air - ... 
    GH.p.C_CO23) * (C_in * GH.p.C_R))) ;
    C_vent = VentilationRate * (C_in - C_out) ; %kg m^-2 s^-1
end

function CO2Dot = CO2Balance(GH, C_trans, C_vent, C_inject)
    CAP_CO2 = GH.p.GHVolume / GH.p.GHFloorArea; %m
    C = - C_trans - C_vent + C_inject/GH.p.GHFloorArea;
    CO2Dot = C / CAP_CO2 ; %kg m^-3 s^-1
end

function DryWeightDot = DryWeight(GH, DryMassPlant, C_trans, T_air)
    DryWeightDot = GH.p.YieldFactor*C_trans - GH.p.C_resp*DryMassPlant * 2^(0.1*T_air- 2.5) ;
end


function VentilationRate = VentilationRatecalc(GH, T_air, WindSpeed, T_out)
    u = GH.u ; p = GH.p ; 

    G_l = 2.29e2 * (1 - exp(-u.OpenWindowAngle/21.1)) ; % leeside
    G_w = 1.2e-3 * u.OpenWindowAngle * exp(u.OpenWindowAngle/211) ; % windward side
    v_wind = (G_l + G_w) * p.WindowArea * WindSpeed ;
    H = p.WindowHeight * (sind(p.RoofAngle)- sind(p.RoofAngle - u.OpenWindowAngle)) ;
    v_temp = p.C_f * p.WindowLength/3 * (abs(p.Gravity*p.BetaAir*(T_air ... 
    - T_out)))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * (p.NumberOfWindows/p.GHFloorArea) * (v_wind^2 + v_temp^2)^(0.5) ;
end

for i = 1:length(t) - 1
    %Variable parameter functions (+ convection rate, ventilation rate...)
    VentilationRate(i) = VentilationRatecalc(GH, T(1, i), WindSpeed(i), OutsideTemperature(i)) ;
    ConvectionCoefficientsOut(:,i) = (ConvCoefficients(GH, T(3, i), OutsideTemperature(i), WindSpeed(i), OutsideHumidity(i), OutsideCO2)).' ;
    ConvectionCoefficientsIn(4,i) = ConvFloor(T(4, i), T(1, i)) ;
    ConvectionCoefficientsIn(2,i) = h_ac ;
    ConvectionCoefficientsIn(3,i) = h_ac ;
    ConvectionCoefficientsIn(5,i) = h_ap ;
    % Vapor flows and balance
    [W_trans(i), W_cond(i), W_vent(i)] = vaporflows(GH, T(1, i), T(3, i), OutsideTemperature(1,i), AddStates(1, i), OutsideHumidity(i), DryMassPlant, VentilationRate(i));
    HumidityDot = HumidityBalance(GH, W_trans(i), W_cond(i), W_vent(i));
    AddStates(1, i+1) = AddStates(1, i) + HumidityDot*dt ;

    % CO2 flows and balance
    [C_trans(i), C_vent(i)] = CO2flows(GH, AddStates(3,i), SolarIntensity(i), T(1, i), AddStates(2, i), OutsideCO2, VentilationRate(i)) ;
    CO2Dot = CO2Balance(GH, C_trans(i), C_vent(i), CO2_injection) ;
    DryWeightDot = DryWeight(GH, AddStates(3,i), C_trans(i), T(1, i)) ;
    AddStates(2, i+1) = AddStates(2, i) + CO2Dot*dt ;
    AddStates(3, i+1) = AddStates(3, i) + DryWeightDot*dt ;

    %Q functions (+ convection conduction...)
    FloorTemperature(1, i) = T(4, i) ;
    [Q_ground(:, i), QFloor(:, i)] = FGroundConduction(GH, FloorTemperature(:, i), T(:, i)) ;
    FloorTemperature(:, i+1) = FloorTemperature(:, i) + QFloor(:, i) * GH.p.GHFloorArea / CAPArray(4) * dt ;

    q_rad_out(:,i) = Fq_rad_out(EmmitanceArray, T(:,i));
    Q_rad_in(:,i) = FQ_rad_in(FIRAbsorbanceArray, FIRDiffuseArray, AreaArray, ViewArray, q_rad_out(:,i));
    Q_solar(:,i) = FQ_solar(TransmissionArray, SOLARDiffuseArray, SOLARAbsorbanceArray, AreaSunArray, SolarIntensity(i));
    J_sky(i) = SkyEmit(DewPoint(i),OutsideTemperature(i));
    Q_sky(2:3,i) = FQ_sky(AreaArray(2:3), FIRAbsorbanceArray(2:3), EmmitanceArray(2:3), SkyTemperature(i), T(2:3,i));
    Q_conv(:,i) = convection(ConvectionCoefficientsIn(:,i), ConvectionCoefficientsOut(:, i), T(:,i), OutsideTemperature(i), ConvAreaArray);
    Q_vent(1, i) = HeatByVentilation(GH, T(1, i), OutsideTemperature(i), VentilationRate(i)) ;
    Q_vent(2: height(T), i) = zeros(height(T)-1, 1) ;
    Q_latent(5, i) = LatentHeat(-W_trans(i)) ;
    Q_latent(1: height(T)-1, i) = zeros(height(T)-1, 1) ;

    %Total heat transfer
    Q_tot(:,i) = Q_vent(:, i) + Q_solar(:,i) +Q_sky(:,i) + Q_conv(:,i) + Q_ground(:, i); %+ Q_rad_in(:,i) - AreaArray .* q_rad_out(:,i);

    % Temperature Change
    T(:,i + 1) = T(:,i) + Q_tot(:,i) ./ CAPArray * dt;

 
    
end

figure("WindowStyle", "docked");
hold on
plot(t/3600,T)
plot(t/3600, OutsideTemperature)
legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Outside')
hold off

figure("WindowStyle", "docked");
hold on
plot(t/3600,AddStates(2))
hold off


% figure("WindowStyle", "docked");
% hold on
% plot(t(1:end-1)/3600, W_trans)
% plot(t(1:end-1)/3600, W_cond)
% plot(t(1:end-1)/3600, W_vent)
% legend( 'trans', 'cond', 'vent')


% figure("WindowStyle", "docked")
% hold on
% plot(t/3600, FloorTemperature)
% xlabel("Time (h)")
% ylabel("Floor layer temperature (°C)")
% hold off

% figure("WindowStyle", "docked")
% hold on
% plot(t(1:end-1), Q_sky(2, :)) 
% plot(t(1:end-1), Q_conv(2, :))
% plot(t(1:end-1), Q_solar(2, :))
% legend('sky', 'convection', 'solar')