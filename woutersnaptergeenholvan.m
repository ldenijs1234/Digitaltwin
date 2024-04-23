%Tnew = Told + Q/(cp * m)

t = 0:1:60*24; % tijd in minuten
T_wanted = 25; %desired temperature in degrees
T_predict = 6 * sin(2 * pi * t/1440) + 14 ;%temperature prediction
%T_amb = zeros(1,length(t)) + 20 
T_amb = T_predict .* (0.99 + 0.01 * rand(1,length (t))); % "real" outside temperature
T_kas = zeros(1,length(t)); % zeros array for temperature in greenhouse
T_kas(1) = 15; %initial temperature in greenhouse

hour = 3600 ;%1 hour in seconds
minute = 60 ;%1 minute in seconds
h_buiten = 100;  %W
h_binnen = 100;  %W
k_wall = 5.7;
A = 30;  %m**2
cp = 718;  %J / kg K
rho = 1.29;  %kg m-3
V = 60;     %m**3
m = rho * V;
d_wall = 5 * 10-3;
R_wall = 1/h_buiten + d_wall/k_wall + 1/h_binnen;
h = 1/(R_wall) * A ;

Heatermax =    cp*m*0.06 ;%max heating of 0.06 deg 

for i = 1:(length(t)-1)
    Q_conv(i) = (T_amb(i) - T_kas(i)) * h * minute;
    tempdif(i) = T_wanted - T_kas(i) ; % T gap
    Q_needed(i) = tempdif(i)*cp*m ; %needed to overcome T gap

    %compare1(i) = max([0 (Q_needed(i)-Q_conv(i))]) ;
    Q_heater(i) =  min([Q_needed(i) Heatermax])  ;   %min([compare1(i) Heatermax]);
    Q(i) = Q_conv(i) + Q_heater(i);
    T_kas(i + 1) = T_kas(i) + Q(i) / (m * cp );
end
figure;
hold on
plot(t, T_kas, "g-")
plot(t, T_amb,'b--')
%plot(t, T_predict,'r-')
plot([0, length(t)], [T_wanted, T_wanted],'k--')
hold off
figure;
hold on
plot(t(1:end-1), Q_heater, "r")
plot(t(1:end-1), Q_conv, "b")
plot(t(1:end-1), Q_needed, "g")