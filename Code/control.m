function y = bound(min, max, t1, t2, t3, t4, dt, days) %inputs: minimum and maximum, minimum before t1 and after t4, maximum at t2:t3
    time = (0:dt:24*60^2) / 60^2;
    a = min * ones(1,round(length(time) * t1 / 24));
    b = linspace(min, max, round(length(time) * (t2 - t1) / 24));
    c = max * ones(1, round(length(time) * (t3 - t2)/ 24));
    d = linspace(max, min, round(length(time) * (t4 - t3) / 24));
    e = min * ones(1, round(length(time) * (24 - t4) /24));
    y = [a, b, c, d, e];
    y = repmat(y, 1, days);
end

dt = 10 ;
tdag = (0:dt:24* 3*60^2) / 60^2;
a = bound(20, 22, 6, 10, 17, 21, dt, 3);
b = bound(22, 24, 6, 10, 17, 21, dt, 3);

figure()
hold on
plot(tdag(1:end-1), a)
plot(tdag(1:end-1), b)
hold off


function [integral, error, ControllerOutputWatt, OpenWindowAngle] = PIController(T_WaterOut, T_air, setpoint, dt, integral)
    %PI controller
    k = 2000;        % Multiplication
    kp = 5;       % Proportional gain
    ki = 0.000001;       % Integral gain
    kpv = 10 ;

    % Initialize variables
    % Calculate error
    error = setpoint - T_air;
    % Update integral term
    integral = max(0, integral + error * dt);
    
    % Calculate control output
    proportional = kp * error;
    integral_component = ki * integral;
    BoilerMaxWatt = 5000 ; %DUMMY

    Watt_Controller = k * (proportional + integral_component);
    Unlim_ControllerOutput = max(0, Watt_Controller);
    ControllerOutputWatt = min(BoilerMaxWatt, Unlim_ControllerOutput);
    WindowAngle = min(45, -kpv*error);
    OpenWindowAngle = max(10, WindowAngle);

    T_Water
end
