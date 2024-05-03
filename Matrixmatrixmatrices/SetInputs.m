% Set user inputs and out-of-power conditions (exam. weather)

% User Inputs

GH.u.Heating = zeros(1, length(t)) ;

% GH.u.Heating(round(length(t)/2) : end) = 500 ;

GH.u.OpenWindowAngle = 30 ;


% Defined conditions

GH.d.           Time = t ;                                 % Time as a field of GH.d
GH.d.           OutsideTemperature = OutsideTemperature ;  % Outside temperature as a field of GH.d
GH.d.           cloud = 1 ; % 0-1

LdClear = 213+5.5*OutsideTemperature;                      % Equation 5.26
epsClear = LdClear./(sigma*(OutsideTemperature+GH.p.Kelvin).^4);   % Equation 5.22
epsCloud = (1-0.84*GH.d.cloud).*epsClear+0.84*GH.d.cloud; % Equation 5.32
LdCloud = epsCloud.*sigma.*(OutsideTemperature+GH.p.Kelvin).^4;    % Equation 5.22

GH.d.           SkyTemperature = (LdCloud/sigma).^(0.25)-GH.p.Kelvin ; % Katzin

GH.d.           SolarIntensity = 1000* ones(1, length(t)) ;%max(0, 50 + 30*sin(2*pi * t/(24*60*60))) ; %!!!!
GH.d.           WindSpeed = 5 * ones(1, length(t)) ; %DUMMY !!! (4.5)
GH.d.           OutsideHumidity = 0.01 * ones(1, length(t)) ; %!!!!
GH.d.           OutsideCO2 = 0.0012 * ones(1, length(t)) ; %!!!!
GH.d.           GroundTemperature = 10 * ones(1, length(t)) ; % DUMMY!!!!!!!!!!!    