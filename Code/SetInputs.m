% Set user inputs and out-of-power conditions (exam. weather)

% User Inputs

CO2_injection = 0 ;   % kg/s
OpenWindowAngle = 30 * ones(1, length(t)-1) ;

function y = bound(min, max, t1, t2, t3, t4, dt, days) %inputs: minimum and maximum, minimum before t1 and after t4, maximum at t2:t3
    time = (0:dt:24*60^2) / 60^2;
    a = min * ones(1,round(length(time) * t1 / 24));
    b = linspace(min, max, round(length(time) * (t2 - t1) / 24));
    c = max * ones(1, round(length(time) * (t3 - t2)/ 24));
    d = linspace(max, min, round(length(time) * (t4 - t3) / 24));
    e = min * ones(1, round(length(time) * (24 - t4) /24));
    y = [min,a, b, c, d, e];
    y = repmat(y, 1, days);
end
% control inputs
price_per_kWh = zeros(1, length(t)-1) ; % Price per kWh 
price_per_kWh = 0.34 + 0.2 * sind(2*pi*(t));  % Euro
setpoint = bound(18, 22, 6, 10, 18, 22, dt, 2); % Setpoint temperature (°C)
error = zeros(1, length(t)-1); % Error array
integral = zeros(1, length(t)-1); % Integral array
cloud = CloudCover./100 ; % 0-1 cloud cover

% SolarRadiation = 100 + 100*sin(2*pi * t/(24*60*60)) ; 
% cloud = 0.7
% OutsideTemperature = 15 + 5*sin(2*pi * t/(24*60*60)) ;%OutsideTemperature ;  % Outside temperature as a field of GH.d
% WindSpeed = 4.5 * ones(1, length(t)) ; %DUMMY !!! (4.5)
% OutsideHumidity =  0.01* ones(1, length(t)) ;

LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26
epsClear = LdClear./(sigma*(OutsideTemperature+273.15).^4);   % Equation 5.22
epsCloud = (1-0.84*cloud).*epsClear+0.84*cloud; % Equation 5.32
LdCloud = epsCloud.*sigma.*(OutsideTemperature+273.15).^4;    % Equation 5.22

SkyTemperature = (LdCloud/sigma).^(0.25)-273.15 ; % Katzin


SolarIntensity =  SolarRadiation .* (1-cloud); % Data already in the form of intensity
OutsideHumidity =   rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; %!!!!

OutsideCO2 = 0.0012 ; %kg/m^3
GroundTemperature = 10  ; % DUMMY!!!!!!!!!!!    
T_water(1) = 15 ;

