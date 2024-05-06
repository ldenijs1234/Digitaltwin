function q = Fq_rad_out(emissivity, T)                          %imput: emissivity array and T(:,i)
    q = 5.670374419*10^-8 * emissivity .* ((T + 273.15).^4);    %emittance of components
end                                                             %q(:,i) = F


function Q = FQ_rad_in(absorbance, diffuse, Area, Viewf, qrad)      %imput: parameter arrays, viewfactor matrix and q radiance array(:,i)
    Q = absorbance .* (Area .* Viewf * qrad);                       %how much each object absorbs
    Q(1,:) = sum(diffuse .* Area .* Viewf * qrad);                   %inside air recieves diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun)     %input: transmission of the cover, parameter arrays and I_sun(i)
    Q = [0; transmission; 1; transmission] .* absorbance .* Areasun * Isun; %absorbed sun radiation by each object
    Q(1,:) = sum(diffuse(3:end,:) .* Areasun(3:end,:) * Isun)     ;          %inside air recieves diffused sun radiation of everything except cover
end


function Q = convection(hin, hout, T, T_out, Area)   % Convective heat flow array from with coefficient h with dt-matrix
    Convection_matrix =  [ 0, 0,0,0   ;              % Convection matrix for easy calculation using temperature vector
                           1,-1,0,0  ; 
                           1,0,-1,0  ;
                           1,0,0,-1] ;
    dT = Convection_matrix * T ;
    Q  = Area .* hin .* dT ;
    Q(1) = -sum(Q) ;                                % Convective heat flow to air
    Q_out = Area(2) * hout * (T_out - T(2)) ;       % Convection with outside air
    Q(2) = Q(2) + Q_out; 
end

function Q = FloorConduction(GH, i)
    for j = 5:13 %Top layer has more complex heat balance, bottom layer is ground layer so take 5-13
        Qup = (Temperatures(j-1, i) - Temperatures(j,i)) / GH.p.GHFloorThickness * GH.p.KFloor %Heat flow from upper layer to j-th layer
        Qdown = (Temperatures(j+1,i) - Temperatures(j,i)) / GH.p.GHFloorThickness * GH.p.KFloor %Heat flow from lower layer to j-th layer
        Q(j, i) = Qup + Qdown %heat balance in j-th layer
    end
end

function [W_trans, W_cond, W_vent] = vaporflows(GH, T_air, T_wall, T_out, H_air, H_out, DryMassPlant, VentilationRate)
    
    G_c = max(0, (1.8e-3 * (T_air - T_wall)^(1/3))) ; %m/s

    W_trans = (1 - exp(-GH.p.C_pld * DryMassPlant)) * GH.p.C_vplai * ...
    ((GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (T_air + 273.15))) ...
    * exp(GH.p.C_v2 * T_air / (T_air + GH.p.C_v3)) ...
    - H_air)  ;%kg m^-2 s^-1
    W_cond = (G_c * (0.2522 * exp(0.0485 * T_air) * (T_air ... 
    - T_out) - ((5.5638 * exp(0.0572 * T_air))*1000 - H_air*1000)))/1000 ; %kg m^-2 s^-1
    W_vent = VentilationRate * (H_air - H_out) ; %kg m^-2 s^-1
   

end


function HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent)
    CAP_Water = GH.p.GHVolume / GH.p.GHFloorArea; %m

    W = - W_vent - W_cond + W_trans; %kg m^-2 s^-1 
    HumidityDot = W / CAP_Water ; %kg m^-3 s^-1
end



for i = 1:length(t) - 1
    %Variable parameter functies (+ convection rate, ventilation rate...)

    %Q functions (+ convection conduction...)
    q_rad_out(:,i) = Fq_rad_out(EmmitanceArray, T(:,i));
    Q_rad_in(:,i) = FQ_rad_in(AbsorbanceArray, DiffuseArray, AreaArray, ViewArray, q_rad_out(:,i));
    Q_solar(:,i) = FQ_solar(TauGlass, DiffuseArray, AbsorbanceArray, AreaSunArray,200);
    Q_conv(:,i) = convection(ConvectionCoefficientsIn, ConvectionCoefficientsOut, T(:,i), OutsideTemperature, AreaArray);
    %Totale heat transfer
    Q_tot(:,i) = Q_rad_in(:,i) + Q_solar(:,i) - AreaArray .* q_rad_out(:,i) + Q_conv(:,i);

    %Temperatuur verandering
    T(:,i + 1) = T(:,i) + Q_tot(:,i) ./ CAPArray * dt;

    % Vapor flows and balance
    [W_trans, W_cond, W_vent] = vaporflows(GH, T(1, i), T(2, i), OutsideTemperature, AddStates(1, i), OutsideHumidity, DryMassPlant, VentilationRate);
    HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent);
    AddStates(1, i+1) = AddStates(1, i) + HumidityDot*dt ;
    
end

plot(t,T)
legend('T air', 'T cover', 'T floor', 'T plant')