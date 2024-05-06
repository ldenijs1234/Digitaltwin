function q = Fq_rad_out(emissivity, T)                          %imput: emissivity array and T(:,i)
    q = 5.670374419*10^-8 * emissivity .* ((T + 273.15).^4);    %emittance of components
end                                                             %q(:,i) = F


function Q = FQ_rad_in(absorbance, diffuse, Area, Viewf, qrad)      %imput: parameter arrays, viewfactor matrix and q radiance array(:,i)
    Q = absorbance .* (Area .* Viewf * qrad);                       %how much each object absorbs
    Q(1,:) = sum(diffuse .* Area .* Viewf * qrad);                   %inside air recieves diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun)     %input: transmission of the cover, parameter arrays and I_sun(i)
    Q = [0; transmission; 1; transmission] .* absorbance .* Areasun * Isun; %absorbed sun radiation by each object
    Q(1,:) = sum(diffuse(3:end,:) .* Areasun(3:end,:) * Isun)               %inside air recieves diffused sun radiation of everything except cover
end


function Q = convection(hin, hout, T, T_out, Area)   % Convective heat flow array from with coefficient h with dt-matrix
    Convection_matrix =  [ 0, 0,0,0   ;              % Convection matrix for easy calculation using temperature vector
                           1,-1,0,0  ; 
                           1,0,-1,0  ;
                           1,0,0,-1] ;
    dT = Convection_matrix * T ;
    Q  = Area .* hin .* dT ;
    Q(1) = -sum(Q) ;                                % Convective heat flow to air
    Q(2,:) = Q(2,:) + Area(2) * hout * (T_out - T(2,:)) ; 
end


for i = 1:length(t) - 1
    %Variable parameter functies (+ convection rate, ventilation rate...)

    %Q functions (+ convection conduction...)
    q_rad_out(:,i) = Fq_rad_out(EmmitanceArray, T(:,i));
    Q_rad_in(:,i) = FQ_rad_in(AbsorbanceArray, DiffuseArray, AreaArray, ViewArray, q_rad_out(:,i));
    Q_solar(:,1) = FQ_solar(TauGlass, DiffuseArray, AbsorbanceArray, AreaSunArray,700);
    Q_conv(:,i) = convection(ConvectionCoefficientsIn, ConvectionCoefficientsOut, T(:,i), OutsideTemperature, AreaArray);
    %Totale heat transfer
    Q_tot(:,i) = Q_rad_in(:,i) + Q_solar(:,i) - Area .* q_rad_out(:,i) + Q_conv(:,i);

    %Temperatuur verandering
    T(:,i + 1) = T(:,i) + Q_tot(:,i) ./ Cap * dt;
end

plot(t,T)
legend('T air', 'T cover', 'T floor', 'T plant')