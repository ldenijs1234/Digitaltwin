% Create simulating parameters

<<<<<<< HEAD
dt = 100 ;                                  % Time interval of 5 seconds
simulation_time =  24   *60*60 ;            % Simulation time in hours 
=======
dt = 10 ;                                  % Time interval of 5 seconds
simulation_time =  24   *60*60 ;           % Simulation time in hours 
total_time = 24         *60*60 ;           % Total time available for simulation (dependent on forecasts)  
>>>>>>> b44b39989559bfe089f5d4b4c85cbba2d5e3a99c
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;        % simulation time space
