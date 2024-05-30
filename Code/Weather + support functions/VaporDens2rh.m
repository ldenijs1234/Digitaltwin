% Calculation of vapor density in kg/m^3 to relative humidity


function rh = VaporDens2rh(Temperature, VaporDens)
    h_abs = VaporDens*1000; % absolute humidity of the outside air in g/m^3
    C = 2.16679; % constant in gK/J
    P_w = h_abs.*(Temperature+273.15)/C; % water vapour pressure
    P_ws = 6.116441*10^(7.591386*(T)/(T+240.7263));  % saturation vapour pressure

    rh = P_w/P_ws; % relative humidity for range -20 to +50 celsius
end