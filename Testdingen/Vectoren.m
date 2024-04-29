% Function standard form // concept

NumberofParameters = 4 ;
VectorParameters = zeros(1, NumberofParameters) ;
VectorParameters(1) = 4 ;                  % parameter a
VectorParameters(2) = 3 ;                  % parameter b
VectorParameters(3) = 1 ;                  % parameter c
VectorParameters(4) = 6 ;                  % parameter d

dt = 60 ;                                  % Time interval of one minute
simulation_time = 5*60 ;                   % Simulation time in minutes    
t = 1:dt:simulation_time*dt ;              % simulation time space
GH_state_space = ones(4, length(t)) ;
GH_state_space(1, :) = t ;

function Q_test = Test(Parameters, states, index)
a = Parameters(1) ; b = Parameters(2) ; c = Parameters(3) ; d = Parameters(4) ;
T = states(2, index); H = states(3, index) ;
Q_test = a*b - d*T - c*H ;
end

% Euler integration

for i = 1:length(t-1)
    Q_test = Test(VectorParameters, GH_state_space, i) ;
    GH_state_space(2, i+1) = GH_state_space(2, i) + Q_test*dt ;
end

GH_state_space(1, end) = GH_state_space(1, end-1) ;
plot(GH_state_space(1, :)/dt, GH_state_space(2, :))