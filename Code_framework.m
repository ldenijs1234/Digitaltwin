%code framework

%Greenhouse dimensions
GH_Length = 30 ;
GH_Width = 30 ;
GH_Height = 5 ; 

GH_Area1 = GH_Height*GH_Length ;
GH_Area2 = GH_Height*GH_Width ;
GH_Area3 = GH_Width*GH_Length ;
GH_Area = GH_Area1 + GH_Area2 + GH_Area3 ; % Total GH area
GH_Volume = GH_Length*GH_Width*GH_Height ;

%Weather input
wind_velocity = 5 ; % wind speed (m/s), open for variability
T_out = 15 ; % Outside temperature (C)

%Heat transfer parameters
h = 10000 ; % Convection coefficient (W/K)
cp = 718 ; % Specific heat air (J/[kg K]) 
rho = 1.29 ; % Air density (Kg/m^3)

% Simulation parameters
dt = 60 ; % Time interval of one minute
simulation_time = 5*60 ;% Simulation time in minutes
t = 1:dt:simulation_time*dt ;   % 1 hour of simulation time

% User input
Q_heat = 0 ; % Heating (W)
GH_T_air(1) = 25 ; % Air temperature inside greenhouse (C)
GH_humidity(1) = 0.80 ; % Relative humidity inside greenhouse (set to 80%)


% System characteristics
C  = cp * rho * GH_Volume ; % Specific heat greenhouse air (stirred tank)


% Dummy Dynamics // Random functions to test
function Q_conv = convection(T_in, T_out, h)
Q_conv = h*(T_out - T_in) ;
end

function [Q_plant, humidity] = plant(T_in, humid)
Q_plant = -50000 * humid ;
humidity = max(humid + Q_plant * 0.05, 0) ;
end

% System Dynamics // Euler integration of heat to air
for i = 1: length(t)-1
    Q_conv(i) = convection(GH_T_air(i), T_out, h) ;
    [Q_plant, GH_humidity(i+1)] = plant(GH_T_air(i), GH_humidity(i)) ;
    Q_total = Q_heat + Q_conv(i) + Q_plant ;
    GH_T_air(i+1) = GH_T_air(i) + Q_total/C ;
end

figure;
plot(t/dt, GH_T_air)
figure;
plot( (t(1 : end-1))/dt, Q_conv)