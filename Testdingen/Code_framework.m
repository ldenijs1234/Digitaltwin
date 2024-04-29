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
Number_variables = 3 ; % Number of state variables
State_setting = [true true false] ; % Decide which variables/outputs to include [Temperature Humidity CO2]


t = 1:dt:simulation_time*dt ;   % simulation time space
GH_state_space = zeros(Number_variables+1, length(t)) ;
GH_state_space(1, :) = t ;


% User input
Q_heat = 0 ; % Heating (W)
GH_state_space(2,1) = 25 ; % Air temperature inside greenhouse (C)
GH_state_space(3,1) = 0.80 ; % Relative humidity inside greenhouse (set to 80%)


% System characteristics
C  = cp * rho * GH_Volume ; % Specific heat greenhouse air (stirred tank)


% Dummy Dynamics // Random functions to test
function Q_conv = convection(statespace, T_out, h, i)
T_in = statespace(2, i) ;
Q_conv = h*(T_out - T_in) ;
end

function [Q_plant, humidity] = plant(statespace, i)
humid = statespace(3, i) ;
Q_plant = -50000 * humid ;
humidity = max(humid + Q_plant * 0.05, 0) ;
end

% System Dynamics // Euler integration of heat to air
for i = 1: length(t)-1
    Q_conv(i) = convection(GH_state_space, T_out, h, i) ;
    [Q_plant, GH_state_space(3, i+1)] = plant(GH_state_space, i) ;
    Q_total = Q_heat + Q_conv(i) + Q_plant ;
    GH_state_space(2, i+1) = GH_state_space(2, i) + Q_total/C ;
end

figure;
plot(t/dt, GH_state_space(2,:))
figure;
plot( (t(1 : end-1))/dt, Q_conv)