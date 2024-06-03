

function [integral, error, ControllerOutputWatt] = PIController(GH, T_air, setpoint, dt, integral, prev_error)
    %PI controller
    k = 1000*(GH.p.GHFloorArea/500);        % Multiplication
    kp = 10;       % Proportional gain
    ki = 0.00001;       % Integral gain
    kd = 000;          %derivative gain
    
    % Initialize variables
    % Calculate error
    error = setpoint - T_air;
    % Update integral term
    integral = max(0, integral + error * dt);
    
    derivative = (error - prev_error) / dt;
    % Calculate control output
    proportional = kp * error;
    integral_component = ki * integral;
    derivative_component = kd * derivative;
    BoilerMaxWatt = 1000000*(GH.p.GHFloorArea/500); % Dummy

    Watt_Controller = k * (proportional + integral_component + derivative_component);
    Unlim_ControllerOutput = max(0, Watt_Controller);
    ControllerOutputWatt = min(BoilerMaxWatt, Unlim_ControllerOutput);
    
    
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


