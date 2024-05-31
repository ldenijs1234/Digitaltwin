function [test, delta] = opt(setpoints)
    delta = 0.1*(randi(11,length(setpoints),1)-6);
    test = setpoints + delta;
end 


bound_average = (coolingline+heatingline)/2;
T_st(1) = bound_average(1:3600/dt:end)';
lala = interp1([0:24],T_st, t/3600, 'linear', 'extrap');
%run simulation with T_st

cost(1) = costfunction;

for n = 2:11

    function [T_st_test, delta] = opt(T_st(:,n-1))

    %run simulation with T_st_test
    
    cost(n) = costfunction;

    alfa = 0.1;
    T_sp(:,n) =  T_sp(:,n) - alfa * (cost(n) - cost(n-1)) ./ delta;
end




