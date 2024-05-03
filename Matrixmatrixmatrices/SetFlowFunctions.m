% Energy flow functions

function q12 = convection(h, T1, T2)   % Convective heat flow from 1 to 2 with coefficient h
    q12 = h*(T1 - T2) ;
end

function Q = LatentHeat(mv)    % Latent heat of evaporation of water mass flow mv
    Q = 2.45e6 * mv ;
end