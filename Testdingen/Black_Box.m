%% Geometric parameters
Width = 10; % in meters
Length = 20; % in meters
Height = 4; % in meters
number_of_triangles = 6; % number of triangles in the roof
roof_angle = 30; % degrees
width_roof_tile = ((0.5 * (Width / number_of_triangles)) / cosd(roof_angle)); % meters
thickness = 1;  % m (thickness of walls)
V = Width * Length * Height + number_of_triangles * (width_roof_tile * sind(roof_angle)) * (width_roof_tile * cosd(roof_angle)) * Length; % in m^3
A = (2 * Length * Height + 2 * Width * Height) + (2 * number_of_triangles * width_roof_tile * Length) + (number_of_triangles * (width_roof_tile * sind(roof_angle)) * (width_roof_tile * cosd(roof_angle))); % in m^2

disp(['Volume of the greenhouse is ', num2str(V), ' m^3'])
disp(['Surface area of the greenhouse is ', num2str(A), ' m^2'])
disp(['Width of the roof tile is ', num2str(width_roof_tile), ' m'])

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

T_desired = 22; % in degrees celcius
%T_room = [1:numel(t)];
%T_room(1) = T_in;
% Initialize T_room array with initial temperature (T_in) for each time step
T_room = ones(1, numel(t)) * T_in;

for i = 1:(numel(t)-1)
    T_out = 15 + 5*sin(2*pi*t(i)/(24*3600)); % in degrees celcius
    dT = T_out-T_room(i); % in degrees celcius
    Q_in = dt*A*dT/R_wall;	% Heat transfer due to temperature difference
    Q_r = T_room(i).*m*specific_heat_air; % Heat in the room
    Q_new = Q_r + Q_in; % Total heat in the room without heater
    T_room(i+1) = Q_new/(m*specific_heat_air); % in degrees celcius
    Q_needed = (T_desired - T_room(i+1)) * m * specific_heat_air; % Heat transfer due to heater
    Q_heat = min([Q_needed, 6000000]); % Heater power
    Q_total = Q_new + Q_heat; % Total heat in the room with heater
    T_heatroom(i+1) = Q_total/(m*specific_heat_air); % in degrees celcius
end

figure;
hold on 
plot(t/3600,T_room)
plot(t/3600,T_heatroom)
plot(t/3600,15 + 5*sin(2*pi*t/(24*3600)),'-')
plot(t/3600,T_desired,'--')
xlabel('time in hours')
ylabel('Temperature in degrees celcius')
legend('T room','T room with heater','T outside','T desired')

figure; 
hold on 
plot(t(1:end-1)/3600,Q_heat,'r')
plot(t(1:end-1)/3600,Q_r,'b')
plot(t(1:end-1)/3600,Q_needed,'g')	
legend('Q heater', 'Q natural', 'Q needed')


