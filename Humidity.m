% Humidity

function HumidityDot = ODE_Humiditybalance(GH, i)
    CAP_Water = GH.p.GHVolume / GH.p.GHFloorArea; %m
    
    G_c = max(0, (1.8e-3 * (GH.x.AirTemperature(i) - GH.x.WallTemperature(i))^(1/3))) ; %m/s

    W_Trans = (1 - exp(-GH.p.C_pld * GH.x.DryMassPlant(i)) * GH.p.C_vplai * ...
    (GH.p.C_v1 / (GH.p.GasConstantR * 1e3 * (GH.x.AirTemperature(i) + GH.p.Kelvin))) ...
    * exp(GH.p.C_v2 * GH.x.AirTemperature(i) / (GH.x.AirTemperature(i) + GH.p.C_v3)) ...
    - GH.x.AirHumidity(i))  ;%kg m^-2 s^-1
    W_cond = (G_c * (0.2522 * exp(0.0485 * GH.x.AirTemperature(i)) * (GH.x.AirTemperature(i) ... 
    - GH.d.OutsideTemperature(i)) - ((5.5638 * exp(0.0572 * GH.x.AirTemperature(i)))*1000 - GH.x.AirHumidity(i)*1000)))/1000 ; %kg m^-2 s^-1
    W_vent = VentilationRate(GH, i) * (GH.x.AirHumidity(i) - GH.d.OutsideHumidity(i)) ; %kg m^-2 s^-1
   
    W = - W_vent - W_cond + W_Trans ;
    HumidityDot = W / CAP_Water ; %kg m^-3 s^-1

end