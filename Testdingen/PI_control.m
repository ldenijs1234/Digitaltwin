% Simulation parameters
total_time = 3600;   % Total simulation time in seconds
dt = 1;             % Time step in seconds

% Initialize arrays to store data for plotting
time = 0:dt:total_time;
temperature = zeros(size(time));
heating_input = zeros(size(time));

% Define parameters
setpoint_upper = 2 * sind(2*pi*(time)*1/120) + 22;  % Setpoint temperature in degrees Celsius
setpoint_lower = 2 * sind(2*pi*(time)*1/120) + 18;  % Setpoint temperature in degrees Celsius
kp = 0.15;       % Proportional gain
ki = 0.01;       % Integral gain

% Initialize variables
integral = 0;   % Integral term

% Price per kWh
price_per_kWh = 0.34 + 0.2 * sind(2*pi*(time-1800)*1/60);  % Euro

% Simulation loop
current_temp = 15 ;%* sin(time);  % Initial temperature
for i = 1:numel(time)
    
    % Adjust control output based on electricity cost
    cost_factor = price_per_kWh(i);
    if cost_factor < 0.34  % Cheaper electricity
        setpoint = max(setpoint_lower(i),setpoint_lower(i) * (1 + (0.34 - cost_factor)));  % Overshoot more
    else  % Expensive electricity
        setpoint = max(setpoint_lower(i),setpoint_lower(i) * (1 - (cost_factor - 0.34)));  % Be conservative
    end

    % Calculate error
    error = setpoint - current_temp;
    
    % Update integral term
    integral = integral + error * dt;
    
    % Calculate control output
    proportional = kp * error;
    integral_component = ki * integral;
    output = proportional + integral_component;
    
    
    % Convert controller output to heating input
    heating_input(i) = output;
    
    % Simulate temperature dynamics
    heat_loss = 0.1 * (current_temp - 10); % Simple linear heat loss model
    current_temp = current_temp + (heating_input(i) - heat_loss) * dt;
    
    % Store temperature for plotting
    temperature(i) = current_temp;
end

% Calculate energy consumption in kWh
energy_consumption_kWh = heating_input * dt / (1000 * 3600);  % Convert from W to kWh

% Calculate total cost in euros
total_cost_euro = energy_consumption_kWh .* price_per_kWh ;
sum(total_cost_euro); % 'ans' is the total cost in euros

% Plot results
figure("windowStyle","docked");
subplot(3, 1, 1);
plot(time/3600, temperature, 'b', 'LineWidth', 1.5);
hold on;
plot(time/3600, setpoint_lower, 'r--', 'LineWidth', 1.5);
plot(time/3600, setpoint_upper, 'r--', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Temperature (°C)');
title('Temperature Control with PI Controller');
legend('Temperature', 'Setpoint', 'Location', 'best');
grid on;

subplot(3, 1, 2);
plot(time/3600, price_per_kWh, 'g', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Price (€/kWh)');
title('Electricity Price Variation');
grid on;

subplot(3, 1, 3);
plot(time/3600, total_cost_euro, 'm', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Cost (€/kWh)');
title('Total Cost of Heating');
grid on;