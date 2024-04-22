% Greenhouse parameters
width = 10;             % meters
length = 20;            % meters
height = 3;             % meters
pi = 3.14159265359;     % pi value
inside_temperature = 20;    % degrees Celsius

% Constants
density_air = 1.2;          % kg/m^3 (density of air)
specific_heat_air = 1005;   % J/(kg*K) (specific heat capacity of air)
thermal_conductivity = 0.024; % W/(m*K) (thermal conductivity of air)
volume = width * length * height; % m^3 (volume of greenhouse)
thickness = 0.05;            % m (thickness of walls)
area_walls = 2 * (width * height + length * height); % excluding floor and roof
area_roof = width * length; % m^2 (roof area)
R_wall = 1/specific_heat_air + thickness/thermal_conductivity + 1/specific_heat_air; % m^2*K/W (thermal resistance of walls)
% Time parameters
time_hours = 72;            % simulation time in hours
time_seconds = time_hours * 3600; % simulation time in seconds
time_steps = 1000;          % number of time steps

% Initialize temperature array
temperature = ones(1, time_steps) * inside_temperature;

% Heating source parameters
heating_power_per_second = 10; % constant heating power in watts per second

% Simulation loop
for t = 1:time_steps
    outside_temperature = (15 + 5*sin(2*pi*t/24));   % degrees Celsius
    % Calculate temperature difference
    delta_temp = temperature(t) - outside_temperature;
    
    % Calculate energy balance
    % Heat loss due to conduction through the walls
    heat_loss_conduction_w = area_walls * delta_temp / R_wall;
    heat_loss_conduction_r = area_roof * delta_temp / R_wall;
    % Heat loss due to ventilation (assuming natural convection)
    % Calculating air changes per hour (ACH) for natural convection
        
    % Total heat loss
    total_heat_loss = heat_loss_conduction_r + heat_loss_conduction_w;
    
    % Calculate total heat input for the time step
    heating_input = heating_power_per_second * (time_hours / time_steps); % watts

    % Update temperature using energy balance
    net_heat_transfer = heating_input - total_heat_loss;
    temperature_change = net_heat_transfer / (density_air * specific_heat_air * volume);
    temperature(t+1) = temperature(t) + temperature_change;
end

% Plot temperature change over time
time = linspace(0, time_hours, time_steps+1);
outside_temperature = 15 + 5*sin(2*pi*time/24);
figure;
plot(time, outside_temperature, 'r--', 'LineWidth', 1.5);
hold on;
plot(time, temperature, 'b', 'LineWidth', 2);
xlabel('Time (hours)');
ylabel('Temperature (°C)');
title('Greenhouse Temperature Change Over 24 Hours');
grid on;
