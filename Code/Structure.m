% Main calculation script, defining functions based on state vectors, then integrating using euler integration.
% Parameters such as area or heat transfer coefficient are inserted as an array corresponding with the state vector for
% easy and faster calculation.
%
% Temperature states of different elements in the greenhouse, saved in vector T:
%       Temperature state 1: Air        (°C)
%       Temperature state 2: Cover      (°C)
%       Temperature state 3: Wall       (°C)
%       Temperature state 4: Floor      (°C)
%       Temperature state 5: Plant      (°C)
%       Temperature state 6: Heatpipe   (°C)
%
% Additional states not regarding temperature are saved in a second state vector, AddStates:
%       Additional state 1: Inside humidity             (kg m^-3)
%       Additional state 2: Inside CO2 concentration    (kg m^-3)
%       Additional state 3: Dry mass plant              (kg)
%       Additional state 4: Total mass plant            (kg)
% 
% All interactions between states are calculated in the for-loop used for euler integration

Belowbound = false;

function Q = FQ_rad_out(emissivity, T, Area)                          % Calculation of emitted radiation per object
    Q = 5.670374419e-8 * emissivity .* Area .* ((T + 273.15).^4);    
end                                                             


function Q = FQ_rad_in(absorbance, diffuse, Viewf, Qrad)      % Calculation of absorbed radiation per object using view factors
    Q =(absorbance .* Viewf * Qrad);                       
    Q(1,:) = sum(diffuse .* Viewf * Qrad) * 0.7;              % Assumption: inside air recieves 70% of diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun, Area)    % Calculation of absorbed solar radiation per object
    Q = transmission .* absorbance .* Areasun * Isun; 
    dif = sum(diffuse(4:end,:) .* Areasun(4:end,:) * Isun);                      % All solar radiation that is diffused
    Q = [diffuse(2); Area(2) / sum(Area(2:3)) * ...
    absorbance(2); Area(3) / sum(Area(2:3)) * absorbance(3); 0; 0; 0] * dif + Q;   % Diffused solar radiation gets absorbed by glass, or rediffused and absorbed by the air
end

function Q = FQ_sky(Area, absorbance, emissivity, TSky, T)  % Calculation of sky emission using effective sky temperature
    Q = 5.670374419*10^-8 * Area .* (absorbance * (TSky + 273.15).^4 - emissivity .* ((T + 273.15).^4) ); 
end


function Q = convection(hin, hout, T, T_out, Area)                  % Convective heat flows
    Convection_matrix = - eye(length(T));
    Convection_matrix(:, 1) = 1;
    Convection_matrix(1,1) = 0;
    dT = Convection_matrix * T ;
    Q  = Area .* hin .* dT ;
    Q(1) = -sum(Q) ;                                                % Convective heat flow to air
    Q_out = Area(2:3) .* hout .* ([T_out; T_out] - T(2:3)) ;        % Convection of wall and cover with outside air
    Q(2:3) = Q(2:3) + Q_out; 
end

function [Q, QFloor] = FGroundConduction(GH, FloorTemperature, T)  % Calculation of conduction between floor layers
    
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

function Q = LatentHeat(mf)    % Latent heat of evaporation of water mass flow mf
    Q = 2.45e6 * mf ;
end

function Q = HeatByVentilation(GH, T_air, T_out, VentilationRate) % Calculation of heat exchange due to ventilation
    massflow = GH.p.rho_air *  VentilationRate ;
    Q = (T_out - T_air) * massflow * GH.p.cp_air ;
end

function h_af = ConvFloor(T_floor, T_in) % Convection coefficient between floor and air [De Zwart, 1996] 
    if T_floor > T_in
        h_af = 1.7 * (T_floor - T_in)^(1/3);
    else 
        h_af = 1.7 * (T_in - T_floor)^(1/4);
    end
    % (W m^-2 K^-1)
end

function [W_trans, W_cond, W_vent, W_fog] = vaporflows(GH, T_air, T_wall, T_out, H_air, H_out, DryMassPlant, VentilationRate, U_fog)
    
    G_c = 1.8e-3 * (max(0, (T_air - T_wall)))^(1/3) ; % (m/s) [Bontsema et al, 2007]

    % (kg s^-1)
    W_trans = max(0, (1 - exp(-GH.p.C_pld * DryMassPlant / GH.p.GHFloorArea)) * GH.p.C_vplai * ... 
    ((GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (T_air + 273.15))) ...
    * exp(GH.p.C_v2 * T_air / (T_air + GH.p.C_v3)) ...
    - H_air) * GH.p.GHFloorArea );   % [Van Henten, 2003]  
    W_cond = max(0, (G_c * (0.2522 * exp(0.0485 * T_air) * (T_air ... 
    - T_out) - ((5.5638 * exp(0.0572 * T_air)) - H_air*1000)))/1000 * GH.p.GHFloorArea) ; % [Bontsema et al, 2007]
    W_vent = VentilationRate * (H_air - H_out) ; 
    W_fog = GH.p.phi_fog * U_fog ; % Controller input [De Zwart, 1996]

end

function HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent, W_fog)
    W = - W_vent - W_cond + W_trans + W_fog;  
    HumidityDot = W / GH.p.GHVolume ; % (kg m^-3 s^-1)
end

function [C_trans, C_vent, C_respD, C_respC] = CO2flows(GH, DryMassPlant, SolarIntensity, T_air, C_in, C_out, VentilationRate)
    % (kg s^-1)
    C_trans = (1 - exp(-GH.p.C_pld * DryMassPlant/GH.p.GHFloorArea)) * ((GH.p.C_RadPhoto * SolarIntensity * ... 
    (-GH.p.C_CO21 * T_air^2 + GH.p.C_CO22 * T_air - GH.p.C_CO23) * (C_in - GH.p.C_R)) / ... 
    (GH.p.C_RadPhoto * SolarIntensity + (-GH.p.C_CO21 * T_air^2 + GH.p.C_CO22 * T_air - ... 
    GH.p.C_CO23) * (C_in - GH.p.C_R))) * GH.p.GHFloorArea ;   % [Van Henten, 2003]
    C_vent = VentilationRate * (C_in - C_out) ; 
    C_respD = GH.p.C_resp*(DryMassPlant / GH.p.GHFloorArea) * 2^(0.1*T_air- 2.5) ;
    C_respC = GH.p.C_respC*(DryMassPlant / GH.p.GHFloorArea) * 2^(0.1*T_air- 2.5) ;
end

function CO2Dot = CO2Balance(GH, C_trans, C_vent, C_inject, C_respC)
    C = - C_trans - C_vent + C_inject + C_respC;
    CO2Dot = C / GH.p.GHVolume ; % (kg m^-3 s^-1)
end

function DryWeightDot = DryWeight(GH, C_trans, C_respD)
    DryWeightDot = GH.p.YieldFactor*C_trans - C_respD ; % [Van Henten, 2003]
end


function VentilationRate = VentilationRatecalc(GH, T_air, WindSpeedkph, T_out, OpenWindowAngle) 
    % Calculation of ventilation rate, assuming no leakage [De Zwart, 1996]
    p = GH.p ; 
    WindSpeed = WindSpeedkph / 3.6 ; % Conversion of data units (m/s)
    G_l = 2.29e-2 * (1 - exp(-OpenWindowAngle/21.1)) ; % Leeside window function
    G_w = 1.2e-3 * OpenWindowAngle * exp(OpenWindowAngle/211) ; % Windward side window function
    v_wind = (G_l + G_w) * p.WindowArea * WindSpeed ;
    H = p.WindowHeight * (sind(p.RoofAngle)- sind(p.RoofAngle - OpenWindowAngle)) ;
    v_temp = p.C_f * p.WindowLength/3 * (abs(p.Gravity*p.BetaAir*(T_air ... 
    - T_out)))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * p.NumberOfWindows * (v_wind^2 + v_temp^2)^(0.5) ; % (kg s^-1)
end

hWaitBar = waitbar(0, 'Please wait...') ;

%simdaycost = 0.5 * ones(size(t)) ; simdaycost(round(1/3*length(t)): round(2/3* length(t))) = 0.02 ;

% For-loop containing euler-integration of states and inter-state dynamics:
for i = 1:length(t) - 1
    
    % Controller inputs
    
    %setpoint(i) = setpoint(T(1,i+60), T(1,i), simdaycost(i+60), simdaycost(i), meanline(i), dt)  ;

    [h_pipeout(i), Q_heat(6,i), water_arrayOut] = heating_pipe(GH, T_WaterIn(i), T(1,i), T(6,i), dt, water_array) ;
    T_WaterOut(i) = water_arrayOut(end) ; water_array = water_arrayOut ;

    [integral(i+1), heatingerror(i + 1), ControllerOutputWatt(i)] = PIController(GH ,T(1,i), Setpoint(i), dt, integral(i), heatingerror(i)) ;
    [coolingerror(i), OpenWindowAngle(i), U_fog(i)] = WindowController(T(1,i), Upperbound(i));
    
    T_WaterIn(i+1) = min(99,T_WaterOut(i) + ControllerOutputWatt(i) / (GH.p.Npipes*GH.p.m_flow * GH.p.cp_water)) ;

    
    %Variable parameter functions (+ convection rate, ventilation rate...)
    VentilationRate(i) = VentilationRatecalc(GH, T(1, i), WindSpeed(i), OutsideTemperature(i), OpenWindowAngle(i)) ;

    [h_insidewall(i), h_ceiling(i)] = inside_convection(GH, T(3, i), T(2, i), T(1, i),AddStates(1,i),AddStates(2,i));
    ConvectionCoefficientsOut(:,i) = (ConvCoefficients(GH, T(3, i), OutsideTemperature(i), WindSpeed(i), OutsideHumidity(i), OutsideCO2, Winddirection(i), Sealevelpressure(i))).' ;
    ConvectionCoefficientsIn(4,i) = ConvFloor(T(4, i), T(1, i)) ;
    ConvectionCoefficientsIn(2,i) = h_ceiling(i) ; %h_ac ;
    ConvectionCoefficientsIn(3,i) = h_insidewall(i) ; %h_ac ;
    ConvectionCoefficientsIn(5,i) = h_ap ;
    ConvectionCoefficientsIn(6,i) = h_pipeout(i) ;
    
    if AddStates(4,i) == 0
        MassPlant = MassPlanInit ;
      else
        MassPlant = AddStates(4,i) ; 
    end

    cp_airVar = AirProperties(T(1,i), 1084, RelHumidity(i), 'c_p') ;
    rho_airVar = AirProperties(T(1,i), 1084, RelHumidity(i), 'rho') ;

    % Redefining CAPs for new humidity and plant mass
    CAPArray = [cp_airVar * rho_airVar * GH.p.GHVolume; 
                GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(2);
                GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(3);
                GH.p.cp_floor * GH.p.rho_floor * GH.p.GHFloorArea * GH.p.GHFloorThickness;
                GH.p.cp_lettuce * MassPlant;
                GH.p.Vpipe*GH.p.rho_steel*GH.p.cp_steel];  
    
    ConvAreaArray(5) = MassPlant * GH.p.C_pld  ; % Effect plant surface

    % Vapor flows and balance
    [W_trans(i), W_cond(i), W_vent(i), W_fog(i)] = vaporflows(GH, T(1, i), T(2, i), OutsideTemperature(1,i), AddStates(1, i), OutsideHumidity(i), AddStates(3,i), VentilationRate(i),  U_fog(i));
    HumidityDot = HumidityBalance(GH, W_trans(i), W_cond(i), W_vent(i), W_fog(i));
    NewHumidity = AddStates(1, i) + HumidityDot*dt ;
    
    
    % CO2 flows and balance
    [C_trans(i), C_vent(i), C_respD(i), C_respC(i)] = CO2flows(GH, AddStates(3,i), SolarIntensity(i), T(1, i), AddStates(2, i), OutsideCO2, VentilationRate(i)) ;
    CO2Dot = CO2Balance(GH, C_trans(i), C_vent(i), CO2_injection, C_respC(i)) ;
    DryWeightDot = DryWeight(GH, C_trans(i), C_respD(i)) ;
    AddStates(2, i+1) = AddStates(2, i) + CO2Dot*dt ;
    AddStates(3, i+1) = AddStates(3, i) + DryWeightDot*dt ;
    AddStates(4, i+1 ) = AddStates(3, i+1) / 0.05 ;

    % Q functions (+ convection conduction...)
    FloorTemperature(1, i) = T(4, i) ;
    [Q_ground(:, i), QFloor(:, i)] = FGroundConduction(GH, FloorTemperature(:, i), T(:, i)) ;
    FloorTemperature(:, i+1) = FloorTemperature(:, i) + QFloor(:, i) * GH.p.GHFloorArea / CAPArray(4) * dt ;

    Q_rad_out(:,i) = FQ_rad_out(EmmitanceArray, T(:,i), AreaArrayRad);
    Q_rad_in(:,i) = FQ_rad_in(FIRAbsorbanceArray, FIRDiffuseArray, ViewMatrix, Q_rad_out(:,i));
    Q_solar(:,i) = FQ_solar(TransmissionArray, SOLARDiffuseArray, SOLARAbsorbanceArray, AreaSunArray, SolarIntensity(i), AreaArray);
    Q_sky(2:3,i) = FQ_sky(AreaArray(2:3), FIRAbsorbanceArray(2:3), EmmitanceArray(2:3), SkyTemperature(i), T(2:3,i));
    Q_conv(:,i) = convection(ConvectionCoefficientsIn(:,i), ConvectionCoefficientsOut(:, i), T(:,i), OutsideTemperature(i), ConvAreaArray);
    Q_vent(1, i) = HeatByVentilation(GH, T(1, i), OutsideTemperature(i), VentilationRate(i)) ; 
    Q_vent(2: height(T), i) = zeros(height(T)-1, 1) ;
    Q_latent(5, i) = LatentHeat(-W_trans(i)) ; Q_latent(2, i) = LatentHeat(W_cond(i)) ;
    Q_latent(1, i) = LatentHeat(-W_vent(i)) + LatentHeat(-W_cond(i)) + LatentHeat(-W_fog(i))+ LatentHeat(W_trans(i)) ;

    %Total heat transfer 
    Q_tot(:,i) = Q_vent(:, i) + Q_sky(:,i) + Q_conv(:,i) + Q_ground(:, i) + Q_solar(:,i) + Q_rad_in(:,i) - Q_rad_out(:,i) + Q_heat(:,i) + Q_latent(:, i);

    % Temperature Change
    T(:, i + 1) = T(:,i) + Q_tot(:,i) ./ CAPArray * dt;
    FloorTemperature(1, i) = T(4,i) ;
    Energy_kWh(i) = ControllerOutputWatt(i) * dt / (1000 * 3600);  % Convert from W to kWh

    if  BoundBreak == true && T(1,i) < Lowerbound(i)
        Belowbound = true;
        display("Too Cold")
        t_belowbound(n) = i;
        hour_belowbound(n) = ceil(t_belowbound(n)/3600*dt);
        % run("plots")
        break
    end

    
    % Bound for maximal humidity
    MaxHumidity = rh2vaporDens(T(1,i+1), 100) ;
    AddStates(1, i+1) = min(MaxHumidity, NewHumidity) ;
    W_CondHum(i) = max(0, NewHumidity - MaxHumidity) ;
    RelHumidity(i+1) = min(100, VaporDens2rh(T(1,i+1), AddStates(1,i+1))) ; % Correction for calculation differences in functions


    if rem(i*dt/360, 1) == 0 
        waitbar(sqrt(i*dt / simulation_time), hWaitBar, sprintf('Progress: %d%%', round(sqrt(i*dt / simulation_time) * 100)));
    end

end

close(hWaitBar);

% Plot temperatures:
% figure("WindowStyle", "docked");
% hold on
% plot(t/3600, T(:,:))
% plot(t/3600, OutsideTemperature, 'b--')
% plot(t/3600, Setpoint, 'Linewidth', 8) 
% plot(t/3600, heatingline, 'r--') 
% plot(t/3600, coolingline, 'c--')
% title("Temperatures in the greenhouse")
% xlabel("Time (h)")
% ylabel("Temperature (°C)")
% legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Heating Line', 'Cooling Line')
% hold off

% Calculate the total energy cost used for greenhouse control:
if Belowbound == false
    disp(sum(Energy_kWh.*simdaycost(1:end-1)));
end








