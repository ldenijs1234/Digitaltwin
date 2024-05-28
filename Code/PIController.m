

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

    
end



% function [integral, error, ControllerOutputWatt] = PIController(T_WaterOut, T_air, setpoint, dt, integral)
%     %PI controller
%     k = 2000;        % Multiplication
%     kp = 5;       % Proportional gain
%     ki = 0.000001;       % Integral gain

%     % Initialize variables
%     % Calculate error
%     error = setpoint - T_air;
%     % Update integral term
%     integral = max(0, integral + error * dt);
    
%     % Calculate control output
%     proportional = kp * error;
%     integral_component = ki * integral;
%     BoilerMaxWatt = 5000 ; %DUMMY

%     Watt_Controller = k * (proportional + integral_component);
%     Unlim_ControllerOutput = max(0, Watt_Controller);
%     ControllerOutputWatt = min(BoilerMaxWatt, Unlim_ControllerOutput);  
% end


function [error, OpenWindowAngle] = WindowController(T_air, setpoint, dt)
    k = 10 ;
    % Calculate error
    error = setpoint - T_air;

    % Calculate control output
  
    WindowAngle = min(45, -k * error);
    OpenWindowAngle = max(10, WindowAngle);   
end