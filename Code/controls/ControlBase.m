% A base for control by running the simulation for short amounts of time

% Initialize model
run("SetModel")


% Extract final states 
set_T = T(:, end) ;
set_AddStates = AddStates(:, end) ;
set_FloorTemperature = FloorTemperature(:, end) ;

run("SetStates")
run("RunFullSim")    % Run a single simulation, including update of SimCount


