%%inputs
m = 10; %mass flow through the pipe in kg/s
T_in = 60; % temperature of the flow at the inlet in celsius
T_out = 40; % temperature of the flow at the outlet in celsius
T_air = 25; % temperature of the inside air
T_pipe = 50; % temperature of the outside of the pipe
L = 20; % length of the pipe
F = 40; % Fins per meter of pipe %!!!!keep the thickness in mind not more fins then fit on the pipe!!!!
%% outputs
% temperture outside pipe
% total energy
r_1 = 0.01; % outside radian of the pipe in meters
r_2 = 0.04; % outside radian of the fin in meters
h_pipe = 30; % convective heat transfer coefficient of the pipe in W/(m^2*K)
k = 180; % conductive heat transfer coefficient of the material in W/(m*K)
k_air = 0.036; % conductive  heat transfer coefficient of air in W/(m*K)
t = 0.003; % half of the thickness of one fin in meters
Gr = 10^6; 
Pr = 1;
Ra = Gr*Pr;
switch true
    case Ra <= 10^9
        Nu = (0.06+0.387*(Ra/(1+(0.559/Pr)^(9/16))^(16/9))^(1/6))^2; %Nusselt number incase of laminar flow
    case Ra > 10^9
        Nu = 0.36+0.518*Ra^0.25 /(1+(0.559/Pr)^(9/16))^(4/9);
end

h_pipe = Nu*k_air/(r_2+r_1)

B = sqrt(r_1^2+t^2);
C = sqrt((r_2^2 /r_1)^2 + t^2);
S = 2*pi*r_1*(C-B+(t/2)*log(((C-t)*(B+t))/((C+t)*(B-t)))); % surface area of a fin in m^2
V = 4*pi*t*r_1*(r_2-r_1); %volume of a fin in m^3

c = r_1/r_2; % normalized radii ratio
M = sqrt(h_pipe*r_2^3 /(k*t*r_1)); %enlarged Biot number
epsi = M*sqrt((1-c)^3 /(2*log(1/c)));
u = (2/3)*epsi*sqrt(2*log(1/c)/(1-c)^3);
v = (2/3)*epsi*sqrt(2*c^3 *log(1/c)/(1-c)^3);

Fin_efficiency = (sqrt(2*c*(1-c)^3)/(epsi*(1-c^2)))*((besseli(2/3,u)*besseli(-2/3,v)-besseli(-2/3,u)*besseli(2/3,v))...
/(besseli(-1/3,v)*besseli(-2/3,v)-besseli(2/3,u)*besseli(1/3,v))); % effective heat transfer from ideal heat transfer

A = L*F*S+(L-L*F*2*t)*2*pi*r_1; % total area of the pipe in m^2
Q_ideal = h_pipe*A*(T_pipe-T_air);
Q = Q_ideal*Fin_efficiency