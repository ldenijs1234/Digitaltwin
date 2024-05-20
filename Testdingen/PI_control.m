% Simulation parameters
total_time = 3600;   % Total simulation time in seconds
dt = 1;             % Time step in seconds

% Initialize arrays to store data for plotting
time = 0:dt:total_time;
temperature = zeros(size(time));
heating_input = zeros(size(time));

% Define parameters
setpoint = 2 * sind(2*pi*(time)*1/120) + 22;  % Setpoint temperature in degrees Celsius
kp = 0.5;       % Proportional gain
ki = 0.1;       % Integral gain

% Initialize variables
integral = 0;   % Integral term

% Simulation loop
current_temp = 15 ;%* sin(time);  % Initial temperature
for i = 1:numel(time)
    % Calculate error
    error = setpoint(i) - current_temp;
    
    % Update integral term
    integral = integral + error * dt;
    
    % Calculate control output
    proportional = max(0,kp * error);
    integral_component = max(0,ki * integral);
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

% Price per kWh
price_per_kWh = 3.4 + 2 * sind(2*pi*(time-1800)*1/60);  % Euro

% Calculate total cost in euros
total_cost_euro = energy_consumption_kWh .* price_per_kWh ;
sum(total_cost_euro) % 'ans' is the total cost in euros

% Plot results
figure("windowStyle","docked");
subplot(3, 1, 1);
plot(time/3600, temperature, 'b', 'LineWidth', 1.5);
hold on;
plot(time/3600, setpoint, 'r--', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Temperature (°C)');
title('Temperature Control with PI Controller');
legend('Temperature', 'Setpoint', 'Location', 'best');
grid on;

subplot(3, 1, 2);
plot(time/3600, energy_consumption_kWh, 'g', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Heating Input (kWh)');
title('Heating Input Control Signal');
grid on;

subplot(3, 1, 3);
plot(time/3600, total_cost_euro, 'm', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('Cost (€/kWh)');
title('Total Cost of Heating');
grid on;
