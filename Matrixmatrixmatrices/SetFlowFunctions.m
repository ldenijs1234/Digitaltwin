% Energy flow functions

function Heatflows = convection(h, dT)   % Convective heat flow array from with coefficient h with dt-matrix
    Heatflows  = h .* dT ;
    Heatflows(1) = -sum(Heatflows) ;
end

function Q = LatentHeat(mv)    % Latent heat of evaporation of water mass flow mv
    Q = 2.45e6 * mv ;
end

dT_test = Convection_matrix * Temperatures ;

q = convection(ConvectionCoefficientsIn, dT_test)