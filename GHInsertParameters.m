% Bro gun parameters


dt = 60 ;                                  % Time interval of one minute
GH.d.dt = dt ;
simulation_time = 24   *60*60 ;            % Simulation time in hours 
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;     % simulation time space
OutsideTemperature = 15 + 5*sin(2*pi * t/(24*60*60)) ;  % Sinus outside temperature

GH.d.Time = t ;                                 % Time as a field of GH.d
GH.d.OutsideTemperature = OutsideTemperature ;  % Outside temperature as a field of GH.d
GH.d.SkyTemperature = 0.05 * GH.d.OutsideTemperature ; %!!!!
GH.d.SolarIntensity = 500 + 500*sin(2*pi * t/(24*60*60)) ; %!!!!

% General parameters
GH.p.           cp_air = 1003.5 ;
GH.p.           cp_glass = 840 ;
GH.p.           rho_air = 1.2 ;
GH.p.           rho_glass = 2500 ;
GH.p.           GasConstantR = 8.314 ; % J/mol K
GH.p.           StefBolzConst = 5.670374419 * 10^(-8) ; 

% Greenhouse parameters
GH.p.           GHWidth = 10 ;
GH.p.           GHLength = 10 ;
GH.p.           GHHeight = 3 ;
GH.p.           GHVolume = GH.p.GHLength*GH.p.GHWidth*GH.p.GHHeight ;
GH.p.           GHGroundArea = GH.p.GHLength * GH.p.GHWidth ;
GH.p.           GHSideArea1 = GH.p.GHLength * GH.p.GHHeight ;
GH.p.           GHSideArea2 = GH.p.GHWidth * GH.p.GHHeight ;
GH.p.           GHTotalArea = GH.p.GHGroundArea + 2* GH.p.GHSideArea1 + 2* GH.p.GHSideArea2 ;
GH.p.           WallThickness = 3 * 10^(-3) ;

% Temperature equations parameters
GH.p.           h_WallOutside = 100 ; %DUMMY
GH.p.           h_WallInside = 50 ; %DUMMY
GH.p.           AlfaGlass = 0.04 ; %DUMMY
GH.p.           EmittanceGlass = 0.8 ; %DUMMY



% Humidity equations parameters



% CO2 equations parameters

