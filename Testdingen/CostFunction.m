% Cost function to evaluate perfomance of input profiles 'u' over simulation horizon 't'



function J = CostFunction(u, x_T, x_add, x_T_d, x_add_d, t, dt)
    
    % x_T: Temperature states from model or measurement, currently n=6
    % x_add: Additional states from model or measurement, e.g. humidity, currently n=4
    % x_T_d: Desired temperature states, can be a set point line for example
    % x_add_d: Desired additional states, can be a set point line for example
    % u: Input vector, currently consists of heating, window opening and fogging
    % All in the form of a matrix of vectors through time 't'
    
    
    
    e_T = x_T - x_T_d ;              % Deviation error of Temperature states with regards to desired Temperature states
    e_add = x_add - x_add_d ;        % Deviation error of additional states states with regards to desired additional states
    
    Q_T = [10, 0, 0, 0, 0, 0;    % Weight matrix for temperature errors
           0, 0, 0, 0, 0, 0;       
           0, 0, 0, 0, 0, 0;     % Arbitrary weights: Air valued most important, than plant and heating pipe. 
           0, 0, 0, 0, 0, 0;     % Remaining temperature errors not relevant
           0, 0, 0, 0, 5, 0;
           0, 0, 0, 0, 0, 1];
    

    Q_add = [5, 0, 0, 0,;      % Weight matrix for additional state errors
             0, 1, 0, 0,;
             0, 0, 0, 0,;
             0, 0, 0, 0,];  

 
    R = [5, 0, 0;             % Weight matrix for inputs, can be based on energy cost price
         0, 1, 0;
         0, 0, 3];

    J_forloop = zeros(1, length(t)-1) ;
    for i = 1:length(t)-1
        J_forloop(i) = e_T(:,i).' * Q_T * e_T(:,i) + e_add(:,i).' * Q_add * e_add(:, i) + u(:,i).' * R * u(:,i) ;
    end

    J = e_T(:,end).' * Q_T * e_T(:,end) + e_add(:,end).' * Q_add * e_add(:, end) + sum(J_forloop);
end