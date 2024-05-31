function intitial_setpoint = setpoint(Q_air1hour, Q_air, cost1hour, cost, heatingline, coolingline, dt)
    
    meansetpoint = (heatingline + coolingline) / 2;

    Q_delta = Q_air1hour - Q_air / hour ;

    Costdirection1hour = averagecost - cost1hour ;
    Costdirection = averagecost - cost ;
    
    if Q_delta < 0 && cost < cost1hour 
        intital_setpoint = meansetpoint * (1 + Costdirection)
    elseif Q_delta > 0 && cost1hour > cost
        intital_setpoint = meansetpoint * (1 - Costdirection)


    end

end

intitial_setpoint = setpoint(Q_air1hour, Q_air, cost1hour, cost, heatingline, coolingline, dt)  ;



    


