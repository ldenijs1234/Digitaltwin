% % A base for control by running the simulation for short amounts of time

% % Initialize model
% run("SetModel")

% SimulationCount = false ;
SimCount = SimCount + 1 ;

% run("RunFullSim")    % Run a single simulation


% Extract final states 
set_T = T(:,end) ;
set_AddStates = AddStates(:, end) ;
set_FloorTemperature = FloorTemperature(:, end) ;



% User Inputs
Usercontrol = 0 ;

Heating = 0 ;
CO2_injection = 0 ;
OpenWindowAngle = 15 ;

% UserControlVector = [ Heating*ones(1, length(t)-1); CO2_injection; OpenWindowAngle * ones(1, length(t)-1)] ;