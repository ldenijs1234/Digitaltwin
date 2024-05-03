% Energy flow functions

function Q = convection(hin, hout, T, T_out, Area)   % Convective heat flow array from with coefficient h with dt-matrix
    Convection_matrix =  [ 0, 0,0,0   ;              % Convection matrix for easy calculation using temperature vector
                           1,-1,0,0  ; 
                           1,0,-1,0  ;
                           1,0,0,-1] ;
    dT = Convection_matrix * T ;
    Q  = Area .* hin .* dT ;
    Q(1) = -sum(Q) ;                                % Convective heat flow to air
    Q(2) = Q(2) + Area(2) * hout * (T_out - T(2)) ; 
end

function Q = LatentHeat(mv)    % Latent heat of evaporation of water mass flow mv
    Q = 2.45e6 * mv ;
end


for i = 1:length(t) - 1
    HeatFlow(:, i) = convection(ConvectionCoefficientsIn, ConvectionCoefficientsOut, Temperatures(:, i), OutsideTemperature, Area) ;
    Temperatures(:,i + 1) = Temperatures(:,i) + HeatFlow(:, i) ./ cap * dt ;
end

plot(t, Temperatures)
legend('air', 'cover', 'plant', 'floor')