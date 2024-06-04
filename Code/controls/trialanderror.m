run("SetModel")
SimCount = 0;
time_steps = simulation_time/dt+1 ;
SimCount = SimCount + 1 ;                   % keep count on number of simulations done
SimStart = time_steps*(SimCount-1) + 1 ;    % Define interval start based on SimCount
SimEnd = time_steps*SimCount ;
% Compute lower and upper bounds
Lowerbound_total = bound(10, 15, 6, 10, 18, 22, dt, total_time / 24); % Setpoint temperature (°C)
Upperbound_total = bound(20, 25, 6, 10, 18, 22, dt, total_time / 24); % Setpoint temperature (°C)

% Extract bounds for the simulation period
Lowerbound = Lowerbound_total(SimStart:SimEnd);
Upperbound = Upperbound_total(SimStart:SimEnd);

% Average of the bounds
bound_average = (Lowerbound + Upperbound) / 2;

% Initial setpoints
T_st(:, 1) = bound_average(1:3600/dt:end)';
% [minimum_cost, best_iteration] = min(cost);
% best_T_st = T_st(:,best_iteration);
% T_st(:,1) = best_T_st;

% Interpolate setpoints over time
Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

% Run the initial simulation with the initial setpoints
run("Initialize")
run("RunFullSim")

% Compute initial cost
if Belowbound == false
    cost(1) = sum(Energy_kWh .* simdaycost(1:end-1)); % Adjust if necessary
else
    cost(1) = inf;
end


% Initialize the waitbar
hWaitBar2 = waitbar(0, 'Please wait...');

% Number of iterations
iteration_amount = 5;

% Main optimization loop
for n = 2:iteration_amount

    % Update the waitbar
    waitbar(n / iteration_amount, hWaitBar2, sprintf('Iteration %d/%d', n, iteration_amount));

    % Perturb the setpoints
    [T_st_test, delta] = perturb(T_st(:, n-1));

    if Belowbound == true
        bias = zeros(25,1);
        bias(max(1,hour_Below-1), hour_Below) = 2; %add a postive bias before temperature become too
        [T_st_test, delta] = perturb(T_st(:, max(1,n-2)));
        T_st_test = T_st_test + bias;
    end

    % Interpolate new setpoints over time
    setpoint = interp1(0:24, T_st_test, t / 3600, 'linear', 'extrap');

    % Run the simulation with the new setpoints
    run("Initialize")
    run("RunFullSim")

    % Compute the cost for the new setpoints
    if Belowbound == false
        cost(n) = sum(Energy_kWh .* simdaycost(1:end-1)); % Adjust if necessary
        %T_st(:, n) = T_st(:, n-1) - alfa * (cost(n) - cost(n-1)) ./ delta;
        T_st(:, n) = T_st(:,n-1) - sign(cost(n) - cost(n-1)) * delta ;
    else
        cost(n) = inf;
        T_st(:,n) = T_st(:,max(1,n-2));
    end

    
    
end

setpoint = interp1(0:24, T_st(:,end), t / 3600, 'linear', 'extrap');
run("Initialize")
run("RunFullSim")

% Close the waitbar
close(hWaitBar2);

% Function to perturb the setpoints
function [test, delta] = perturb(setpoints)
    delta = 0.1 * (randi(11, length(setpoints), 1) - 6);
    test = setpoints + delta;
end


[minimum_cost, best_iteration] = min(cost);
best_T_st = T_st(:,best_iteration);
figure("WindowStyle", "docked");
hold on
plot(0:24, best_T_st)
plot(t/3600, 100 * simdaycost)
hold off

figure("WindowStyle", "docked");
hold on
plot(t/3600, T(:,:))
plot(t/3600, OutsideTemperature, 'b--')
plot(t/3600, Lowerbound, 'r--') 
plot(t/3600, Upperbound, 'c--')
title("Temperatures in the greenhouse")
xlabel("Time (h)")
ylabel("Temperature (°C)")
legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Heating Line', 'Cooling Line')
hold off