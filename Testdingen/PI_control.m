% Simulation parameters
total_time = 100;   % Total simulation time in seconds
dt = 1;             % Time step in seconds

% Initialize arrays to store data for plotting
time = 0:dt:total_time;
temperature = zeros(size(time));
heating_input = zeros(size(time));

% Define parameters
setpoint = 22 + 2 * sin(2*pi*time*100);  % Setpoint temperature in degrees Celsius
kp = 0.5;       % Proportional gain
ki = 0.1;       % Integral gain

% Initialize variables
integral = 0;   % Integral term

% Simulation loop
current_temp = 20 %* sin(time);  % Initial temperature
for i = 1:numel(time)
    % Calculate error
    error = setpoint(i) - current_temp;
    
    % Update integral term
    integral = integral + error * dt;
    
    % Calculate control output
    proportional = kp * error;
    integral_component = ki * integral;
    output = proportional + integral_component;
    
    
    % Convert controller output to heating input
    heating_input(i) = output;
    
    % Simulate temperature dynamics
    heat_loss = 0.1 * (current_temp - 20); % Simple linear heat loss model
    current_temp = current_temp + (heating_input(i) - heat_loss) * dt;
    
    % Store temperature for plotting
    temperature(i) = current_temp;
end

% Plot results
figure;
subplot(2, 1, 1);
plot(time, temperature, 'b', 'LineWidth', 1.5);
hold on;
plot(time, setpoint(i), 'r--', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature Control with PI Controller');
legend('Temperature', 'Setpoint', 'Location', 'best');
grid on;

subplot(2, 1, 2);
plot(time, heating_input, 'g', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Heating Input (W)');
title('Heating Input Control Signal');
grid on;
