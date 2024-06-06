run("SetModel")

SimStart =  1 ;    % Define interval start based on SimCount
SimEnd = length(t) ;
% Compute lower and upper bounds
Lowerbound_total = bound(10, 15, 6, 10, 18, 22, dt, total_time / 24); % Setpoint temperature (°C)
Upperbound_total = bound(20, 25, 6, 10, 18, 22, dt, total_time / 24); % Setpoint temperature (°C)

% Extract bounds for the simulation period
% Lowerbound = Lowerbound_total(SimStart:SimEnd);
% Upperbound = Upperbound_total(SimStart:SimEnd);

Lowerbound = 10 * ones(size(t));
Upperbound = 20 * ones(size(t));


% Initialize setpoint
bound_average = (Lowerbound + Upperbound) / 2;


% Initial setpoints
T_st = Lowerbound(1:3600/dt:end)' + 1;


% Initialize waitbar
hWaitBar2 = waitbar(0, 'Please wait...');
cost = inf * ones(size(T_st));
TC_Count = 0;
alfa = 0.1;
% Number of iterations
iteration_amount = 10;
n = 1;

% Interpolate setpoints over time
function cost = cost_set(T_st)
    Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

    % Run the initial simulation with the initial setpoints
    run("Initialize")
    BoundBreak = true;
    run("RunFullSim")
    cost =  sum(Energy_kWh .* simdaycost(1:end-1)) ;
end



while Belowbound == true
    disp('increase setpoint by 1')
    T_st = T_st + 1;
    Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

    run("Initialize")
    BoundBreak = true;
    run("RunFullSim")

    if Belowbound == false

        costT_st =  sum(Energy_kWh .* simdaycost(1:end-1)) ;
        cost_save(1) = costT_st;
    end
end

cost_nul = cost(T_st) ;

for n = 2:iteration_amount
    waitbar(n/iteration_amount, hWaitBar2, sprintf('Iteration %d/%d', n, iteration_amount))
    delta = randi([0.01, 0.05], size(T_st));
    T_st_delta = T_st + delta ;

    costT_st = cost(T_st) ;
    costT_st_delta = cost(T_st_delta) ;

    gradient = (costT_st_delta - costT_st) ./ delta ;

    T_st_new = T_st - alpha * gradient ;

    cost_new = cost(T_st_new);

    if Belowbound == false %&& costnew < cost?
        T_st = T_st_new;
        costT_st = cost_new;
    end


    T_st_save(:,n) = T_st;
    cost_save(n) = costT_st;

    figure("WindowStyle", "docked");
    hold on
    plot(t/3600, T(:,:))
    plot(t/3600, OutsideTemperature, 'b--')
    plot(t/3600, Setpoint, 'Linewidth', 3) 
    plot(t/3600, heatingline, 'r--') 
    plot(t/3600, coolingline, 'c--')
    title("Temperatures in the greenhouse")
    xlabel("Time (h)")
    ylabel("Temperature (°C)")
    legend('Air', 'Cover', 'Walls', 'Floor', 'Plant', 'Heatpipe','Outside', 'Heating Line', 'Cooling Line')
    hold off    

end


close(hWaitBar2)
        
