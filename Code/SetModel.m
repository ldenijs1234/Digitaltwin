% Create simulating parameters

dt = 5 ;                                   % Time interval in seconds
simulation_time =  1   *60*60 ;           % Simulation time in hours 
total_time = 48         ;                  % (hours) Total time available for simulation, dependent on forecasts
start_time = 0 ;                           % Start of simulation

t = start_time:dt:simulation_time ;        % simulation time space

% figure()
% hold on
% th = 0:pi/50:2*pi;
% xunit = 1 * cos(th) + -1;
% yunit = 1 * sin(th) + 0;
% h = plot(xunit, yunit);

% xunit = 1 * cos(th) + 1;
% yunit = 1 * sin(th) + 0;
% h = plot(xunit, yunit);
% xunit = [-1:pi/50:1];

% yunit = -8 * xunit.^2 + 8;
% h = plot(xunit, yunit);
% title('Gijs pipi laten zien')
% hold off