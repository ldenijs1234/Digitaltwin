
function [error, OpenWindowAngle, U_fog] = WindowController(T_air, setpoint, dt)
    kp = 10 ;
    kf = 0.1 ;
    % Calculate error
    error = setpoint - T_air;

    % Calculate control output
  
    WindowAngle = min(45, -kp * error);
    OpenWindowAngle = max(0, WindowAngle); 
    Fog = min(1, -kf * error);
    U_fog = max(0, Fog);  

end