function intital_setpoint = setpoint(Q_air1hour, Q_air, daycost, heatingline, coolingline, dt)
    
    meansetpoint = (heatingline + coolingline) / 2;

    Q_needed = Q_air1hour - Q_air / hour ;

    averagecost = sum(daycost) / length(daycost) ; 
    Costdirection = averagecost - daycost ;

    if Q_needed > 0 
        intital_setpoint = meansetpoint + 0.1 * Costdirection * dt ;
    else
        intital_setpoint = meansetpoint - 0.1 * Costdirection * dt ;
    end


