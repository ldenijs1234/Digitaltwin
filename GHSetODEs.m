%   dx/dt = function(GH, i)
GH = GH ;

function AirTemperatureDot = ODE_AirTemperature(GH, i)
    C_AirVolumeGH = GH.p.GHVolume * GH.p.rho_air * GH.p.cp_air ;

    Q_Heating = GH.u.Heating(i) ;
    Q_RoofConv = GH.p.h_WallInside *(GH.x.WallTemperature(i) - GH.x.AirTemperature(i)) ;

    Q = Q_RoofConv + Q_Heating ;% + Q_floor + Q_sky  + Q_lamp + Q_soil + Q_vent + Q_plant 
    AirTemperatureDot = Q/C_AirVolumeGH ;

end

function WallTemperatureDot = ODE_WallTemperature(GH, i)
    C_WallsGH = GH.p.GHTotalArea * GH.p.WallThickness * GH.p.rho_glass * GH.p.cp_glass ;

    Q_RoofConvIn = -GH.p.h_WallInside *(GH.x.WallTemperature(i) - GH.x.AirTemperature(i)) ;
    Q_RoofConvOut = -GH.p.h_WallOutside *(GH.x.WallTemperature(i) - GH.d.OutsideTemperature(i)) ;

    Q = Q_RoofConvIn + Q_RoofConvOut  ;% + Q_floor + Q_sky  + Q_lamp + Q_soil + Q_vent + Q_plant 
    WallTemperatureDot = Q/C_WallsGH ;

end


% Euler Integration
for i = 1: (length(GH.d.Time)-1)
    GH.x.AirTemperature(i+1) = GH.x.AirTemperature(i) + ODE_AirTemperature(GH, i)*dt ;
    GH.x.WallTemperature(i+1) = GH.x.WallTemperature(i) + ODE_WallTemperature(GH, i)*dt ;
end

plot(GH.d.Time/dt, GH.x.AirTemperature)
hold on
plot(GH.d.Time/dt, GH.x.WallTemperature, "y")
plot(GH.d.Time/dt, GH.d.OutsideTemperature, "b--")