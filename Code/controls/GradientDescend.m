run("SetModel")

SimStart =  1 ;    % Define interval start based on SimCount
SimEnd = length(t) ;
% Compute lower and upper bounds
Lowerbound_total = bound(10, 15, 6, 10, 18, 22, dt, total_time / 24); % Setpoint temperature (°C)
Upperbound_total = bound(20, 25, 6, 10, 18, 22, dt, total_time / 24); % Setpoint temperature (°C)

% Extract bounds for the simulation period
Lowerbound = Lowerbound_total(SimStart:SimEnd);
Upperbound = Upperbound_total(SimStart:SimEnd);
bound_average = (Lowerbound + Upperbound) / 2;



% Initialize waitbar
hWaitBar2 = waitbar(0, 'Please wait...');
TC_Count = 0;
alfa = 0.3;

% Number of iterations
iteration_amount = 30;
n = 1;
perturb_amount = 2;

% Interpolate setpoints over time
function [cost, Belowbound] = cost_set(T_st, n)
    run("SetModel")
    Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

    % Run simulation with setpoints
    run("Initialize")
    BoundBreak = true;
    run("RunFullSim")

    if Belowbound == false
        cost =  sum(Energy_kWh .* simdaycost(1:end-1)) ;
    else
        cost = 10000;   % Arbitrary penalty cost for breaking the bound
    end
end

costguess = zeros(1, width(Guesses));
for i = 1:width(Guesses)                   % Determine cost per initial guess
    Guess = Guesses(:, i);
    costguess(i) = cost_set(Guess, n);
end

[costmin, Guess_index] = min(costguess) ;           % Determine initial guess with lowest cost
T_st = Guesses(:, Guess_index);
disp('Continuing with guess:')
disp(Guess_index)

% while Belowbound == true
%     disp('increase setpoint by 1')
%     T_st = T_st + 1;
%     Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

%     run("Initialize")
%     BoundBreak = true;
%     run("RunFullSim")

%     if Belowbound == false

%         costT_st =  sum(Energy_kWh .* simdaycost(1:end-1)) ;
%         cost_save(1) = costT_st;
%     end
% end

costT_st = cost_set(T_st, n) ;

T_st_save(:,1) = T_st;
cost_save(1) = costT_st;

for n = 2:iteration_amount
    waitbar(n/iteration_amount, hWaitBar2, sprintf('Iteration %d/%d', n, iteration_amount))
    % delta =  0.01 *randi(5,25,1) - 0.03;
    delta = zeros(size(T_st));
    delta(randi(length(delta), perturb_amount, 1)) = 0.01 *randi(3,perturb_amount,1) - 0.02;
    
    T_st_delta = T_st + delta ;
    [costT_st_delta, Belowbound] = cost_set(T_st_delta, n) ;

    gradient = (costT_st_delta - costT_st) ./ delta ;
    gradient(gradient == inf) = 0;
    gradient(isnan(gradient)) = 0;
    T_st_new = T_st - alfa .* gradient ;

    [cost_new, Belowbound] = cost_set(T_st_new, n);

    if Belowbound == false %&& costnew < cost?
        T_st = T_st_new;
        costT_st = cost_new;
    end


    T_st_save(:,n) = T_st;
    cost_save(n) = costT_st;

    % figure("WindowStyle", "docked");
    % hold on
    % plot(t/3600, T(:,:))
    % plot(t/3600, OutsideTemperature, 'b--')
    % plot(t/3600, Setpoint, 'Linewidth', 3) 
    % plot(t/3600, heatingline, 'r--') 
    % plot(t/3600, coolingline, 'c--')
    % title("Temperatures in the greenhouse")
    % xlabel("Time (h)")
    % ylabel("Temperature (°C)")
    % legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Heating Line', 'Cooling Line')
    % hold off    

end

close(hWaitBar2)

run("SetModel")
Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

% Run the simulation
run("Initialize")
BoundBreak = true;
run("RunFullSim")


Setpoint_end = interp1(0:24, T_st, t / 3600, 'linear', 'extrap');
figure("WindowStyle", "docked");
hold on
plot(t/3600, Setpoint_end, 'm--') 
plot(t/3600, Lowerbound, 'k--') 
plot(t/3600, Upperbound, 'k--')
plot(t/3600, bound_average, 'k--')
plot(h24, T_st_save(:,1), 'r-')
plot(t/3600, T(1,:), 'b-')
plot(t/3600, OutsideTemperature, 'b--')
title("Bounds")
xlabel("Time (h)")
ylabel("Temperature (°C)")
legend('Setpoint', 'Lower Bound', 'Upper Bound', 'Average Bound', 'First Iteration', 'Air Temperature', 'Outside Temperature')
hold off    

disp(['saved:', cost_save(end)/cost_save(1)])

        
