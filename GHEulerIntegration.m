%     Integrating


for i = 1: (length(GH.d.Time)-1)
    GH.x.AirTemperature(i+1) = GH.x.AirTemperature(i) + ODE_AirTemperature(GH, i)*dt ;
    GH.x.WallTemperature(i+1) = GH.x.WallTemperature(i) + ODE_WallTemperature(GH, i)*dt ;
end