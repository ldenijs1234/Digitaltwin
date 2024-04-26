%   Testing of nesting states, parameters and inputs in matlab fields
%   Example GH.x.Temperature requests the state (x) Temperature out of the GH field
%
%   GH.x = "states" // adding a state example GH.x.InsideTemperature = 20
%   GH.u = "inputs" ;
%   GH.p = "parameters" ;
%   GH.d = "defined inputs" // Example adding Time array [t] => GH.d.time = t
%
%   This allows easy extraction inside functions: output = function(GH)

%   Random value examples:
GH.p.           cp_air = 718 ;
GH.p.           rho_air = 1.29 ;
GH.p.           GreenhouseArea = 30 ;
GH.p.           GreenhouseHeight = 2 ;

GH.p.GreenhouseVolume = GH.p.GreenhouseArea*GH.p.GreenhouseHeight ;   % Simplified to a box

GH.p.           h_AirGlass = 100;
GH.p.           k_wall = 5.7;
GH.p.           d_wall = 5 * 10-3;

GH.p.h_InOut = 1/(1/GH.p.h_AirGlass + GH.p.d_wall/GH.p.k_wall + 1/GH.p.h_AirGlass) * GH.p.GreenhouseArea ; %overall heat transfer coefficient

Heating = 2000 ;
GH.u.Heating = Heating ;


%   An array as field
dt = 60 ;                                  % Time interval of one minute
simulation_time = 5   *60 ;                % Simulation time in minutes   (set to 5 hours) 
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time*dt ;     % simulation time space
OutsideTemperature = 15 + 5*sin(2*pi * t/(24*60*dt)) ;

GH.d.Time = t ;                            % Time as a field of GH.d
GH.d.OutsideTemperature = OutsideTemperature ;% Outside temperature as a field of GH.d

GH.x.            AirTemperature(1) = 25 ;  % Starting condition


%   Set an ODE
function AirTemperatureDot = ODE_AirTemperature(GH, i)
    C_system = GH.p.GreenhouseVolume*GH.p.rho_air*GH.p.cp_air ;
    AirTemperatureDot = GH.p.h_InOut/C_system * (GH.d.OutsideTemperature(i) - GH.x.AirTemperature(i)) ;
end

%   Integration

for i = 1: (length(GH.d.Time)-1)
    GH.x.AirTemperature(i+1) = GH.x.AirTemperature(i) + ODE_AirTemperature(GH, i)*dt ;
end

plot(GH.d.Time/dt, GH.x.AirTemperature)