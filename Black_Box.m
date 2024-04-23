%% Geometric parameters
Width = 4; % in meters
Length = 4; % in meters
Height = 4; % in meters
thickness = 1;            % m (thickness of walls)
V = Width * Length * Height; % in m^3
A = 2*Length*Width + 2 * Length * Height + 2* Width * Height; % in m^2

%% Initial temperature distribution
rho_air = 1.2;          % kg/m^3 (density of air)
specific_heat_air = 1005;   % J/(kg*K) (specific heat capacity of air)
thermal_conductivity = 0.024; % W/(m*K) (thermal conductivity of air)
R_wall = 1/specific_heat_air + thickness/thermal_conductivity + 1/specific_heat_air; % m^2*K/W (thermal resistance of walls)


%% Thermodynamical Properties

T_in = 15; % in degrees celcius

m = rho_air*V;
t = 0:0.5:24;
t = t.*3600;
dt = 0.5*3600;

T_room = [1:numel(t)];
T_room(1) = T_in;

for i = 1:(numel(t)-1)
    T_out = 15 + 5*sin(2*pi*t(i)/(24*3600)); % in degrees celcius
    dT = T_out-T_in;
    Q_in = dt*A*dT/R_wall;	% Heat transfer due to temperature difference
    Q_r(i) = T_room(i).*m*specific_heat_air;
    Q_new(i) = Q_r(i) + Q_in;
    T_room(i+1) = Q_new(i)/(m*specific_heat_air);
end
    
plot(t/3600,T_room)
hold on
plot(t/3600,15 + 5*sin(2*pi*t/(24*3600)),'--')
xlabel('time in hours')
ylabel('Temperature in degrees celcius')