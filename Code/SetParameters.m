% Set variables (for matrices), parameters saved in general field 'GH' under field 'p'

% General parameters
GH.p.           cp_air = 1003.5 ; %J kg^-1 K^-1
GH.p.           cp_glass = 840 ; %J kg^-1 K^-1
GH.p.           cp_water = 4186 ;%J kg^-1 K^-1
GH.p.           cp_floor = 880 ; %J kg^-1 K^-1
GH.p.           cp_steel = 640 ; %J kg^-1 K^-1	
GH.p.           rho_air = 1.2 ; %kg m^-3
GH.p.           rho_glass = 2500 ; %kg m^-3
GH.p.           rho_floor = 2400 ; %kg m^-3
GH.p.           rho_steel = 7850 ; %kg m^-3
GH.p.           rho_water = 1000 ; %kg m^-3
GH.p.           GasConstantR = 8.314 ; % J/mol K
GH.p.           StefBolzConst = 5.670374419e-8 ; % W/m^2 K^4 
                sigma = 5.670374419e-8 ;
GH.p.           Gravity = 9.81 ; % m/s^2 ;
GH.p.           Kelvin = 273.15 ;


% Greenhouse parameters                 ALL DUMMY!!!!!!!!!!!!!
GH.p.           LAI = 0.5 ; % Leaf Area Index

GH.p.           GHWidth = 10 ; %m 
GH.p.           GHLength = 10 ; %m
GH.p.           GHHeight = 3 ; %m
GH.p.           GHWallThickness = 3e-3 ; %m
GH.p.           GHFloorThickness = 1e-2 ;	%m

GH.p.           NumberOfWindows = 15 ; 
GH.p.           WindowLength = 0.8 ;
GH.p.           WindowHeight = 0.4 ;
GH.p.           RoofAngle = 10 ; % degrees

GH.p.           WindowArea = GH.p.WindowHeight*GH.p.WindowLength ;
GH.p.           GHVolume = GH.p.GHLength*GH.p.GHWidth*GH.p.GHHeight ;
GH.p.           GHFloorArea = GH.p.GHLength * GH.p.GHWidth ;
GH.p.           GHSideArea1 = GH.p.GHLength * GH.p.GHHeight ;
GH.p.           GHSideArea2 = GH.p.GHWidth * GH.p.GHHeight ;
GH.p.           GHTotalArea = GH.p.GHFloorArea + 2* GH.p.GHSideArea1 + 2* GH.p.GHSideArea2 ;
GH.p.           GHPlantArea = GH.p.LAI * GH.p.GHFloorArea ; %DUMMY
GH.p.           GHWallArea = GH.p.GHLength * GH.p.GHHeight * 2 + GH.p.GHWidth * GH.p.GHHeight * 2 ;
GH.p.           GHCoverArea =  GH.p.GHLength * GH.p.GHWidth ;
GH.p.           Boilervolume = 100 ; % 

% Plant parameters
GH.p.           cp_lettuce = 4020 ;
GH.p.           rho_lettuce = 240.92 ; %Test with 1000, Should it not be similiar to water?????????? !!!!!!!!!!!
GH.p.           EmittancePlant = 0.90 ; %DUMMY
GH.p.           SOLARAbsorbancePlant = 0.65 ; %DUMMY
GH.p.           FIRAbsorbancePlant = 0.78 ; %DUMMY
GH.p.           SOLARDiffusePlant = 1 - GH.p.SOLARAbsorbancePlant;
GH.p.           FIRDiffusePlant = 1 - GH.p.FIRAbsorbancePlant ;
GH.p.           YieldFactor = 0.544 ; %- (effective CO2 use efficiency)
GH.p.           C_resp = 2.65e-7 ; %s^-1 (respiration rate in terms of respired dry matter)

% Glass parameters
GH.p.           SOLARAbsorbanceGlass = 0.04 ; %DUMMY
GH.p.           FIRAbsorbanceGlass = 0.85; %DUMMY
GH.p.           EmittanceGlass = 0.8 ; %DUMMY
GH.p.           SOLARTauGlass = 0.80 ; %DUMMY
SOLARTauGlass = 0.80; %DUMMY
GH.p.           SOLARDiffuseGlass = 1 - GH.p.SOLARAbsorbanceGlass - GH.p.SOLARTauGlass;
GH.p.           FIRDiffuseGlass = 1 - GH.p.FIRAbsorbanceGlass;

% Floor parameters
GH.p.           SOLARAbsorbanceFloor = 0.65; %DUMMY
GH.p.           FIRAbsorbanceFloor = 0.8; %DUMMY
GH.p.           EmittanceFloor = 0.8 ; %DUMMY
GH.p.           SOLARDiffuseFloor = 1 - GH.p.SOLARAbsorbanceFloor;
GH.p.           FIRDiffuseFloor = 1 - GH.p.FIRAbsorbanceFloor ;
GH.p.           KFloor = 0.3 ; %accurate enough for prototype
GH.p.           LFloorGround = 19e-2 ; % meter

% Heatingpipe parameters
GH.p.           EmittancePipe = 0.88; 
GH.p.           SOLARAbsorbancePipe = 0.95;
GH.p.           FIRAbsorbancePipe = 0.95;
GH.p.           SOLARDiffusePipe = 1 - GH.p.SOLARAbsorbancePipe ;
GH.p.           FIRDiffusePipe = 1 - GH.p.FIRAbsorbancePipe ;
GH.p.           r_0 = 0.078; % inside radius of the pipe in meters
GH.p.           r_1 = 0.08; % outside radius of the pipe in meters  
GH.p.           r_2 = 0.137; % outside radius of the fin in meters  
GH.p.           pipeL = 50 ; % length of the pipe in meters
GH.p.           pipeF = 80; % Fins per meter of pipe %!!!!keep the thickness in mind not more fins then fit on the pipe!!!!
GH.p.           pipet = 0.001; % half of the thickness of one fin in meters 
GH.p.           PipeArea = GH.p.pipeL*2*pi*GH.p.r_2 ;
GH.p.           Bpipe = sqrt(GH.p.r_1^2+GH.p.pipet^2);
GH.p.           Dpipe = sqrt((GH.p.r_2^2 /GH.p.r_1)^2 + GH.p.pipet^2);
GH.p.           Afin =  2*pi*GH.p.r_1*(GH.p.Dpipe-GH.p.Bpipe+(GH.p.pipet/2)*log(((GH.p.Dpipe-GH.p.pipet)*(GH.p.Bpipe+GH.p.pipet))/((GH.p.Dpipe+GH.p.pipet)*(GH.p.Bpipe-GH.p.pipet)))); % surface area of a fin in m^2
GH.p.           Vfin = 4*pi*GH.p.pipet*GH.p.r_1*(GH.p.r_2-GH.p.r_1); %volume of a fin in m^3
GH.p.           Vpipe = GH.p.Vfin*GH.p.pipeL*GH.p.pipeF+(GH.p.r_1^2-GH.p.r_0^2)*pi*GH.p.pipeL; %Volume of the material of the pipe
GH.p.           Apipe = GH.p.pipeL*GH.p.pipeF*GH.p.Afin+(GH.p.pipeL-GH.p.pipeL*GH.p.pipeF*2*GH.p.pipet)*2*pi*GH.p.r_1; % total area of the pipe in m^2

% Humidity equations parameters
GH.p.           C_pld = 1/3* GH.p.rho_lettuce* 0.1 ;%53 ; %m^2 kg^-1 (effective canopy surface)
GH.p.           C_vplai = 3.6e-3 ; %m s^-1 (canopy transpiration mass transfer coefficient)
GH.p.           C_v1 = 9348 ; %J m^-3 (parameter defining saturation water vapor pressure)
GH.p.           C_v2 = 17.4 ; %K (parameter defining saturation water vapor pressure)    
GH.p.           C_v3 = 239 ; %K (parameter defining saturation water vapor pressure)  

% CO2 equations parameters
GH.p.           C_RadPhoto = 3.55e10-9 ; %kg J^-1 (light use efficiency)
GH.p.           C_R = 5.2e-5 ; %kg m^-3 (CO2 compensation point)
GH.p.           C_CO21 = 5.11e-6 ; %m s^-1 K^-1 (temperature effect on CO2 diffiusion in leaves)
GH.p.           C_CO22 = 2.3e-4 ; %m s^-1 K^-1 (temperature effect on CO2 diffiusion in leaves)
GH.p.           C_CO23 = 6.29e-4 ; %m s^-1 K^-1 (temperature effect on CO2 diffiusion in leaves)

% Ventilation parameters
GH.p.           C_f = 0.6 ; % Discharge of energy by friction
GH.p.           BetaAir = 1/283 ; % Thermal expansion coefficient

% Temperature equations parameters   

% Convection coefficients, can de dynamic
h_out = 20;  % Convection between outside air and greenhouse
h_ac = 5;  % Convection between air and cover
h_af = 5;  % Convection between air and floor  
h_ap = 5;  % Convection between air and plant
h_ah = 5;  % Convection between air and heatpipe
ConvectionCoefficientsIn = [0; h_ac; h_ac; h_af; h_ap; h_ah] ;

% ConvectionCoefficientsOut = [h_out; h_out] ;


% Radiation
EmmitanceArray = [0; GH.p.EmittanceGlass; GH.p.EmittanceGlass; GH.p.EmittanceFloor; GH.p.EmittancePlant; GH.p.EmittancePipe];
SOLARAbsorbanceArray = [0; GH.p.SOLARAbsorbanceGlass; GH.p.SOLARAbsorbanceGlass; GH.p.SOLARAbsorbanceFloor; GH.p.SOLARAbsorbancePlant; GH.p.SOLARAbsorbancePipe];
FIRAbsorbanceArray = [0; GH.p.FIRAbsorbanceGlass; GH.p.FIRAbsorbanceGlass; GH.p.FIRAbsorbanceFloor; GH.p.FIRAbsorbancePlant; GH.p.FIRAbsorbancePipe];
SOLARDiffuseArray = [0; GH.p.SOLARDiffuseGlass; GH.p.SOLARDiffuseGlass; GH.p.SOLARDiffuseFloor; GH.p.SOLARDiffusePlant; GH.p.SOLARDiffusePipe];
FIRDiffuseArray = [0; GH.p.FIRDiffuseGlass; GH.p.FIRDiffuseGlass; GH.p.FIRDiffuseFloor; GH.p.FIRDiffusePlant; GH.p.FIRDiffusePipe];
AreaArray = [0; GH.p.GHFloorArea; GH.p.GHTotalArea- GH.p.GHFloorArea; GH.p.GHFloorArea; GH.p.GHPlantArea; GH.p.PipeArea];
AreaSunArray = [0; GH.p.GHFloorArea; 0; GH.p.GHFloorArea - GH.p.GHPlantArea - 2*GH.p.r_2*GH.p.pipeL*0.1 ; GH.p.GHPlantArea; 2*GH.p.r_2*GH.p.pipeL*0.1];
AreaArrayRad = AreaArray; AreaArrayRad(5) = 2 * AreaArray(5); AreaArrayRad(6) = GH.p.pipeL*2*pi*GH.p.r_2;
TransmissionArray = [0; 1; 1; GH.p.SOLARTauGlass; GH.p.SOLARTauGlass; GH.p.SOLARTauGlass]; %0 for air, 1 for glass wall and roof, tau for everything underneath glass

ConvAreaArray = AreaArray ;
MassPlant = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ;
ConvAreaArray(5) = MassPlant * GH.p.C_pld  ; % Effect plant surface
ConvAreaArray(6) = GH.p.Apipe ;


function F_12 = F_rect_perp(h, w, l)   %input :length of object 2, w length of object 1, l lenght of intersection
    H = h/l;                                    %calculates shapefector of two perpendicular rectangles
    W = w/l;
    F_12 = (1/(pi*W)) * (W * atan(1/W) + H * atan(1/H) - sqrt(H^2 + W^2) * atan(1/sqrt(H^2 + W^2))...
        + 0.25 * log(  ((1 + W^2) * (1 + H^2)) / (1 + W^2 + H^2) * ( W^2 * (1 + W^2 + H^2)/ ((1 + W^2) * (W^2 + H^2)) )^(W^2) * (H^2 * (1 + W^2 + H^2) / ((1 + H^2) * (W^2 + H^2)) )^(H^2) ));
end


F_hc = 1/12; F_hh = 0.15; F_hf = 0.6 - F_hh; F_hw = 0; F_hp = 1 - F_hc - F_hf - F_hw - F_hh;

F_ch = F_hc * AreaArrayRad(6) / AreaArrayRad(2); F_cc =0; F_cw = 2 * F_rect_perp(GH.p.GHHeight, GH.p.GHWidth, GH.p.GHLength) + 2 * F_rect_perp(GH.p.GHHeight, GH.p.GHLength, GH.p.GHWidth); 
F_cf = (1-GH.p.LAI) * (1 - F_cw) - F_ch; F_cp = GH.p.LAI * (1 - F_cw);

F_wh = F_hw * AreaArrayRad(6) / AreaArrayRad(3); F_ww = 0.3; F_wc = F_cw * AreaArrayRad(2) / AreaArrayRad(3); F_wf = (1-GH.p.LAI) * F_wc; F_wp = GH.p.LAI * F_wc;

F_fh = F_hf * AreaArrayRad(6) / AreaArrayRad(4); F_fc = F_cf * AreaArrayRad(2) / AreaArrayRad(4); F_fw = F_wf * AreaArrayRad(3) / AreaArrayRad(4); F_ff = 0; F_fp = 1 - F_fw - F_fc - F_fh - F_ff;

F_ph = F_hp * AreaArrayRad(6) / AreaArrayRad(5); F_pc = F_cp * AreaArrayRad(2) / AreaArrayRad(5); F_pw = F_wp * AreaArrayRad(3) / AreaArrayRad(5);  F_pf = F_fp * AreaArrayRad(4) / AreaArrayRad(5); F_pp = 1 - F_pc - F_pw - F_pf - F_ph;

ViewMatrix = [0,     0,      0,      0,      0,      0;
             0,     F_cc,   F_cw,   F_cf,   F_cp,   F_ch;
             0,     F_wc,   F_ww,   F_wf,   F_wp,   F_wh;   
             0,     F_fc,   F_fw,   F_ff,   F_fp,   F_fh;
             0,     F_pc,   F_pw,   F_pf,   F_pp,   F_ph;
             0,     F_hc,   F_hw,   F_hf,   F_hp,   F_hh];

