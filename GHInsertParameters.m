% Bro gun parameters
% General parameters
GH.p.           cp_air = 1003.5 ; %J kg^-1 K^-1
GH.p.           cp_glass = 840 ; %J kg^-1 K^-1
GH.p.           cp_water = 4186 ;%J kg^-1 K^-1
GH.p.           cp_floor = 800 ; %DUMMY
GH.p.           rho_air = 1.2 ; %kg m^-3
GH.p.           rho_glass = 2500 ; %kg m^-3
GH.p.           rho_floor = 2000 ; %DUMMY
GH.p.           GasConstantR = 8.314 ; % J/mol K
GH.p.           StefBolzConst = 5.670374419e-8 ; % W/m^2 K^4 
GH.p.           Gravity = 9.81 ; % m/s^2 ;
GH.p.           Kelvin = 273.15 ;

% Defined constants (can also be input),  need to get a different location
dt = 5 ;                                  % Time interval of 5 seconds
simulation_time = 24   *60*60 ;            % Simulation time in hours 
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;     % simulation time space
OutsideTemperature = 15*ones(1, length(t)) ;%+ 5*sin(2*pi * t/(24*60*60)) ;  % Sinus outside temperature

GH.d.Time = t ;                                 % Time as a field of GH.d
GH.d.           OutsideTemperature = OutsideTemperature ;  % Outside temperature as a field of GH.d
GH.d.cloud = 1 ; % 0-1

LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26
epsClear = LdClear./(GH.p.StefBolzConst*(OutsideTemperature+GH.p.Kelvin).^4);   % Equation 5.22
epsCloud = (1-0.84*GH.d.cloud).*epsClear+0.84*GH.d.cloud; % Equation 5.32
LdCloud = epsCloud.*GH.p.StefBolzConst.*(OutsideTemperature+GH.p.Kelvin).^4;    % Equation 5.22

GH.d.           SkyTemperature = (LdCloud/GH.p.StefBolzConst).^(0.25)-GH.p.Kelvin ; % Katzin

GH.d.           SolarIntensity = 1000* ones(1, length(t)) ;%max(0, 50 + 30*sin(2*pi * t/(24*60*60))) ; %!!!!
GH.d.SolarIntensity(round(length(t)/2) : end) = 0 ;
GH.d.           WindSpeed = 5 * ones(1, length(t)) ; %DUMMY !!! (4.5)
GH.d.           OutsideHumidity = 0.01 * ones(1, length(t)) ; %!!!!
GH.d.           OutsideCO2 = 0.0400 * ones(1, length(t)) ; %!!!!
GH.d.           GroundTemperature = 10 * ones(1, length(t)) ; % DUMMY!!!!!!!!!!!         



% Greenhouse parameters                 ALL DUMMY!!!!!!!!!!!!!
GH.p.           GHWidth = 10 ; %m 
GH.p.           GHLength = 10 ; %m
GH.p.           GHHeight = 3 ; %m
GH.p.           GHWallThickness = 3e-3 ; %m
GH.p.           GHFloorThickness = 1e-2 ;	%m

GH.p.           NumberOfWindows = 10 ; 
GH.p.           WindowLength = 0.2 ;
GH.p.           WindowHeight = 0.1 ;
GH.p.           RoofAngle = 10 ; % degrees

GH.p.           WindowArea = GH.p.WindowHeight*GH.p.WindowLength ;
GH.p.           GHVolume = GH.p.GHLength*GH.p.GHWidth*GH.p.GHHeight ;
GH.p.           GHFloorArea = GH.p.GHLength * GH.p.GHWidth ;
GH.p.           GHSideArea1 = GH.p.GHLength * GH.p.GHHeight ;
GH.p.           GHSideArea2 = GH.p.GHWidth * GH.p.GHHeight ;
GH.p.           GHTotalArea = GH.p.GHFloorArea + 2* GH.p.GHSideArea1 + 2* GH.p.GHSideArea2 ;
GH.p.           GHPlantArea = 0.3 * GH.p.GHFloorArea ; %DUMMY

% Temperature equations parameters
GH.p.           h_WallOutside = 5 ; %DUMMY
GH.p.           h_WallInside = 1 ; %DUMMY
GH.p.           AlfaGlass = 0.04 ; %DUMMY
GH.p.           EmittanceGlass = 0.8 ; %DUMMY
GH.p.           TauGlass = 0.80 ;
GH.p.           EmittanceFloor = 0.9 ; %DUMMY
GH.p.           h_Floor = 3 ; %DUMMY
GH.p.           AlfaGround = 0.3 ; %accurate enough for prototype
GH.p.           LFloorGround = 19e-2 ; % meter
GH.p.           EmittanceGlassSky = GH.p.EmittanceGlass ; %DUMMY

% Plant parameters
GH.p.           h_Plant = 1 ; %DUMMY
GH.p.           cp_lettuce = 4020 ;
GH.p.           EmittancePlant = 0.90 ; %DUMMY
GH.p.           YieldFactor = 0.544 ; %- (effective CO2 use efficiency)
GH.p.           C_resp = 2.65e-7 ; %s^-1 (respiration rate in terms of respired dry matter)

% Humidity equations parameters
GH.p.           C_pld = 53 ; %m^2 kg^-1 (effective canopy surface)
GH.p.           C_vplai = 3.6e-3 ; %m s^-1 (canopy transpiration mass transfer coefficient)
GH.p.           C_v1 = 9348 ; %J m^-3 (parameter defining saturation water vapor pressure)
GH.p.           C_v2 = 17.4 ; %K (parameter defining saturation water vapor pressure)    
GH.p.           C_v3 = 239 ; %K (parameter defining saturation water vapor pressure)  

% CO2 equations parameters
GH.p.           C_RadPhoto = 3.55e10-9 ; %kg J^-1 (light use efficiency)
GH.p.           C_R = 5.2e-5 ; %kg m^-3 (CO2 compensation point)
GH.p.           C_CO21 = 5.11e-6 ; %m s^-1 K^-1 (temperature effect on CO2 diffiusion in leaves)
GH.p.           C_CO22 = 2.3e-4 ; %m s^-1 K^-1 (temperature effect on CO2 diffiusion in leaves)
GH.p.           C_CO23 = 6.29e-4 ; %m s^-1 K^-1 (temperature effect on CO2 diffiusion in leaves)

% Ventilation parameters
GH.p.           C_f = 0.6 ; % Discharge of energy by friction
GH.p.           BetaAir = 1/283 ; % Thermal expansion coefficient