%   dx/dt = function(GH, i)

function AirTemperatureDot = ODE_AirTemperature(GH, i)
    C_AirVolumeGH = GH.p.GHVolume * GH.p.rho_air * GH.p.cp_air ;

    Q_RoofConv = GH.p.h_WallInside *(GH.x.WallTemperature(i) - GH.x.AirTemperature(i)) ;

    Q = Q_RoofConv  ;% + Q_floor + Q_sky  + Q_lamp + Q_soil + Q_vent + Q_plant 
    AirTemperatureDot = Q/C_AirVolumeGH ;

end