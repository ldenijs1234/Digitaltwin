% User Inputs
CO2_injection = 0 ;   % (kg/s), assuming no CO2 regulation, it is possible to include it
OpenWindowAngle = 30 * ones(1, length(t)-1) ; % (°), place-holder, will be overwritten by controller

% Define control bounds, can also be defined via optimization:
error = zeros(1, length(t)-1);                                       % Empty error array
integral = zeros(1, length(t)-1);                                    % Empty integral array
heatingline_total = bound(10, 15, 6, 10, 18, 22, dt, total_time/24); % Setpoint temperature (°C)
heatingline = heatingline_total(SimStart:SimEnd) ;
heatingerror = zeros(1, length(t)-1);                                % Empty error array
coolingline_total = heatingline_total + 10;
coolingline = coolingline_total(SimStart:SimEnd) ;
coolingerror = zeros(1, length(t)-1);                                % Empty error array
meanline = (heatingline + coolingline)/2 ;                           % Average setpoint line

% Weather and energy cost forecasts:

% Set files and date 
date = '2023-11-28' ;                   % Date of the simulation 'yyyy-mm-dd'
file_energy = 'Netherlands.csv';        % File name of the energy cost CSV file
file_weather = 'Delft28-11.csv';        % File name of the weather data CSV file 

[time_vec, OutsideTemperatureF, OutsideRelhumidityF, SolarRadiationF, WindspeedF, WinddirectionF, SealevelpressureF, CloudCoverF, DewPointF] = Weather2Arrays(file_weather, dt, total_time) ;
[price_array_W6D, price_array_W5D, price_array_W4D, simdaycostD, day_averageD] = Energycost(file_energy, dt, total_time, date);

OutsideTemperature = OutsideTemperatureF(SimStart:SimEnd) ; OutsideRelhumidity = OutsideRelhumidityF(SimStart:SimEnd) ;
SolarRadiation = SolarRadiationF(SimStart:SimEnd) ; WindSpeed = WindspeedF(SimStart:SimEnd) ; Winddirection = WinddirectionF(SimStart:SimEnd) ;
Sealevelpressure = SealevelpressureF(SimStart:SimEnd) ; CloudCover = CloudCoverF(SimStart:SimEnd) ; DewPoint = DewPointF(SimStart:SimEnd) ;
price_array_W6 = price_array_W6D(SimStart:SimEnd) ; price_array_W5 = price_array_W5D(SimStart:SimEnd) ; price_array_W4 = price_array_W4D(SimStart:SimEnd) ;
simdaycost = simdaycostD(SimStart:SimEnd) ; day_average = day_averageD(SimStart:SimEnd) ;
SolarIntensity =  SolarRadiation .* (1-0.5*cloud);                         % (W/m^2) Assumption: 50% of radiation gets blocked by clouds
OutsideHumidity =   rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; % (kg/m^3) 
SkyTemperature = SkyTemperature(GH, OutsideTemperature, CloudCover) ;

OutsideCO2 = 0.00049 ;                                                     % (kg/m^3)  assumed to be constant troughout simulation
GroundTemperature = 10  ;                                                  % (°C) Assumed to be constant troughout simulation


