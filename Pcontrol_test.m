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

%define environment
T_amb = zeros(l) + 10 ; %degrees Celcius, outside temperature

%define reference and control parameters
Tref = 25  ; %degrees Celsius
k = 3 ; %gain
k_total = k* 0.5 *m*cp ;

%define state
T(1) = 15 ;  %initial state


%define convection
function Q_conv = conv(Tout, Tin, h)
dT = Tout - Tin ;
Q_conv = h * dT ;
end

%define P-control
function Q_add = heat(Tref, Tin, k)    %input
e = Tref - Tin ;
Q_add = k*e ;
end

%energy balance and updating
function Tnew = Q(Q_conv, Q_add, Tin, Csp)    %output
Qtotal = Q_conv + Q_add ;
Tnew = Tin + Qtotal/(Csp) ;
end


for i = 1:(l-1)
    Q_conv = conv(T_amb(i), T(i), h) ;
    Q_add = heat(Tref, T(i), k_total) ;
    T(i+1) = Q(Q_conv, Q_add, T(i), Csp) ;
end 

%figure;
hold on
plot(t, T, "g-")
plot(t, T_amb, "b--")
plot([0, t(end)], [Tref, Tref])
