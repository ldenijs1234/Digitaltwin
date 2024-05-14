% Dynamic parameter functions

% Heat capacities, can be dynamic
%cap = [3000*1.293*1000; A_cover*0.003*840*2500; 100*4020; 830*A_floor*0.2*1600];

% Convection coefficients, can de dynamic
h_ap = 15;  % Convection between air and plant
h_ac = 15;  % Convection between air and cover
h_af = 15;  % Convection between air and floor  
h_out = 20;  % Convection between outside air and greenhouse

ConvectionCoefficientsIn = [0; h_ac; h_ac; h_ap; h_af] ;

% ConvectionCoefficientsOut = [h_out; h_out] ;

ConvAreaArray = AreaArray ;
ConvAreaArray(5) = MassPlant * GH.p.C_pld  ; % Effect plant surface


