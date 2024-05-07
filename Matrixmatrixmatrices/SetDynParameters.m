% Dynamic parameter functions

% Heat capacities, can be dynamic
%cap = [3000*1.293*1000; A_cover*0.003*840*2500; 100*4020; 830*A_floor*0.2*1600];

% Convection coefficients, can de dynamic
h_ap = 5;  % Convection between air and plant
h_ac = 5;  % Convection between air and cover
h_af = 5;  % Convection between air and floor  
h_out = 20;  % Convection between outside air and greenhouse

ConvectionCoefficientsIn = [0; h_ac; h_ac; h_ap; h_af] ;

ConvectionCoefficientsOut = [h_out] ;


% Ventilation rate
function VentilationRate = VentilationRate(GH, T_air, WindSpeed, T_out)
    u = GH.u ; p = GH.p ; d = GH.d ; x = GH.x ;

    G_l = 2.29e2 * (1 - exp(-u.OpenWindowAngle/21.1)) ; % leeside
    G_w = 1.2e-3 * u.OpenWindowAngle * exp(u.OpenWindowAngle/211) ; % windward side
    v_wind = (G_l + G_w) * p.WindowArea * WindSpeed ;
    H = p.WindowHeight * (sind(p.RoofAngle)- sind(p.RoofAngle - u.OpenWindowAngle)) ;
    v_temp = p.C_f * p.WindowLength/3 * (abs(p.Gravity*p.BetaAir*(T_air ... 
    - T_out)))^(0.5) * H^(1.5) ;

    VentilationRate = 0.5 * (p.NumberOfWindows/p.GHFloorArea) * (v_wind^2 + v_temp^2)^(0.5) ;
end

