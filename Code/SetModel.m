% Create simulating parameters

dt = 5 ;                                  % Time interval in seconds
simulation_time =  48   *60*60 ;           % Simulation time in hours 
total_time = 24         *60*60 ;           % Total time available for simulation (dependent on forecasts)  
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;        % simulation time space
