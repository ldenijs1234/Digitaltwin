% Energy flow functions

function Heatflows = convection(h, T)   % Convective heat flow array from with coefficient-matrix h
    Heatflows  = h * T ;
    Heatflows(1) = -sum(Heatflows) ;
end

function Q = LatentHeat(mv)    % Latent heat of evaporation of water mass flow mv
    Q = 2.45e6 * mv ;
end

