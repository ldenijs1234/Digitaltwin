% Bro gun parameters


dt = 60 ;                                  % Time interval of one minute
GH.d.dt = dt ;
simulation_time = 5   *60 ;                % Simulation time in minutes   (set to 5 hours) 
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time*dt ;     % simulation time space
OutsideTemperature = 15 + 5*sin(2*pi * t/(24*60*dt)) ;

GH.d.Time = t ;                                 % Time as a field of GH.d
GH.d.OutsideTemperature = OutsideTemperature ;  % Outside temperature as a field of GH.d


GH.p.           cp_air = 718 ;
GH.p.           rho_air = 1.29 ;

GH.p.           parameter1 = 1 ;

%faka