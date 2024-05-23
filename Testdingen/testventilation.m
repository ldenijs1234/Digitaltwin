
function VentilationRate = VentilationRatecalc(GH, T_air, WindSpeed, T_out, OpenWindowAngle)
    p = GH.p ; 

    G_l = 2.29e2 * (1 - exp(-OpenWindowAngle/21.1)) ; % leeside
    G_w = 1.2e-3 * OpenWindowAngle * exp(OpenWindowAngle/211) ; % windward side
    v_wind = (G_l + G_w) * p.WindowArea * WindSpeed ;
    H = p.WindowHeight * (sind(p.RoofAngle)- sind(p.RoofAngle - OpenWindowAngle)) ;
    v_temp = p.C_f * p.WindowLength/3 * (abs(p.Gravity*p.BetaAir*(T_air ... 
    - T_out)))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * (p.NumberOfWindows/p.GHFloorArea) * (v_wind^2 + v_temp^2)^(0.5) ;
end


VentilationRatecalc(GH, 25, 8, 15, 30)