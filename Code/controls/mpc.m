% run("SetModel")

% Lowerbound_total = bound(10, 15, 6, 10, 18, 22, dt, total_time/24); % Setpoint temperature (°C)
% Lowerbound = setpoint_total(SimStart:SimEnd) ;

% Upperbound_total = bound(10, 15, 6, 10, 18, 22, dt, total_time/24); % Setpoint temperature (°C)
% Upperbound = setpoint_total(SimStart:SimEnd) ;

% function [test, delta] = larslars(setpoints)
%     delta = 0.1*(randi(11,length(setpoints),1)-6);
%     test = setpoints + delta;
% end 


% bound_average = (Lowerbound + Upperbound)/2;
% T_st(1) = bound_average(1:3600/dt:end)';
% setpoint = interp1([0:24],T_st, t/3600, 'linear', 'extrap');

% %run simulation with T_st

% cost(1) = sum(Energy_kWh.*simdaycost(1:end-1)); %deze moet nog

% hWaitBar2 = waitbar(0, 'Please wait...') ;

% iteration_amount = 10;
% for n = 2:iteration_amount

%     waitbar(n / iteration_amount), hWaitBar2, sprintf(append(sprintf('Iteration %d/%', round(n)),  int2str(iteration_amount)));

%     function [T_st_test, delta] = larslars(T_st(:,n-1))

%     setpoint = interp1([0:24], T_st_test, t/3600, 'linear', 'extrap');

%     run("Initialize")
%     run("RunFullSim")
    
%     cost(n) = sum(Energy_kWh.*simdaycost(1:end-1)); %deze moet nog

%     alfa = 0.1;
%     T_sp(:,n) =  T_sp(:,n) - alfa * (cost(n) - cost(n-1)) ./ delta;
% end

% close(hWaitBar2);