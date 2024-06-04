run("SetModel")

SimCount = 0 ;                              % Delete when running multiple simulations after one another
time_steps = simulation_time/dt+1 ;
SimCount = SimCount + 1 ;                   % Keep count on number of simulations done
SimStart = time_steps*(SimCount-1) + 1 ;    % Define interval start based on SimCount
SimEnd = time_steps*SimCount ;              % Define interval end based on SimCount

% Set files and date 
date = '2024-05-30' ; % Date of the simulation 'yyyy-mm-dd'
file = 'Netherlands.csv'; % File name of the energy cost CSV file
filename = 'Delft30-5.csv'; % File name of the weather data CSV file 

[time_vec, OutsideTemperatureF, OutsideRelhumidityF, SolarRadiationF, WindspeedF, WinddirectionF, SealevelpressureF, CloudCoverF, DewPointF] = Weather2Arrays(filename, dt, total_time) ;
[price_array_W6D, price_array_W5D, price_array_W4D, simdaycostD, day_averageD] = Energycost(file, dt, total_time, date);


OutsideTemperature = OutsideTemperatureF(SimStart:SimEnd) ; OutsideRelhumidity = OutsideRelhumidityF(SimStart:SimEnd) ;
SolarRadiation = SolarRadiationF(SimStart:SimEnd) ; WindSpeed = WindspeedF(SimStart:SimEnd) ; Winddirection = WinddirectionF(SimStart:SimEnd) ;
Sealevelpressure = SealevelpressureF(SimStart:SimEnd) ; CloudCover = CloudCoverF(SimStart:SimEnd) ; DewPoint = DewPointF(SimStart:SimEnd) ;
price_array_W6 = price_array_W6D(SimStart:SimEnd) ; price_array_W5 = price_array_W5D(SimStart:SimEnd) ; price_array_W4 = price_array_W4D(SimStart:SimEnd) ;
simdaycost = simdaycostD(SimStart:SimEnd) ; day_average = day_averageD(SimStart:SimEnd) ;

run("SetInputs")
run("SetParameters")
%run("SetInputs")
% Run "initialize.m to initialize or set  set_T to current T
run("SetStates")
run("Structuur")
