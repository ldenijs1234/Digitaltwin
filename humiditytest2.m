T_air = 25; %C
T_wall = 22; %C
T_out = 20; %C
H_air = 0.012; %kg m^-3
H_out = 0.01; %kg m^-3
DryMassPlant = 10; %kg
VentilationRate = 0.1; 

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

[W_trans, W_cond, W_vent] = vaporflows(GH, T_air, T_wall, T_out, H_air, H_out, DryMassPlant, VentilationRate);
HumidityDot = HumidityBalance(GH, W_trans, W_cond, W_vent);


% Works!!!!!!!!1