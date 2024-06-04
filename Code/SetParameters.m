% Defining parameters saved in structure 'GH' under field 'p', creating arrays with coefficients for later calculation

% General parameters
GH.p.           cp_air = 1003.5 ; % (J kg^-1 K^-1)
GH.p.           cp_glass = 840 ; % (J kg^-1 K^-1)
GH.p.           cp_water = 4186 ;% (J kg^-1 K^-1)
GH.p.           cp_floor = 880 ; % (J kg^-1 K^-1)
GH.p.           cp_steel = 640 ; % (J kg^-1 K^-1)	
GH.p.           rho_air = 1.2 ; % (kg m^-3)
GH.p.           rho_glass = 2500 ; % (kg m^-3)
GH.p.           rho_floor = 2400 ; % (kg m^-3)
GH.p.           rho_steel = 7850 ; % (kg m^-3)
GH.p.           rho_water = 1000 ; % (kg m^-3)
GH.p.           GasConstantR = 8.314 ; % (J/mol K)
GH.p.           StefBolzConst = 5.670374419e-8 ; % (W/m^2 K^4 )
                sigma = 5.670374419e-8 ;
GH.p.           Gravity = 9.81 ; % (m/s^2)
GH.p.           Kelvin = 273.15 ;


% Greenhouse parameters,               
GH.p.           LAI = 0.5 ; % Leaf Area Index

GH.p.           GHWidth = 30 ; % (m) 
GH.p.           GHLength = 30 ; % (m)
GH.p.           GHHeight = 5 ;  % (m)
GH.p.           GHWallThickness = 3e-3 ; % (m)
GH.p.           GHFloorThickness = 1e-2 ;	% (m), thickness of a single floor layer
GH.p.           GHFloorArea = GH.p.GHLength * GH.p.GHWidth ;

GH.p.           NumberOfWindows = round(GH.p.GHFloorArea*0.05) ; % Scaled to size of greenhouse
GH.p.           WindowLength = 1.5 ; %(m)
GH.p.           WindowHeight = 0.8 ; %(m)
GH.p.           RoofAngle = 26 ; % (°), same as Venlo type greenhouse

GH.p.           WindowArea = GH.p.WindowHeight*GH.p.WindowLength ;
GH.p.           GHVolume = GH.p.GHLength*GH.p.GHWidth*GH.p.GHHeight ;
GH.p.           GHFloorArea = GH.p.GHLength * GH.p.GHWidth ;
GH.p.           GHSideArea1 = GH.p.GHLength * GH.p.GHHeight ;
GH.p.           GHSideArea2 = GH.p.GHWidth * GH.p.GHHeight ;
GH.p.           GHTotalArea = GH.p.GHFloorArea + 2* GH.p.GHSideArea1 + 2* GH.p.GHSideArea2 ;
GH.p.           GHPlantArea = GH.p.LAI * GH.p.GHFloorArea ; 
GH.p.           GHWallArea = GH.p.GHLength * GH.p.GHHeight * 2 + GH.p.GHWidth * GH.p.GHHeight * 2 ;
GH.p.           GHCoverArea =  GH.p.GHLength * GH.p.GHWidth ;
GH.p.           phi_fog = 1e-4 * GH.p.GHFloorArea ; % (kg s^-1), scaled to size
GH.p.           FogPower = 1.25e5 * GH.p.phi_fog ; % (W), estimated max power use of fogger

% Plant parameters
GH.p.           cp_lettuce = 4020 ; %(J kg^-1 K^-1)
GH.p.           rho_lettuce = 240.92 ; % (kg m^-3)
GH.p.           EmittancePlant = 0.90 ; % (-)
GH.p.           SOLARAbsorbancePlant = 0.65 ; % (-)
GH.p.           FIRAbsorbancePlant = 0.78 ; % (-)
GH.p.           SOLARDiffusePlant = 1 - GH.p.SOLARAbsorbancePlant; % (-)
GH.p.           FIRDiffusePlant = 1 - GH.p.FIRAbsorbancePlant ; % (-)
GH.p.           YieldFactor = 0.544 ; % (-) (effective CO2 use efficiency) [Van Henten, 2003]
GH.p.           C_resp = 2.65e-7 ; % (s^-1) (respiration rate in terms of respired dry matter) [Van Henten, 2003]

% Glass parameters
GH.p.           SOLARAbsorbanceGlass = 0.04 ; % (-) [Vanthoor, 2011]
GH.p.           FIRAbsorbanceGlass = 0.85; % (-) [Vanthoor, 2011]
GH.p.           EmittanceGlass = 0.85 ; % (-) [Vanthoor, 2011]
GH.p.           SOLARTauGlass = 0.85 ; % (-) [Vanthoor, 2011]
GH.p.           SOLARDiffuseGlass = 1 - GH.p.SOLARAbsorbanceGlass - GH.p.SOLARTauGlass; % (-)
GH.p.           FIRDiffuseGlass = 1 - GH.p.FIRAbsorbanceGlass; % (-)

% Floor parameters
GH.p.           SOLARAbsorbanceFloor = 0.65; % (-)
GH.p.           FIRAbsorbanceFloor = 0.9; % (-)
GH.p.           EmittanceFloor = 0.8 ; % (-)
GH.p.           SOLARDiffuseFloor = 1 - GH.p.SOLARAbsorbanceFloor; % (-)
GH.p.           FIRDiffuseFloor = 1 - GH.p.FIRAbsorbanceFloor ; % (-)
GH.p.           KFloor = 0.3 ; %accurate enough for prototype
GH.p.           LFloorGround = 19e-2 ; % (m)

% Heatingpipe parameters
GH.p.           EmittancePipe = 0.88; % (-) [Vanthoor, 2011]
GH.p.           SOLARAbsorbancePipe = 0.95; % (-)
GH.p.           FIRAbsorbancePipe = 0.95; % (-)
GH.p.           SOLARDiffusePipe = 1 - GH.p.SOLARAbsorbancePipe ; % (-)
GH.p.           FIRDiffusePipe = 1 - GH.p.FIRAbsorbancePipe ; % (-)
GH.p.           r_0 = 0.015; % (m), inside radius of the pipe 
GH.p.           r_1 = 0.017; % (m), outside radius of the pipe
GH.p.           r_2 = 0.10; % (m), outside radius of the fin  
GH.p.           pipeLength = 1*GH.p.GHFloorArea ; % (m), length of the pipe 
GH.p.           Vel_water = 1; % (m/s), speed of the water through the pipe
GH.p.           dL = dt*GH.p.Vel_water; % (m), distance travelled in one time-step 
GH.p.           dPipe = 20; % (-), number of pipe pieces for numerical calculation
GH.p.           Npipes = ceil(GH.p.pipeLength/(GH.p.dL*GH.p.dPipe)); % (-), number of pipes
GH.p.           pipeL = GH.p.Npipes*GH.p.dPipe*GH.p.dL;
GH.p.           pipeF = 80; % Fins per meter of pipe, keep the thickness in mind, not more fins then fit on the pipe
GH.p.           pipet = 0.001; % (m), half of the thickness of one fin 
GH.p.           PipeArea = GH.p.pipeL*2*pi*GH.p.r_2 ;
GH.p.           Bpipe = sqrt(GH.p.r_1^2+GH.p.pipet^2);
GH.p.           Dpipe = sqrt((GH.p.r_2^2 /GH.p.r_1)^2 + GH.p.pipet^2);
GH.p.           Afin =  2*pi*GH.p.r_1*(GH.p.Dpipe-GH.p.Bpipe+(GH.p.pipet/2)*log(((GH.p.Dpipe-GH.p.pipet)*...
                (GH.p.Bpipe+GH.p.pipet))/((GH.p.Dpipe+GH.p.pipet)*(GH.p.Bpipe-GH.p.pipet)))); % (m^2), surface area of a fin
GH.p.           Vfin = 4*pi*GH.p.pipet*GH.p.r_1*(GH.p.r_2-GH.p.r_1); % (m^3), volume of a fin
GH.p.           Vpipe = GH.p.Vfin*GH.p.pipeL*GH.p.pipeF+(GH.p.r_1^2-GH.p.r_0^2)*pi*GH.p.pipeL; % (m^3), volume of the material of the pipe
GH.p.           Apipe = GH.p.pipeL*GH.p.pipeF*GH.p.Afin+(GH.p.pipeL-GH.p.pipeL*GH.p.pipeF*2*GH.p.pipet)*2*pi*GH.p.r_1; % (m^2), total area of the pipe
GH.p.           m_flow = GH.p.rho_water*GH.p.Vel_water*pi*GH.p.r_0^2; % (kg/s),  mass flow through pipe
GH.p.           APipeIn = pi*GH.p.r_0^2; % (m^2), area inside crossection pipe

% Humidity equations parameters
GH.p.           C_pld = 1/3* GH.p.rho_lettuce* 0.1 ; % (m^2 kg^-1), effective canopy surface of lettuce, modelled as a sphere
GH.p.           C_vplai = 3.6e-3 ; % (m s^-1), canopy transpiration mass transfer coefficient [Van Henten, 2003]
GH.p.           C_v1 = 9348 ; % (J m^-3), parameter defining saturation water vapor pressure [Van Henten, 2003]
GH.p.           C_v2 = 17.4 ; % (K), parameter defining saturation water vapor pressure [Van Henten, 2003]
GH.p.           C_v3 = 239 ; % (K), parameter defining saturation water vapor pressure [Van Henten, 2003]

% CO2 equations parameters
GH.p.           C_RadPhoto = 3.55e-9 ; % (kg J^-1), light use efficiency [Van Henten, 2003]
GH.p.           C_R = 5.2e-5 ; % (kg m^-3), CO2 compensation point [Van Henten, 2003]
GH.p.           C_CO21 = 5.11e-6 ; % (m s^-1 K^-1), temperature effect on CO2 diffiusion in leaves [Van Henten, 2003]
GH.p.           C_CO22 = 2.3e-4 ; % (m s^-1 K^-1), temperature effect on CO2 diffiusion in leaves [Van Henten, 2003]
GH.p.           C_CO23 = 6.29e-4 ; % (m s^-1 K^-1), temperature effect on CO2 diffiusion in leaves [Van Henten, 2003]
GH.p.           C_respC = 4.87e-7 ; % (s^-1), respiration rate in terms of produced carbon dioxide [Van Henten, 2003]

% Ventilation parameters
GH.p.           C_f = 0.6 ; % (-), discharge of energy by friction [De Zwart, 1996]
GH.p.           BetaAir = 1/283 ; % (1/K), thermal expansion coefficient [De Zwart, 1996]


% Temperature equations parameters:   

% Convection coefficients, values are somewhat arbitrary
h_ac = 5;  % (W m^-2 K^-1), convection between air and cover
h_af = 5;  % (W m^-2 K^-1), convection between air and floor  
h_ap = 5;  % (W m^-2 K^-1), convection between air and plant [Katzin, 2021]
h_ah = 5;  % (W m^-2 K^-1), convection between air and heatpipe
ConvectionCoefficientsIn = [0; h_ac; h_ac; h_af; h_ap; h_ah] ; % Placeholder  values (except h_ap), will be substituted by function 'inside_convection'

% Heat transfer and area arrays for later calculations
EmmitanceArray = [0; GH.p.EmittanceGlass; GH.p.EmittanceGlass; GH.p.EmittanceFloor; GH.p.EmittancePlant; GH.p.EmittancePipe];
SOLARAbsorbanceArray = [0; GH.p.SOLARAbsorbanceGlass; GH.p.SOLARAbsorbanceGlass; GH.p.SOLARAbsorbanceFloor; GH.p.SOLARAbsorbancePlant; GH.p.SOLARAbsorbancePipe];
FIRAbsorbanceArray = [0; GH.p.FIRAbsorbanceGlass; GH.p.FIRAbsorbanceGlass; GH.p.FIRAbsorbanceFloor; GH.p.FIRAbsorbancePlant; GH.p.FIRAbsorbancePipe];
SOLARDiffuseArray = [0; GH.p.SOLARDiffuseGlass; GH.p.SOLARDiffuseGlass; GH.p.SOLARDiffuseFloor; GH.p.SOLARDiffusePlant; GH.p.SOLARDiffusePipe];
FIRDiffuseArray = [0; GH.p.FIRDiffuseGlass; GH.p.FIRDiffuseGlass; GH.p.FIRDiffuseFloor; GH.p.FIRDiffusePlant; GH.p.FIRDiffusePipe];
AreaArray = [0; GH.p.GHFloorArea; GH.p.GHTotalArea- GH.p.GHFloorArea; GH.p.GHFloorArea; GH.p.GHPlantArea; GH.p.PipeArea];
AreaSunArray = [0; GH.p.GHFloorArea; 0; GH.p.GHFloorArea - GH.p.GHPlantArea - 2*GH.p.r_2*GH.p.pipeL*0.1 ; GH.p.GHPlantArea; 2*GH.p.r_2*GH.p.pipeL*0.1];
AreaArrayRad = AreaArray; AreaArrayRad(5) = 2 * AreaArray(5); AreaArrayRad(6) = GH.p.pipeL*2*pi*GH.p.r_2;
TransmissionArray = [0; 1; 1; GH.p.SOLARTauGlass; GH.p.SOLARTauGlass; GH.p.SOLARTauGlass]; % 0 for air, 1 for glass wall and roof, tau for everything underneath glass

ConvAreaArray = AreaArray ;
MassPlant = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ;
ConvAreaArray(5) = MassPlant * GH.p.C_pld  ; % Effect plant surface
ConvAreaArray(6) = GH.p.Apipe ;

% Functions defining viewing factors for radiation

function F_12 = F_rect_perp(h, w, l)                            %inputs: h length of object 2, w length of object 1, l lenght of intersection
    H = h/l;                                                    %calculates shapefactor of two perpendicular adjecent rectangles
    W = w/l;
    F_12 = (1/(pi*W)) * (W * atan(1/W) + H * atan(1/H) - sqrt(H^2 + W^2) * atan(1/sqrt(H^2 + W^2))...
        + 0.25 * log(  ((1 + W^2) * (1 + H^2)) / (1 + W^2 + H^2) * ( W^2 * (1 + W^2 + H^2)/...
        ((1 + W^2) * (W^2 + H^2)) )^(W^2) * (H^2 * (1 + W^2 + H^2) / ((1 + H^2) * (W^2 + H^2)) )^(H^2) ));
end

function F_12 = F_para_cyl(s, d)                                %inputs: s the distance between cylinders, d the diameter of the cylinders
    X = 1 + s/d;                                                %calculates shapefactor of two parallel cylinders with equal cylinders
    F_12 = 1/pi * (sqrt(X^2 -1) + asin(1/X) - X);
end

function F_mn = F_reciprocal(F_nm, AreaRad, n, m)               %inputs: F_nm shape factor object n to m, AreaRad area area of all objects, n nth object, m mth object
    F_mn = F_nm * AreaRad(n) / AreaRad(m);                      %calculates shapefactor object 2 to object 1
end

% Shapefactors, cover:c, walls: w, floor: f, plant: p, heatingpipe: h
F_hc = 1/12; 
F_hh = 2 * F_para_cyl((GH.p.GHFloorArea/GH.p.pipeL), GH.p.r_2); 
F_hf = 0.6 - F_hh; 
F_hw = 0; 
F_hp = 1 - F_hc - F_hf - F_hw - F_hh;

F_ch = F_reciprocal(F_hc, AreaArrayRad, 6, 2); 
F_cc =0; 
F_cw = 2 * F_rect_perp(GH.p.GHHeight, GH.p.GHWidth, GH.p.GHLength) + 2 * F_rect_perp(GH.p.GHHeight, GH.p.GHLength, GH.p.GHWidth); 
F_cf = (1-GH.p.LAI) * (1 - F_cw) - F_ch; 
F_cp = GH.p.LAI * (1 - F_cw);

F_wh = F_reciprocal(F_hw, AreaArrayRad, 6, 3); 
F_wc = F_reciprocal(F_cw, AreaArrayRad, 2, 3); 
F_wf = (1-GH.p.LAI) * F_wc; 
F_wp = GH.p.LAI * F_wc; 
F_ww = 1 - F_wc - F_wf - F_wp - F_wh;

F_fh = F_reciprocal(F_hf, AreaArrayRad, 6, 4); 
F_fc = F_reciprocal(F_cf, AreaArrayRad, 2, 4); 
F_fw = F_reciprocal(F_wf, AreaArrayRad, 3, 4); 
F_ff = 0; 
F_fp = 1 - F_fw - F_fc - F_fh - F_ff;

F_ph = F_reciprocal(F_hp, AreaArrayRad, 6, 5); 
F_pc = F_reciprocal(F_cp, AreaArrayRad, 2, 5); 
F_pw = F_reciprocal(F_wp, AreaArrayRad, 3 ,5);  
F_pf = F_reciprocal(F_fp, AreaArrayRad, 4, 5); 
F_pp = 1 - F_pc - F_pw - F_pf - F_ph; 

ViewMatrix = [0,     0,      0,      0,      0,      0;   
             0,     F_cc,   F_cw,   F_cf,   F_cp,   F_ch;
             0,     F_wc,   F_ww,   F_wf,   F_wp,   F_wh;   
             0,     F_fc,   F_fw,   F_ff,   F_fp,   F_fh;
             0,     F_pc,   F_pw,   F_pf,   F_pp,   F_ph;
             0,     F_hc,   F_hw,   F_hf,   F_hp,   F_hh];

ViewMatrix = ViewMatrix.';

% Check: sum(ViewMatrix,2) = [0; ones(height(ViewMatrix) - 1, 1)] & AreaArrayRad .* ViewMatrix -...
% (AreaArrayRad .* ViewMatrix)' = zeros(size(ViewMatrix))