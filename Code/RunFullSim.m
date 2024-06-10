% RunFullSim runs a full simulation
% Run "initialize.m to initialize or set  set_T to current T
% When running multiple simulations after one another (i.e. 1 hour simulations), make sure to include SimCount 
% for correct calibration of the weather forecasts. 

run("SetModel")

% Extract final states                                Turned off by default, turn on to run multiple simulations after one another
%                                                     and continue with the state values from last simulation.                                                   
% set_T = T(:, end) ;
% set_AddStates = AddStates(:, end) ;
% set_FloorTemperature = FloorTemperature(:, end) ;
SimCount = 0 ;                              % Turn off when running multiple simulations after one another

time_steps = simulation_time/dt+1 ;
SimCount = SimCount + 1 ;                   % Keep count on number of simulations done
SimStart = time_steps*(SimCount-1) + 1 ;    % Define interval start based on SimCount
SimEnd = time_steps*SimCount ;              % Define interval end based on SimCount

run("SetInputs")

%Setpoint = Lowerbound + 0.5 ;
%Setpoint = interp1(0:24, T_st, t / 3600, 'linear', 'extrap') ;        % Can be set to different setpoints, or can be turned off and defined by an optimization


run("SetParameters")
run("SetStates")
run("Structuur")
