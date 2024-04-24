%% Parameters
T_amb = 15;
T_ref = 25;
K_p = 1/T_ref - 1/T_amb;


h_buiten = 100;
h_binnen = 100;
k_wall = 5.7;

cp = 718;
rho = 1.29;

A = 30;
V = 60;
m = rho * V;
d_wall = 5 * 10-3;

R_wall = 1/h_buiten + d_wall/k_wall + 1/h_binnen;
%% Transfer function
c = (R_wall*m*cp)/A;
G = T_amb * tf([0 1],[c 1]);
R = K_p
L = G * R
CL = G/(1+L)
bode(L)