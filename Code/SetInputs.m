% User Inputs
CO2_injection = 0 ;   % (kg/s), assuming no CO2 regulation, it is possible to include it
OpenWindowAngle = 30 * ones(1, length(t)-1) ; % (°), place-holder, will be overwritten by controller

% control inputs
price_per_kWh = zeros(1, length(t)-1) ; % Price per kWh 
price_per_kWh = 0.34 + 0.2 * sind(2*pi*(t));  % Euro

% setpoint_total = bound(18, 22, 6, 10, 18, 22, dt, total_time/24); % Setpoint temperature (°C)
% setpoint = setpoint_total(SimStart:SimEnd) ;

error = zeros(1, length(t)-1); % Empty error array
integral = zeros(1, length(t)-1); % Empty integral array

heatingline_total = bound(10, 15, 6, 10, 18, 22, dt, total_time/24); % Setpoint temperature (°C)
heatingline = heatingline_total(SimStart:SimEnd) ;
heatingerror = zeros(1, length(t)-1); % Empty error array
heatingintegral = zeros(1, length(t)-1); % Empty integral array

coolingline_total = heatingline_total + 10;
coolingline = coolingline_total(SimStart:SimEnd) ;
coolingerror = zeros(1, length(t)-1); % Empty error array

meanline = (heatingline + coolingline)/2 ;  % Average setpoint line

% Weather conditions
cloud = CloudCover./100 ; % 0-1 cloud cover
LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26 (Katzin, 2021)
epsClear = LdClear./(sigma*(OutsideTemperature+273.15).^4);   % Equation 5.22 (Katzin, 2021)
epsCloud = (1-0.84*cloud).*epsClear+0.84*cloud;             % Equation 5.32 (Katzin, 2021)
LdCloud = epsCloud.*sigma.*(OutsideTemperature+273.15).^4;    % Equation 5.22 (Katzin, 2021)

SkyTemperature = (LdCloud/sigma).^(0.25)-273.15 ; % (Katzin, 2021)

SolarIntensity =  SolarRadiation .* (1-0.5*cloud); % (W/m^2) Assumption 50% of radiation blocked by clouds
OutsideHumidity =   rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; % (kg/m^3) 

OutsideCO2 = 0.00049 ; % (kg/m^3)  assumed to be constant troughout simulation
GroundTemperature = 10  ; % (°C) Assumed to be constant troughout simulation


