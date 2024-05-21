% A base for control by running the simulation for short amounts of time

% Initialize model
run("SetModel")

SimulationCount = true ;
SimCount = 1 ;

run("RunFullSim")



state_T = T(:,end) ;
state_add = AddStates(:, end) ;



% User Inputs

Heating = zeros(1, length(t)-1) ;
CO2_injection = 0 ;
OpenWindowAngle = 15 * ones(1, length(t)-1) ;