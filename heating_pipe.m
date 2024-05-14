%%inputs
m = 10; %mass flow through the pipe in kg/s
T_in = 60; % temperature of the flow at the inlet in celsius
T_out = 40; % temperature of the flow at the outlet in celsius
T_air = 25; % temperature of the inside air
T_pipe = 50; % temperature of the outside of the pipe
H_out = 0.012; % Kg/m^3
C_out = 0.0464; % Kg/m^3
L = 20; % length of the pipe
F = 40; % Fins per meter of pipe %!!!!keep the thickness in mind not more fins then fit on the pipe!!!!
g = 9.81;
dT = T_pipe - T_air;
r_1 = 0.01; % outside radian of the pipe in meters
r_2 = 0.04; % outside radian of the fin in meters
k = 180; % conductive heat transfer coefficient of the material in W/(m*K)
t = 0.003; % half of the thickness of one fin in meters

p = 1084; % air pressure in hpa
h_abs = H_out*1000; % absolute humidity of the outside air in g/m^3
C = 2.16679; % constant in gK/J
CO2 = C_out*1000; % CO2 in the outside air in g/m^3

mol_air = (p.*100./((T_air+273.15).*GH.p.GasConstantR)); % using the ideal gas law to find the amount of mol in air
mol_co2 = CO2/44.01;
co2 = mol_co2/mol_air;
P_w = h_abs.*(T_air+273.15)/C; % water vapour pressure
P_ws = 6.116441*10^(7.591386*(T_air)/(T_air+240.7263));  % saturation vapour pressure
h = P_w/P_ws; % relative humidity for range -20 to +50 celsius

T2 = T_air + 0.001; % small temperature change
rho = AirProperties(T_air,p,h,'xCO2',co2,'rho'); % density for this slightly different temperature
rho_2 = AirProperties(T2,p,h,'xCO2',co2,'rho'); % density for this slightly different temperature
v_1 = (1./rho).*1000; % volume for 1kg of air with the normal density
v_2 = (1./rho_2).*1000; % volume for 1kg of air with the alterd density
beta = ((v_2-v_1)./(T2-T_air))./v_1; % volumetric coefficient of expansion

k_air = AirProperties(T_air,p,h,'xCO2',co2,'k'); % conductive  heat transfer coefficient of air in W/(m*K)
mu = AirProperties(T_air,p,h,'xCO2',co2,'mu');
Gr =  beta.*abs(dT).*g.*(r_2+r_1)^3 / (mu/rho).^2; %grashoff number; 
Pr = AirProperties(T_air,p,h,'xCO2',co2,'Pr'); % thermal diffusivity;
Ra = Gr*Pr;
switch true
    case Ra <= 10^9
        Nu = (0.06+0.387*(Ra/(1+(0.559/Pr)^(9/16))^(16/9))^(1/6))^2; %Nusselt number incase of laminar flow
    case Ra > 10^9
        Nu = 0.36+0.518*Ra^0.25 /(1+(0.559/Pr)^(9/16))^(4/9);
end

h_pipe = Nu*k_air/(r_2+r_1); % convective heat transfer coefficient of the pipe in W/(m^2*K)

B = sqrt(r_1^2+t^2);
D = sqrt((r_2^2 /r_1)^2 + t^2);
S = 2*pi*r_1*(D-B+(t/2)*log(((D-t)*(B+t))/((D+t)*(B-t)))); % surface area of a fin in m^2
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