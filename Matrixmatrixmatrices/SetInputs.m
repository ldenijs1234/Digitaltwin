% Set user inputs and out-of-power conditions (exam. weather)

% User Inputs

GH.u.Heating = zeros(1, length(t)) ;

% GH.u.Heating(round(length(t)/2) : end) = 500 ;

GH.u.OpenWindowAngle = 30 ;


% Defined conditions


OutsideTemperature = OutsideTemperature ;  % Outside temperature as a field of GH.d
cloud = CloudCover./100 ; % 0-1 cloud cover

LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26
epsClear = LdClear./(sigma*(OutsideTemperature+273.15).^4);   % Equation 5.22
epsCloud = (1-0.84*cloud).*epsClear+0.84*cloud; % Equation 5.32
LdCloud = epsCloud.*sigma.*(OutsideTemperature+273.15).^4;    % Equation 5.22

GH.d.           SkyTemperature = (LdCloud/sigma).^(0.25)-273.15 ; % Katzin

SolarIntensity =  SolarRadiation ;%max(0, 50 + 30*sin(2*pi * t/(24*60*60))) ; %!!!!
WindSpeed = WindSpeed ;%* ones(1, length(t)) ; %DUMMY !!! (4.5)
GH.d.           OutsideHumidity = rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; %!!!!
GH.d.           OutsideCO2 = 0.0012 * ones(1, length(t)) ; %!!!!
GH.d.           GroundTemperature = 10 * ones(1, length(t)) ; % DUMMY!!!!!!!!!!!    