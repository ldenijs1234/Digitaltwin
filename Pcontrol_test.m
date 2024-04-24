
%define basic model variables
t_interval = 15 ;
t = 0:t_interval:60*24; % time in kwartieren
minute = 60 ; %seconds
l = length(t) ;

%define parameters of greenhouse design
h_buiten = 100;
h_binnen = 100;
k_wall = 5.7;
A = 30;
cp = 718;
rho = 1.29;
V = 60;
m = rho * V;
Csp = cp*m ;
d_wall = 5 * 10-3;
R_wall = 1/h_buiten + d_wall/k_wall + 1/h_binnen;
h = 1/(R_wall) * A * t_interval*60 ; %overall heat transfer coefficient
Qmax = 50000 ;  %Maximal heating capacity

%define environment
%T_amb = zeros(l) + 10 ; %degrees Celcius, outside temperature
T_amb = (15 + 3*sin(2*pi * t/(24*60))).* (0.95 + 0.1 .* rand(1,length(t))) ;

%define reference and control parameters
Tref = 25  ; %degrees Celsius
k = 2 ; %gain
kf = 1.03 ; %reference gain
k_total = k* 0.5 *m*cp ;

%define state
T(1) = 15 ;  %initial state


%define convection
function Q_conv = conv(Tout, Tin, h)
dT = Tout - Tin ;
Q_conv = h * dT ;
end

%define P-control
function Q_add = heat(Tref, Tin, k, kf, Qmax)    %input
e = kf*Tref - Tin ;
Q_add = min(k*e, Qmax) ;
end

%energy balance and updating
function Tnew = Q(Q_conv, Q_add, Tin, Csp)    %output
Qtotal = Q_conv + Q_add ;
Tnew = Tin + Qtotal/(Csp) ;
end


for i = 1:(l-1)
    Q_conv(i) = conv(T_amb(i), T(i), h) ;
    Q_add(i) = heat(Tref, T(i), k_total, kf, Qmax) ;
    T(i+1) = Q(Q_conv(i), Q_add(i), T(i), Csp) ;
end 

figure;
hold on
plot(t/60, T, "g-", LineWidth=3)
plot(t/60, T_amb, "b-")
plot([0, 24], [Tref, Tref])
plot(t/60, Tref-T, "r--")
legend("T Greenhouse", "T outside", "T reference", "Error")
ylabel("Temperature") ; xlabel("Time")

hold off
figure;
plot(t(1:end-1)/60, Q_add)
ylabel("Input power") ; xlabel("Time")

figure;
P = Q_add*t_interval ;
for i = 1:length(Q_add)
    E(i) = sum(P(1:i)) ;
end
plot(t(1:end-1)/60, E)
ylabel("Total energy use") ; xlabel("Time")
