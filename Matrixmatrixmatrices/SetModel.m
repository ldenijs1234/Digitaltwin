% Create simulating parameters

dt = 10 ;                                  % Time interval of 5 seconds
simulation_time = 4   *60*60 ;            % Simulation time in hours 
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;     % simulation time space

OutsideTemperature = 17;

T(:,1) = [10; 15; 12; 20];