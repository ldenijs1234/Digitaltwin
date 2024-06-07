
function [errorT, OpenWindowAngle, U_fog] = WindowController(T_air, setpoint)
    kw = 2.5 ;
    % kHw = 0.0005 ;
    % kHf = 0.005 ;

    % Calculate error
    errorT = T_air - setpoint;
    % set_H = 70 ;
    % errorH = set_H - RelHumidity ;

    % Calculate control output
  
    WindowAngle = min(45, kw * errorT ); % - kHw * errorH
    OpenWindowAngle = max(0, WindowAngle); 
    Fog = min(1, kf * errorT ); %+ kHf * errorH
    U_fog = max(0, Fog);  

end