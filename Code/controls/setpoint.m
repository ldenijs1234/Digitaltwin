function intital_setpoint = setpoint(Q_air1hour, Q_air, cost1hour, cost, heatingline, coolingline, dt)
    
    meansetpoint = (heatingline + coolingline) / 2;

    Q_delta = Q_air1hour - Q_air / hour ;

    Costdirection1hour = averagecost - cost1hour ;
    Costdirection = averagecost - cost ;
    
    if Q_delta < 0 && Costdirection1hour < Costdirection 
        intital_setpoint = meansetpoint * (1 + 0.5*)


    


