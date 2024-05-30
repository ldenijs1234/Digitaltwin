run("SetModel")
time_steps = simulation_time/dt+1 ;

filename = 'Delft30-5.csv'; % File name of the weather data CSV file 
[time_vec, OutsideTemperatureF, OutsideRelhumidityF, SolarRadiationF, WindspeedF, WinddirectionF, SealevelpressureF, CloudCoverF, DewPointF] = Weather2Arrays(filename, dt, total_time) ;



SimCount = SimCount + 1 ;                   % keep count on number of simulations done
SimStart = time_steps*(SimCount-1) + 1 ;    % Define interval start based on SimCount
SimEnd = time_steps*SimCount ;              % Define interval end based on SimCount

OutsideTemperature = OutsideTemperatureF(SimStart:SimEnd) ; OutsideRelhumidity = OutsideRelhumidityF(SimStart:SimEnd) ;
SolarRadiation = SolarRadiationF(SimStart:SimEnd) ; WindSpeed = WindspeedF(SimStart:SimEnd) ; Winddirection = WinddirectionF(SimStart:SimEnd) ;
Sealevelpressure = SealevelpressureF(SimStart:SimEnd) ; CloudCover = CloudCoverF(SimStart:SimEnd) ; DewPoint = DewPointF(SimStart:SimEnd) ;

run("SetParameters")
run("SetInputs")
% Run "initialize.m to initialize or set  set_T to current T
run("SetStates")
run("Structuur")
