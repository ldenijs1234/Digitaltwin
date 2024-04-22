
t = 0:1:24; % tijd in uren
T_wanted = 25; %disired temperaturen in degrees
T_predict = 6 * sin(2 * pi * t/ 24) + 14 ;%temperature prediction
T_amb = T_predict .* (0.95 + 0.1 * rand(1,length (t))); % real outside temperature
T_kas = zeros(1,length(t)); % zeros array for tempetauture in greenhouse
T_kas(1) = 15; %initial temperature in greenhouse
h_buiten = 100;
h_binnen = 100;
k_wall = 5.7;
A = 30;
cp = 718;
rho = 1.29;
V = 60;
m = rho * V;
d_wall = 5 * 10-3;
R_wall = 1/h_buiten + d_wall/k_wall + 1/h_binnen;
Q_heat = - A * (T_predict - T_wanted) / R_wall; %added heat based on predicted outside temperature nd disired

for i = 1:(length(t)-1)
    Q(i) = A * (T_amb(i) - T_kas(i)) / R_wall + Q_heat(i);
    T_kas(i + 1) = T_kas(i) + Q(i) * 60^2 / (m * cp );
end
hold on
plot(t, T_kas)
plot(t, T_amb,'--')
plot(t, T_predict,'-')
plot([0, 25], [T_wanted, T_wanted],'k--')

