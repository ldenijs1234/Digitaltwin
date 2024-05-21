%%inputs
m = 0.1; %mass flow through the pipe in kg/s
T_in = 60; % temperature of the flow at the inlet in celsius
T_air = 25; % temperature of the inside air
T_pipe = 50; % temperature of the outside of the pipe
H_out = 0.012; % Kg/m^3
C_out = 0.0464; % Kg/m^3
L = 200; % length of the pipe
F = 40; % Fins per meter of pipe %!!!!keep the thickness in mind not more fins then fit on the pipe!!!!
g = 9.81;
dT = T_pipe - T_air;
r_0 = 0.05; % inside radius of the pipe in meters
r_1 = 0.055; % outside radius of the pipe in meters
r_2 = 0.1; % outside radius of the fin in meters
k = 180; % conductive heat transfer coefficient of the material in W/(m*K)
t = 0.003; % half of the thickness of one fin in meters
A_in = pi*r_0^2; % Area of inside of the pipe
k_alu = 237; %conduction coefficient aluminium for the pipe in W/(m*K)

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

%% Interpolation in table
T = [275,280,285,290,295,300,310,320,330,340,350,360,370,373.15,380,390,400];
Pr_array = [12.9,10.7,9,7.8,6.7,5.9,4.6,3.8,3.2,2.7,2.4,2,1.81,1.76,1.65,1.51,1.40];
T_array = T-273.15;
k_array = [0.556,0.568,0.58,0.591,0.602,0.611,0.628,0.641,0.652,0.661,0.669,0.676,0.68,0.681,0.683,0.684,0.685];
c_p_array = [4217,4203,4192,4186,4181,4178,4174,4174,4178,4184,4190,4200,4209,4212,4220,4234,4250];
k_water = interp1(T_array,k_array,T_in); %Conductive heat coefficient of water in W/(m*K)
Pr = interp1(T_array,Pr_array,T_in); %parental number from table from "Basic heat and mass transfer"
c_p = interp1(T_array,c_p_array,T_in);

mu = water.rho(T_in)*water.nu(T_in); %dynamic viscosity
Re = (m/A_in)*2*r_0/mu; %reynolds number
f = (0.790*log(Re)-1.64)^(-2); % friction factor

Nu_inside = ((f/8)*(Re-1000)*Pr/(1+(12.7*sqrt(f/8)*(Pr^(2/3) -1)))); %Nusselt number for inside the pipe
h_inside = k_water*Nu_inside/(2*r_0);
h_total = 1/((1/(h_inside*2*pi*r_0)) + (log(r_1/r_0)/(2*pi*k_alu)) + (1/(h_pipe*Fin_efficiency*F*S+h_pipe*(1-F*2*t)*2*pi*r_1)));% heat coefficient for the entire pipe in W/(m*K)
N_tu = h_total*L/(m*c_p);
epsi = 1-exp(-N_tu);
T_out = T_in - epsi*(T_in-T_air)
