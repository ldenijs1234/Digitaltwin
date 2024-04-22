% Define greenhouse parameters
width = 10;  % meters
length = 20; % meters
height = 3;  % meters
area_wall = 2 * (width * height + length * height); % Total wall area
area_roof = width * length; % Roof area

% Define initial temperature distribution
initial_temperature = 20; % Celsius

% Define solar radiation input
solar_radiation = 0.03 % Define a function to calculate solar radiation based on time of day and weather conditions

% Define heat transfer coefficients for walls, roof, etc.
% These coefficients depend on the materials used and environmental conditions
U_wall = 0.7; % Wall heat transfer coefficient
U_roof = 0.6; % Roof heat transfer coefficient


% Initialize simulation parameters
time_span = 24; % hours
time_step = 0.5; % hour
num_steps = time_span / time_step; % Number of time steps
controller_interval = 1; % Controller update interval (in hours)

% Initialize temperature matrices
temperature = initial_temperature * ones(length, width); % Assuming uniform initial temperature
temperature_roof = initial_temperature; % Assuming uniform initial temperature for the roof

% Define a temperature_ground
temperature_ground = 15; % Celsius

% Define outside temperature
outside_temperature = 12; % Celsius

function [new_temperature, new_temperature_roof] = manual_temperature_controller(current_temperature, current_temperature_roof)
    disp('Current temperature values received for manual update:');
    fprintf('Average Air Temperature: %.2f °C\n', mean(current_temperature, 'all'));
    fprintf('Roof Temperature: %.2f °C\n', current_temperature_roof);

    % Prompt for new average air temperature
    new_temp_input = input('Enter new average air temperature (°C) or press Enter to keep current: ', 's');
    if isempty(new_temp_input)
        new_temperature = current_temperature;
    else
        new_temperature = str2double(new_temp_input) * ones(size(current_temperature));
    end

    % Prompt for new roof temperature
    new_roof_temp_input = input('Enter new roof temperature (°C) or press Enter to keep current: ', 's');
    if isempty(new_roof_temp_input)
        new_temperature_roof = current_temperature_roof;
    else
        new_temperature_roof = str2double(new_roof_temp_input);
    end
end

% Main simulation loop
for t = 0:time_step:time_span
    % Calculate energy balance for each cell in the greenhouse
    % Consider heat transfer through walls, roof, solar radiation, etc.
    % Update temperature matrix accordingly
    % Initialize temperature matrices for the next time step
    next_temperature = temperature;
    next_temperature_roof = temperature_roof;
    
    for i = 1:length
        for j = 1:width
            % Energy balance equation for walls
            if i == 1 % Top wall
                q_wall_top = U_wall * (temperature(i, j) - temperature_roof);
                next_temperature(i, j) = temperature(i, j) - (q_wall_top * time_step) / (area_wall * height);
            elseif i == length % Bottom wall
                q_wall_bottom = U_wall * (temperature(i, j) - temperature_ground);
                next_temperature(i, j) = temperature(i, j) - (q_wall_bottom * time_step) / (area_wall * height);
            else
                % Energy balance equation for sidewalls
                q_wall_side = U_wall * (temperature(i, j) - temperature(i+1, j));
                next_temperature(i, j) = temperature(i, j) - (q_wall_side * time_step) / (area_wall * width);
            end
            
            % Energy balance equation for roof
            q_roof = U_roof * (temperature_roof - temperature(i, j));
            next_temperature_roof = temperature_roof - (q_roof * time_step) / area_roof;
            
            
        end
    end

    % Update temperature matrices
    temperature = next_temperature;
    temperature_roof = next_temperature_roof;

    % Check if it's time to update the controller
    if mod(t, controller_interval) == 0
        fprintf('\nTime: %.1f hours\n', t);
        [temperature, temperature_roof] = manual_temperature_controller(temperature, temperature_roof);
    end
    

end

% Visualize results
% Plot temperature distributions over time
num_hours = 24;  % Total hours
average_temperature = zeros(1, num_hours);  % Preallocate for speed

for hour = 1:num_hours
    average_temperature(hour) = mean(mean(temperature(:,:,hour)));
end

figure;  % Create a new figure window
plot(0:time_step:time_span, average_temperature, '-o', 'LineWidth', 2);
title('Average Temperature Change Over 24 Hours');
xlabel('Time (hours)');
ylabel('Average Temperature (°C)');
grid on;  % Add a grid for easier reading