% Set user inputs and out-of-power conditions (exam. weather)

% User Inputs

Heating = 000* ones(1, length(t)-1) ;

% GH.u.Heating(round(length(t)/2) : end) = 500 ;

GH.u.OpenWindowAngle = 20 ;


% Defined conditions
% [time_vec, OutsideTemperature, OutsideRelhumidity, SolarRadiation, Windspeed, Winddirection, Sealevelpressure, CloudCover] = interpolate_weather_data(filename, dt);


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


SolarIntensity =  SolarRadiation ; %!!!!

OutsideHumidity =   rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; %!!!!

OutsideCO2 = 0.0012 ;%* ones(1, length(t)) ; %!!!!
GroundTemperature = 10  ; % DUMMY!!!!!!!!!!!    


% VentilationRate = 5; 