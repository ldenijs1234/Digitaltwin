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

% Initialize setpoint
bound_average = (Lowerbound + Upperbound) / 2;
Initial_Setpoint = Lowerbound + 0.5;

% Initial setpoints
T_st(:, 1) = bound_average(1:3600/dt:end)';


% Initialize waitbar
hWaitBar2 = waitbar(0, 'Please wait...');

cost = inf * ones(size(T_st(:, 1)));
TC_Count = 0;
delta = 0.01;
alfa = 0.01;
% Number of iterations
iteration_amount = 10;

% Interpolate setpoints over time
Setpoint = interp1(0:24, T_st(:, 1), t / 3600, 'linear', 'extrap');

% Run the initial simulation with the initial setpoints
run("Initialize")
BoundBreak = true;
run("RunFullSim")



for n = 2:iteration_amount
    k = randperm(25);
    waitbar(n/iteration_amount, hWaitBar2, sprintf('Iteration %d/%d', n, iteration_amount))

    for m = 1:25
        
        Setpoint = interp1(0:24, T_st, t / 3600, 'linear', 'extrap');

        run("Initialize")
        BoundBreak = true;
        run("RunFullSim")

        costT_st =  sum(Energy_kWh .* simdaycost(1:end-1)) ;
        
        

        if Belowbound == false
            T_st_test = T_st;
            T_st_test(k(m)) = T_st(k(m)) + delta;

            

            Setpoint = interp1(0:24, T_st_test, t / 3600, 'linear', 'extrap');
            
            run("Initialize")
            BoundBreak = true;
            run("RunFullSim")

            if Belowbound == false

                costT_st_test =  sum(Energy_kWh .* simdaycost(1:end-1)) ;
                T_st(k(m)) = max(T_st_test(k(m)) - alfa * costT_st_test - costT_st / delta, Lowerbound((k(m)) * 3600/dt) + 0.5) ;

            end
            
        else
            T_st(k(m)) = T_st(k(m)) + 1;
        end

    end

    T_st_save(n) = T_st;
    Setpoint = interp1(0:24, T_st_save, t / 3600, 'linear', 'extrap');

    run("Initialize")
    BoundBreak = true;
    run("RunFullSim")

    cost(n) = sum(Energy_kWh .* simdaycost(1:end-1)) ;
    disp(cost(n))

end


close(hWaitBar2)
        
