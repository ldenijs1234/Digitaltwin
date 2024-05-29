%state 1: Air
%state 2: cover
%state 3: wall
%state 4: floor
%state 5: plant
%state 6: heatpipe

function q = Fq_rad_out(emissivity, T, Area)                          %imput: emissivity array and T(:,i)
    q = 5.670374419e-8 * emissivity .* Area .* ((T + 273.15).^4);    %emittance of components
end                                                             %q(:,i) = F


function Q = FQ_rad_in(absorbance, diffuse, Area, Viewf, qrad)      %imput: parameter arrays, viewfactor matrix and q radiance array(:,i)
    Q =(Area .* Viewf * qrad);                       %how much each object absorbs
    %Q(1,:) = sum(diffuse .* Area .* Viewf * qrad);                   %inside air recieves diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun, Area)     %input: transmission of the cover, parameter arrays and I_sun(i)
    Q = transmission .* absorbance .* Areasun * Isun; %absorbed sun radiation by each object
    dif = sum(diffuse(4:end,:) .* Areasun(4:end,:) * Isun);          %all sun radiation that is diffused
    Q = [diffuse(2); Area(2) / sum(Area(2:3)) * absorbance(2); Area(3) / sum(Area(2:3)) * absorbance(3); 0; 0; 0] * dif + Q;   %air absorbs diffused radiation thats again diffused by glass, glass absorbs this
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
    Q(4) = QFloor(1) * GH.p.GHFloorArea ;

end

function Q = LatentHeat(mv)    % Latent heat of evaporation of water mass flow mv
    Q = 2.45e6 *  mv ;
end

function Q = HeatByVentilation(GH, T_air, T_out, VentilationRate)
    massflow = GH.p.rho_air *  VentilationRate ;
    Q = (T_out - T_air) * massflow * GH.p.cp_air ;
end

function [W_trans, W_cond, W_vent] = vaporflows(GH, T_air, T_wall, T_out, H_air, H_out, DryMassPlant, VentilationRate)
    
    G_c = 1.8e-3 * (max(0, (T_air - T_wall)))^(1/3) ; %m/s

    W_trans = max(0, (1 - exp(-GH.p.C_pld * DryMassPlant / GH.p.GHFloorArea)) * GH.p.C_vplai * ...
    ((GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (T_air + 273.15))) ...
    * exp(GH.p.C_v2 * T_air / (T_air + GH.p.C_v3)) ...
    - H_air)) * GH.p.GHFloorArea ;%kg s^-1
    W_cond = (G_c * (0.2522 * exp(0.0485 * T_air) * (T_air ... 
    - T_out) - ((5.5638 * exp(0.0572 * T_air))/1000 - H_air)))/1000 * GH.p.GHWallArea ; %kg s^-1
    W_vent = VentilationRate * (H_air - H_out) ; %kg s^-1
    

end

function h_af = ConvFloor(T_floor, T_in)
    if T_floor > T_in
        h_af = 1.7 * (T_floor - T_in)^(1/3);
    else 
        h_af = 1.7 * (T_in - T_floor)^(1/4);
    end
end

function HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent)
    W = - W_vent - W_cond + W_trans; %kg s^-1 
    HumidityDot = W / GH.p.GHVolume ; %kg m^-3 s^-1
end

function [C_trans, C_vent, C_respD, C_respC] = CO2flows(GH, DryMassPlant, SolarIntensity, T_air, C_in, C_out, VentilationRate)
    
    C_trans = (1 - exp(-GH.p.C_pld * DryMassPlant/GH.p.GHFloorArea)) * ((GH.p.C_RadPhoto * SolarIntensity * ... 
    (-GH.p.C_CO21 * T_air^2 + GH.p.C_CO22 * T_air - GH.p.C_CO23) * (C_in - GH.p.C_R)) / ... 
    (GH.p.C_RadPhoto * SolarIntensity + (-GH.p.C_CO21 * T_air^2 + GH.p.C_CO22 * T_air - ... 
    GH.p.C_CO23) * (C_in - GH.p.C_R))) * GH.p.GHFloorArea ;
    C_vent = VentilationRate * (C_in - C_out) ; %kg s^-1
    C_respD = GH.p.C_resp*(DryMassPlant / GH.p.GHFloorArea) * 2^(0.1*T_air- 2.5) ;
    C_respC = GH.p.C_respC*(DryMassPlant / GH.p.GHFloorArea) * 2^(0.1*T_air- 2.5) ;
end

function CO2Dot = CO2Balance(GH, C_trans, C_vent, C_inject, C_respC)
    C = - C_trans - C_vent + C_inject + C_respC;
    CO2Dot = C / GH.p.GHVolume ; %kg m^-3 s^-1
end

function DryWeightDot = DryWeight(GH, C_trans, C_respD)
    DryWeightDot = GH.p.YieldFactor*C_trans - C_respD ;
end


function VentilationRate = VentilationRatecalc(GH, T_air, WindSpeedkph, T_out, OpenWindowAngle)
    p = GH.p ; 
    WindSpeed = WindSpeedkph / 3.6 ; %m/s
    G_l = 2.29e-2 * (1 - exp(-OpenWindowAngle/21.1)) ; % leeside
    G_w = 1.2e-3 * OpenWindowAngle * exp(OpenWindowAngle/211) ; % windward side
    v_wind = (G_l + G_w) * p.WindowArea * WindSpeed ;
    H = p.WindowHeight * (sind(p.RoofAngle)- sind(p.RoofAngle - OpenWindowAngle)) ;
    v_temp = p.C_f * p.WindowLength/3 * (abs(p.Gravity*p.BetaAir*(T_air ... 
    - T_out)))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * p.NumberOfWindows * (v_wind^2 + v_temp^2)^(0.5) ;
end


function [integral, error, ControllerOutputWatt] = PIController(T_WaterOut, T_air, setpoint, dt, integral)
    %PI controller
    k = 2000;        % Multiplication
    kp = 5;       % Proportional gain
    ki = 0.000001;       % Integral gain

    % Initialize variables
    % Calculate error
    error = setpoint - T_air;
    % Update integral term
    integral = max(0, integral + error * dt);
    
    % Calculate control output
    proportional = kp * error;
    integral_component = ki * integral;
    BoilerMaxWatt = 10000 ; %DUMMY

    Watt_Controller = k * (proportional + integral_component);
    Unlim_ControllerOutput = max(0, Watt_Controller);
    ControllerOutputWatt = min(BoilerMaxWatt, Unlim_ControllerOutput);  
end


function [error, OpenWindowAngle] = WindowController(T_air, setpoint, dt)
    k = 10 ;
    % Calculate error
    error = setpoint - T_air;

    % Calculate control output
  
    WindowAngle = min(45, -k * error);
    OpenWindowAngle = max(10, WindowAngle);   
end


    for i = 1:length(t) - 1
        

    % if T(1, i) > 20
    %     OpenWindowAngle(i) = 10 ;
    % else
    %     OpenWindowAngle(i) = 1 ;
    % end
    [h_pipeout(i), Q_heat(6,i), water_arrayOut] = heating_pipe(GH, T_WaterIn(i), T(1,i), T(6,i), dt, water_array) ;
    T_WaterOut(i) = water_arrayOut(end) ; water_array = water_arrayOut ;

    
    [integral(i+1), error(i), ControllerOutputWatt(i)] = PIController(GH, T(1,i), heatingline(i), dt, heatingintegral(i)) ;
    
    T_WaterIn(i+1) = min(99, T_WaterOut(i) + ControllerOutputWatt(i) / (GH.p.m_flow * GH.p.cp_water)) ;

    [coolingerror(i), OpenWindowAngle(i)] = WindowController(T(1,i), coolingline(i), dt);

    %Variable parameter functions (+ convection rate, ventilation rate...)
    VentilationRate(i) = VentilationRatecalc(GH, T(1, i), WindSpeed(i), OutsideTemperature(i), OpenWindowAngle(i)) ;

    [h_insidewall(i), h_ceiling(i)] = inside_convection(GH, T(3, i), T(2, i), T(1, i));
    ConvectionCoefficientsOut(:,i) = (ConvCoefficients(GH, T(3, i), OutsideTemperature(i), WindSpeed(i), OutsideHumidity(i), OutsideCO2, Winddirection(i), Sealevelpressure(i))).' ;
    ConvectionCoefficientsIn(4,i) = ConvFloor(T(4, i), T(1, i)) ;
    ConvectionCoefficientsIn(2,i) = h_ceiling(i) ; %h_ac ;
    ConvectionCoefficientsIn(3,i) = h_insidewall(i) ; %h_ac ;
    ConvectionCoefficientsIn(5,i) = h_ap ;
    ConvectionCoefficientsIn(6,i) = h_pipeout(i) ;
    
    % Vapor flows and balance
    [W_trans(i), W_cond(i), W_vent(i)] = vaporflows(GH, T(1, i), T(3, i), OutsideTemperature(1,i), AddStates(1, i), OutsideHumidity(i), DryMassPlant, VentilationRate(i));
    HumidityDot = HumidityBalance(GH, W_trans(i), W_cond(i), W_vent(i));
    AddStates(1, i+1) = AddStates(1, i) + HumidityDot*dt ;

    % CO2 flows and balance
    [C_trans(i), C_vent(i), C_respD(i), C_respC(i)] = CO2flows(GH, AddStates(3,i), SolarIntensity(i), T(1, i), AddStates(2, i), OutsideCO2, VentilationRate(i)) ;
    CO2Dot = CO2Balance(GH, C_trans(i), C_vent(i), CO2_injection, C_respC(i)) ;
    DryWeightDot = DryWeight(GH, C_trans(i), C_respD(i)) ;
    AddStates(2, i+1) = AddStates(2, i) + CO2Dot*dt ;
    AddStates(3, i+1) = AddStates(3, i) + DryWeightDot*dt ;
    AddStates(4, i+1 ) = AddStates(3, i+1) / 0.05 ;

    %Q functions (+ convection conduction...)
    FloorTemperature(1, i) = T(4, i) ;
    [Q_ground(:, i), QFloor(:, i)] = FGroundConduction(GH, FloorTemperature(:, i), T(:, i)) ;
    FloorTemperature(:, i+1) = FloorTemperature(:, i) + QFloor(:, i) * GH.p.GHFloorArea / CAPArray(4) * dt ;

    q_rad_out(:,i) = Fq_rad_out(EmmitanceArray, T(:,i), AreaArrayRad);
    Q_rad_in(:,i) = FQ_rad_in(FIRAbsorbanceArray, FIRDiffuseArray, AreaArrayRad, ViewMatrix, q_rad_out(:,i));
    Q_solar(:,i) = FQ_solar(TransmissionArray, SOLARDiffuseArray, SOLARAbsorbanceArray, AreaSunArray, SolarIntensity(i), AreaArray);
    J_sky(i) = SkyEmit(DewPoint(i),OutsideTemperature(i));
    Q_sky(2:3,i) = FQ_sky(AreaArray(2:3), FIRAbsorbanceArray(2:3), EmmitanceArray(2:3), SkyTemperature(i), T(2:3,i));
    Q_conv(:,i) = convection(ConvectionCoefficientsIn(:,i), ConvectionCoefficientsOut(:, i), T(:,i), OutsideTemperature(i), ConvAreaArray);
    Q_vent(1, i) = HeatByVentilation(GH, T(1, i), OutsideTemperature(i), VentilationRate(i)) ; 
    Q_vent(2: height(T), i) = zeros(height(T)-1, 1) ;
    Q_latent(5, i) = LatentHeat(-W_trans(i)) ;
    Q_latent(1, i) = LatentHeat(-W_vent(i)) + LatentHeat(W_trans(i)) ;

    %Total heat transfer 
    Q_tot(:,i) = Q_vent(:, i) + Q_sky(:,i) + Q_conv(:,i) + Q_ground(:, i) + Q_solar(:,i) + Q_rad_in(:,i) - q_rad_out(:,i) + Q_heat(:,i) + Q_latent(:, i);

    % Temperature Change
    T(:, i + 1) = T(:,i) + Q_tot(:,i) ./ CAPArray * dt;
    FloorTemperature(1, i) = T(4,i) ;
    Energy_kWh(i) = ControllerOutputWatt(i) * dt / (1000 * 3600);  % Convert from W to kWh
    
    if rem(i*dt/3600, 1) == 0 
        disp('hour:')
        disp(i*dt/3600)
    end

end



figure("WindowStyle", "docked");
hold on
plot(t/3600, T(:,:))
plot(t/3600, OutsideTemperature, 'b--')
plot(t/3600, heatingline, 'r--') 
plot(t/3600, coolingline, 'r--') 
title("Temperatures in the greenhouse")
xlabel("Time (h)")
ylabel("Temperature (°C)")
legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'heatingline', 'coolingline')
hold off

figure("WindowStyle", "docked")
hold on
plot(t/3600, AddStates(1,:))
plot(t/3600, AddStates(2,:))
legend("Humidity", "CO2")
hold off

% figure("WindowStyle", "docked");
% hold on 
% plot(t(1:end-1)/3600, Energy_kWh(:))
% hold off
% sum(Energy_kWh(:)*0.2);

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







