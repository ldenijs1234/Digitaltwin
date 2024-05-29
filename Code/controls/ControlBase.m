% % A base for control by running the simulation for short amounts of time

% % Initialize model
% run("SetModel")

% SimulationCount = false ;
% SimCount = SimCount + 1 ;



% integral = zeros(1, length(t)) ;


% Extract final states 
set_T = T(:, end) ;
set_AddStates = AddStates(:, end) ;
set_FloorTemperature = FloorTemperature(:, end) ;

run("SetStates")
run("RunFullSim")    % Run a single simulation

% User Inputs
% Usercontrol = 0 ;

% Heating = 0 ;
% CO2_injection = 0 ;
% OpenWindowAngle = 15 ;

% UserControlVector = [ Heating*ones(1, length(t)-1); CO2_injection; OpenWindowAngle * ones(1, length(t)-1)] ;
