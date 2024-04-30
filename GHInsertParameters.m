% Bro gun parameters


dt = 60 ;                                  % Time interval of one minute
simulation_time = 24   *60*60 ;            % Simulation time in hours 
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;     % simulation time space
OutsideTemperature = 15 + 5*sin(2*pi * t/(24*60*60)) ;  % Sinus outside temperature

GH.d.Time = t ;                                 % Time as a field of GH.d
GH.d.OutsideTemperature = OutsideTemperature ;  % Outside temperature as a field of GH.d
GH.d.SkyTemperature = 0.05 * GH.d.OutsideTemperature ; %!!!!
GH.d.SolarIntensity = 500 + 500*sin(2*pi * t/(24*60*60)) ; %!!!!
GH.d.WindSpeed = 4.5 * ones(1, length(t)) ; %DUMMY !!!
GH.d.GHPlantArea = 0.5 * GH.p.GHFloorArea ; %!!!!
GH.d.OutsideHumidity = 0.05 ; %!!!!

% General parameters
GH.p.           cp_air = 1003.5 ;
GH.p.           cp_glass = 840 ;
GH.p.           cp_water = 4186 ;
GH.p.           cp_lettuce = 4020 ;
GH.p.           cp_floor = 800 ; %DUMMY
GH.p.           rho_air = 1.2 ;
GH.p.           rho_glass = 2500 ;
GH.p.           rho_floor = 2000 ; %DUMMY
GH.p.           GasConstantR = 8.314 ; % J/mol K
GH.p.           StefBolzConst = 5.670374419e-8 ; % W/m^2 K^4 
GH.p.           Gravity = 9.81 % m/s^2 ;

% Greenhouse parameters                 ALL DUMMY!!!!!!!!!!!!!
GH.p.           GHWidth = 10 ;
GH.p.           GHLength = 10 ;
GH.p.           GHHeight = 3 ;
GH.p.           GHWallThickness = 3e-3 ;
GH.p.           GHFloorTickness = 0.1 ;	

GH.p.           NumberOfWindows = 10 ; 
GH.p.           WindowLength = 1 ;
GH.p.           WindowHeight = 2 ;
GH.p.           RoofAngle = 10 ; % degrees

GH.p.           WindowArea = GH.p.WindowHeight*GH.p.WindowLength ;
GH.p.           GHVolume = GH.p.GHLength*GH.p.GHWidth*GH.p.GHHeight ;
GH.p.           GHFloorArea = GH.p.GHLength * GH.p.GHWidth ;
GH.p.           GHSideArea1 = GH.p.GHLength * GH.p.GHHeight ;
GH.p.           GHSideArea2 = GH.p.GHWidth * GH.p.GHHeight ;
GH.p.           GHTotalArea = GH.p.GHFloorArea + 2* GH.p.GHSideArea1 + 2* GH.p.GHSideArea2 ;

% Temperature equations parameters
GH.p.           h_WallOutside = 100 ; %DUMMY
GH.p.           h_WallInside = 50 ; %DUMMY
GH.p.           AlfaGlass = 0.04 ; %DUMMY
GH.p.           EmittanceGlass = 0.8 ; %DUMMY
GH.p.           TauGlass = 0.91 ;
GH.p.           EmittanceFloor = 0.9 ; %DUMMY
GH.p.           h_Floor = 100 ; %DUMMY
GH.p.           AlfaGround = 10 ; %DUMMY

% Humidity equations parameters



% CO2 equations parameters


% Ventilation parameters
GH.p.           C_f = 0.6 ; % Discharge of energy by friction
GH.p.           BetaAir = 1/283 ; % Thermal expansion coefficient