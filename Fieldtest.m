%  Testing of nesting states, parameters and inputs in matlab fields
% Example GH.x.Temperature requests the state (x) Temperature out of the GH field

%GH.x = "states" // adding a state example GH.x.InsideTemperature = 20
%GH.u = "inputs" ;
%GH.p = "parameters" ;
%GH.d = "defined inputs" // Example adding Time array [t] => GH.d.time = t
%
%This allows easy extraction inside functions: output = function(GH)

% Random value examples:

GH.x.Temperature = 20 ;
GH.u.a = 10 ;

Heating = 2000 ;
GH.u.Heating = Heating ;

GH.u.a = GH.x.Temperature * 4 ;

dt = 60 ;                                  % Time interval of one minute
simulation_time = 5   *60 ;                % Simulation time in minutes    
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time*dt ;     % simulation time space

GH.d.Time = t ;