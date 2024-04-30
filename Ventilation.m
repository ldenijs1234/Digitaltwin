% ventilation function

GH = GH ;

function VentilationRate = VentilationRate(GH, i)
    G_l = 2.29e2 * (1 - exp(-GH.u.OpenWindowAngle/21.1)) ; % leeside
    G_w = 1.2e-3 * GH.u.OpenWindowAngle * exp(GH.u.OpenWindowAngle/211) ; % windward side
    v_wind = (G_l + G_w) * GH.p.WindowArea * GH.d.WindSpeed(i) ;
    H = GH.p.WindowHeight * (sin(GH.p.RoofAngle)- sin(GH.p.RoofAngle - GH.u.OpenWindowAngle)) ;
    v_temp = GH.p.C_f * GH.p.WindowLength/3 * (abs(GH.p.Gravity*GH.p.BetaAir*(GH.x.AirTemperature(i) ... 
    - GH.d.OutsideTemperature(i))))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * (GH.p.NumberOfWindows/GH.p.GHGroundArea) * (v_wind^2 + v_temp^2)^(0.5) ;
end
 