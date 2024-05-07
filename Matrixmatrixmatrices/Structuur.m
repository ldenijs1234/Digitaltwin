%state 1: Air
%state 2: walls
%state 3: floor
%state 4: plant

function q = Fq_rad_out(emissivity, T)                          %imput: emissivity array and T(:,i)
    q = 5.670374419*10^-8 * emissivity .* ((T + 273.15).^4);    %emittance of components
end                                                             %q(:,i) = F


function Q = FQ_rad_in(absorbance, diffuse, Area, Viewf, qrad)      %imput: parameter arrays, viewfactor matrix and q radiance array(:,i)
    Q = absorbance .* (Area .* Viewf * qrad);                       %how much each object absorbs
    Q(1,:) = sum(diffuse .* Area .* Viewf * qrad);                   %inside air recieves diffused radiation
end


function Q = FQ_solar(transmission, diffuse, absorbance, Areasun, Isun)     %input: transmission of the cover, parameter arrays and I_sun(i)
    Q = [0; 1;transmission; transmission] .* absorbance .* Areasun * Isun; %absorbed sun radiation by each object
    Q(1,:) = sum(diffuse(3:end,:) .* Areasun(3:end,:) * Isun)     ;          %inside air recieves diffused sun radiation of everything except cover
end


function Q = convection(hin, hout, T, T_out, Area)   % Convective heat flow array from with coefficient h with dt-matrix
    Convection_matrix = - eye(length(T));
    Convection_matrix(:, 1) = 1;
    Convection_matrix(1,1) = 0;
    dT = Convection_matrix * T ;
    Q  = Area .* hin .* dT ;
    Q(1) = -sum(Q) ;                                % Convective heat flow to air
    Q_out = Area(2) * hout * (T_out - T(2)) ;       % Convection with outside air
    Q(2) = Q(2) + Q_out; 
end

function [Q, QFloor] = FGroundConduction(GH, i, FloorTemperature, T)
    Q = zeros(height(T), 1) ;
    FloorTemperature(1, i) = T(3) ;
    for j = 2:10 %Top layer has more complex heat balance, bottom layer is ground layer so take 5-13
        Qup = (FloorTemperature(j-1, i) - FloorTemperature(j,i)) / GH.p.GHFloorThickness * GH.p.KFloor ;%Heat flow from upper layer to j-th layer
        Qdown = (FloorTemperature(j+1,i) - FloorTemperature(j,i)) / GH.p.GHFloorThickness * GH.p.KFloor ;%Heat flow from lower layer to j-th layer
        QFloor(j) = Qup + Qdown ; %heat balance in j-th layer
    end
    Q(3) = (FloorTemperature(2,i) - FloorTemperature(1,i)) / GH.p.GHFloorThickness * GH.p.KFloor ;


end

function Q = HeatByVentilation(GH, T_air, T_out, VentilationRate)
    massflow = GH.p.rho_air * GH.p.NumberOfWindows*GH.p.WindowArea * VentilationRate ;
    Q = (T_out - T_air) * massflow * GH.p.cp_air ;
end

function [W_trans, W_cond, W_vent] = vaporflows(GH, T_air, T_wall, T_out, H_air, H_out, DryMassPlant, VentilationRate)
    
    G_c = 1.8e-3 * (max(0, (T_air - T_wall)))^(1/3) ; %m/s

    W_trans = (1 - exp(-GH.p.C_pld * DryMassPlant)) * GH.p.C_vplai * ...
    ((GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (T_air + 273.15))) ...
    * exp(GH.p.C_v2 * T_air / (T_air + GH.p.C_v3)) ...
    - H_air)  ;%kg m^-2 s^-1
    W_cond = (G_c * (0.2522 * exp(0.0485 * T_air) * (T_air ... 
    - T_out) - ((5.5638 * exp(0.0572 * T_air)) - H_air*1000)))/1000 ; %kg m^-2 s^-1
    W_vent = VentilationRate * (H_air - H_out) * GH.p.NumberOfWindows*GH.p.WindowArea/GH.p.GHFloorArea ; %kg m^-2 s^-1
   

end


function HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent)
    CAP_Water = GH.p.GHVolume / GH.p.GHFloorArea; %m

    W = - W_vent - W_cond + W_trans; %kg m^-2 s^-1 
    HumidityDot = W / CAP_Water ; %kg m^-3 s^-1
end



for i = 1:length(t) - 1
    %Variable parameter functions (+ convection rate, ventilation rate...)

    [Q_ground(:, i), QFloor(:, i)] = FGroundConduction(GH, i, FloorTemperature(: i), T(:, i)) ;
    for j = 2:10
        FloorTemperature(j,i+1) = FloorTemperature(j,i) + QFloor(j) / (CAPArray(3) / GH.p.GHFloorArea) * dt ;
    end

    %Q functions (+ convection conduction...)
    q_rad_out(:,i) = Fq_rad_out(EmmitanceArray, T(:,i));
    Q_rad_in(:,i) = FQ_rad_in(FIRAbsorbanceArray, FIRDiffuseArray, AreaArray, ViewArray, q_rad_out(:,i));
    Q_solar(:,i) = FQ_solar(SOLARTauGlass, SOLARDiffuseArray, SOLARAbsorbanceArray, AreaSunArray,200);
    Q_conv(:,i) = convection(ConvectionCoefficientsIn, ConvectionCoefficientsOut, T(:,i), OutsideTemperature, AreaArray);
    Q_vent(1, i) = HeatByVentilation(GH, T(1, i), OutsideTemperature, VentilationRate) ;
    Q_vent(2: height(T), i) = zeros(height(T)-1, 1) ;
    

    %Total heat transfer
    Q_tot(:,i) = Q_vent(:, i) + Q_rad_in(:,i) + Q_solar(:,i) - AreaArray .* q_rad_out(:,i) + Q_conv(:,i) + Q_ground(:, i);

    % Temperature Change
    T(:,i + 1) = T(:,i) + Q_tot(:,i) ./ CAPArray * dt;

    % Vapor flows and balance
    [W_trans(i), W_cond(i), W_vent(i)] = vaporflows(GH, T(1, i), T(2, i), OutsideTemperature, AddStates(1, i), OutsideHumidity, DryMassPlant, VentilationRate);
    HumidityDot = HumidityBalance(GH, W_trans(i), W_cond(i), W_vent(i));
    AddStates(1, i+1) = AddStates(1, i) + HumidityDot*dt ;
    
end

figure;
plot(t,T)
legend('T air', 'T cover', 'T floor', 'T plant')
hold off

figure;
plot(t, FloorTemperature)
