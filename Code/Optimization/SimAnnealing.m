drun("SetModel")
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
%T_st(:, 1) = Lowerbound(1:3600/dt:end)';
%T_st(:,1) = best_T_st;
ttt = T_st(:, 1);
bias = zeros(size(T_st(:, 1)));
cost = inf * ones(size(T_st(:, 1)));
TC_Count = 0;
n = 1;

% Number of iterations
iteration_amount = 100;

%[minimum_cost, best_iteration] = min(cost);
%best_T_st = T_st(:,best_iteration);
%T_st(:,1) = best_T_st;

% Interpolate setpoints over time
Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

% Run the initial simulation with the initial setpoints
run("Initialize")
BoundBreak = true;
run("RunFullSim")

% Compute initial cost
if Belowbound == false
    cost(1) = sum(Energy_kWh .* simdaycost(1:end-1)); % Adjust if necessary
else
    cost(1) = inf;
    bias(max(1,hour_belowbound-2):hour_belowbound) = (1 - (n / (iteration_amount + 0.01))) / 2;
end


% Initialize the waitbar
hWaitBar2 = waitbar(0, 'Please wait...');


% Probability function parameters:
labda = 1.7;
prob_rate = 3 / iteration_amount;

% Main optimization loop
for n = 2:iteration_amount
    %distribution function:
    Accept_rate = labda * exp(-labda * (n * prob_rate));
    Accept_rate

    % Update the waitbar
    waitbar(n / iteration_amount, hWaitBar2, sprintf('Iteration %d/%d', n, iteration_amount));

    % Perturb the setpoints using the larslars function
    [T_st_test, delta] = Perturb(T_st(:, n-1), n, iteration_amount);

    f = find(T_st_test < Lowerbound(1:3600/dt:end)');
    T_st_test(f) = Lowerbound(f) + 1.2;

    T_st_test = T_st_test + bias; 

    

    % Interpolate new setpoints over time
    Setpoint = interp1(0:24, T_st_test, t / 3600, 'linear', 'extrap');

    % Run the simulation with the new setpoints
    run("Initialize")
    BoundBreak = true;
    run("RunFullSim")

    bias = zeros(size(T_st(:, 1)));

    % Compute the cost for the new setpoints
    if Belowbound == false
        cost(n) = sum(Energy_kWh .* simdaycost(1:end-1)); % Adjust if necessary
        TC_Count = 0;
        Accept_rate = exp((- cost(n) - cost(n-1))/ t);
    else 
        cost(n) = inf;
        bias(max(1,hour_belowbound(n)-1):hour_belowbound(n)) = (1 - (n / (iteration_amount + 0.01))) / 2;
        TC_Count = TC_Count + 1;
    end

    if cost(n) < cost(n-1)
        T_st(:,n) = T_st_test;
        display('Accepted')
    
    elseif rand(1) < Accept_rate
        T_st(:,n) = T_st_test;
        display('Accepted')
        ttt = [ttt, T_st(:,n-1)];
    else
        T_st(:,n) = T_st(:,n-1);
        display('Rejected')
    end

    if TC_Count == 5
        [minimum_cost, best_iteration] = min(cost);
        T_st(:,n) = T_st(:,best_iteration);
    end
    

end

setpoint = interp1(0:24, T_st(:,end), t / 3600, 'linear', 'extrap');
run("Initialize")
run("RunFullSim")

% Close the waitbar
close(hWaitBar2);

% Function to perturb the setpoints
function [test, delta] = Perturb(setpoints, n, iteration_amount)
    delta = (1 - (n / (iteration_amount + 0.01))) * 0.3 * (randi(11, length(setpoints), 1) - 6); % Rand makes int between 0, 11 and centers it around 0 to make between -5, 5
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