% Set user inputs and out-of-power conditions (exam. weather)

% User Inputs

GH.u.Heating = zeros(1, length(t)) ;

% GH.u.Heating(round(length(t)/2) : end) = 500 ;

GH.u.OpenWindowAngle = 30 ;


% Defined conditions


OutsideTemperature = 15 ;%OutsideTemperature ;  % Outside temperature as a field of GH.d
cloud = 0.7 ;%CloudCover./100 ; % 0-1 cloud cover
SolarRadiation = 300 ; 

LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26
epsClear = LdClear./(sigma*(OutsideTemperature+273.15).^4);   % Equation 5.22
epsCloud = (1-0.84*cloud).*epsClear+0.84*cloud; % Equation 5.32
LdCloud = epsCloud.*sigma.*(OutsideTemperature+273.15).^4;    % Equation 5.22

SkyTemperature = (LdCloud/sigma).^(0.25)-273.15 ; % Katzin

SolarIntensity =  (1-cloud) * SolarRadiation ;%max(0, 50 + 30*sin(2*pi * t/(24*60*60))) ; %!!!!
WindSpeed = 4.5 ;%WindSpeed ;%* ones(1, length(t)) ; %DUMMY !!! (4.5)
OutsideHumidity = 0.01 ;%rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; %!!!!
OutsideCO2 = 0.0012 ;%* ones(1, length(t)) ; %!!!!
GH.d.           GroundTemperature = 10  ; % DUMMY!!!!!!!!!!!    


VentilationRate = 5; 