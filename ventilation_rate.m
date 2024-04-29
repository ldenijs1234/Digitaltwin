%inputs 
A = 100; % m^2 (surface area of the greenhouse)
roof_angle = 30; % degrees (angle of the roof)
theta = 10; % degrees (angle of the window)
number_of_windows = 10; 
l = 1.5; % m (length of the window)
h = 0.5; % m (height of the window)
A_0 = l * h; % m^2
C_f = 0.6;  % discharge of energy caused by friction in the window opening coefficient
g = 9.81; % m/s^2
beta = 1/287; % K^-1 (thermal expansion coefficient of air)
c_air = 1005; % J/(kg*K) (specific heat capacity of air)
rho = 1.2; % kg/m^3 (density of air)
t = 0:0.5:24; % time in hours

%function
function v_vent = calculate_ventilation_rate(A, roof_angle, theta, number_of_windows, l, h, C_f, g, beta, c_air, rho, t)
    % Constants
    Gl = 2.29 * 10^-2 * (1 - exp(-theta / 21.1)); % Leeside ventilation coefficient
    Gw = 1.2 * 10^-3 * theta * exp(theta / 211); % Windward side ventilation coefficient

    % Wind speed (assumed constant for simplicity)
    u = 1.5; % Wind speed in m/s (example value)

    % Area of roof
    A0 = l * h; % m^2 (Area of one window)

    for i = 1:length(t)
    % Thermal difference (Tin - Tout), assumed to be 5 degrees Celsius for example
    Tin = 25; % Inside temperature in degrees Celsius
    Tout = 15 + 5*sin(2*pi*t(i)/(24*3600)); % Outside temperature in degrees Celsius
    delta_T = Tin - Tout; % Temperature difference in degrees Celsius
    end

    % Ventilation rate due to wind
    v_wind = (Gl + Gw) * A0 * u; % m^3/s/window

    H = h * (sind(roof_angle) - sind(roof_angle - theta)); % Height of the window opening (m)

    % Ventilation rate due to temperature difference
    v_temp = C_f * (l/3) * abs(g * beta * delta_T)^0.5 * H^1.5; % m^3/s/window

    % Total ventilation rate
    v_windows = number_of_windows / A; % Windows per square meter
    v_vent = 0.5 * v_windows * (v_wind^2 + v_temp^2)^0.5; % m^3/m^2/s

    % Display intermediate results (optional)
    disp(['Gl: ', num2str(Gl)]);
    disp(['Gw: ', num2str(Gw)]);
    disp(['vwind: ', num2str(v_wind), ' m^3/s/window']);
    disp(['vtemp: ', num2str(v_temp), ' m^3/s/window']);
end

%output
v_vent = calculate_ventilation_rate(A, roof_angle, theta, number_of_windows, l, h, C_f, g, beta, c_air, rho);

disp(['The ventilation rate is: ', num2str(v_vent), ' m^3/m^2/s']);
