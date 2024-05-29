
function [error, OpenWindowAngle] = WindowController(T_air, setpoint, dt)
    k = 10 ;
    % Calculate error
    error = setpoint - T_air;

    % Calculate control output
  
    WindowAngle = min(45, -k * error);
    OpenWindowAngle = max(0, WindowAngle);   
end