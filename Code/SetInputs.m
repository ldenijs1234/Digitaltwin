% User Inputs
CO2_injection = 0 ;   % (kg/s), assuming no CO2 regulation, it is possible to include it

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
Lowerbound = 10 * ones(size(t));
Upperbound = 20 * ones(size(t));

% Weather and energy cost forecasts:

% Set files and date 
file_energy = 'Netherlands.csv';        % File name of the energy cost CSV file
file_weather = 'Delft28-11.csv';        % File name of the weather data CSV file 

[time_vec, OutsideTemperatureF, OutsideRelhumidityF, SolarRadiationF, WindspeedF, WinddirectionF, SealevelpressureF, CloudCoverF, DewPointF] = Weather2Arrays(file_weather, dt, total_time) ;
[price_array_W6D, price_array_W5D, price_array_W4D, simdaycostD, day_averageD] = Energycost(file_energy, dt, total_time, date);

OutsideTemperature = OutsideTemperatureF(SimStart:SimEnd) ; OutsideRelhumidity = OutsideRelhumidityF(SimStart:SimEnd) ;
SolarRadiation = SolarRadiationF(SimStart:SimEnd) ; WindSpeed = WindspeedF(SimStart:SimEnd) ; Winddirection = WinddirectionF(SimStart:SimEnd) ;
Sealevelpressure = SealevelpressureF(SimStart:SimEnd) ; CloudCover = CloudCoverF(SimStart:SimEnd) ; DewPoint = DewPointF(SimStart:SimEnd) ;
price_array_W6 = price_array_W6D(SimStart:SimEnd) ; price_array_W5 = price_array_W5D(SimStart:SimEnd) ; price_array_W4 = price_array_W4D(SimStart:SimEnd) ;
simdaycost = simdaycostD(SimStart:SimEnd) ; day_average = day_averageD(SimStart:SimEnd) ;
SolarIntensity =  SolarRadiation .* (1-0.5*CloudCover/100);                         % (W/m^2) Assumption: 50% of radiation gets blocked by clouds
OutsideHumidity =   rh2vaporDens(OutsideTemperature, OutsideRelhumidity) ; % (kg/m^3) 
SkyTemperature = SkyTemperatureCalc (GH, OutsideTemperature, CloudCover) ;

OutsideCO2 = 0.00049 ;                                                     % (kg/m^3)  assumed to be constant troughout simulation
GroundTemperature = 10  ;                                                  % (°C) Assumed to be constant troughout simulation


