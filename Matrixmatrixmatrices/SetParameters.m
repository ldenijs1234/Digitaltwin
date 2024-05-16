% Bro gun parameters
% General parameters
GH.p.           cp_air = 1003.5 ; %J kg^-1 K^-1
GH.p.           cp_glass = 840 ; %J kg^-1 K^-1
GH.p.           cp_water = 4186 ;%J kg^-1 K^-1
GH.p.           cp_floor = 10000 ; %DUMMY
GH.p.           rho_air = 1.2 ; %kg m^-3
GH.p.           rho_glass = 2500 ; %kg m^-3
GH.p.           rho_floor = 2000 ; %DUMMY
GH.p.           GasConstantR = 8.314 ; % J/mol K
GH.p.           StefBolzConst = 5.670374419e-8 ; % W/m^2 K^4 
sigma = 5.670374419e-8 ;
GH.p.           Gravity = 9.81 ; % m/s^2 ;
GH.p.           Kelvin = 273.15 ;

% Set variables (for matrices), parameters saved in general field 'GH' under field 'p'

% Greenhouse parameters                 ALL DUMMY!!!!!!!!!!!!!
GH.p.           LAI = 0.9 ; % Leaf Area Index

GH.p.           GHWidth = 10 ; %m 
GH.p.           GHLength = 10 ; %m
GH.p.           GHHeight = 3 ; %m
GH.p.           GHWallThickness = 3e-3 ; %m
GH.p.           GHFloorThickness = 1e-2 ;	%m

GH.p.           NumberOfWindows = 15 ; 
GH.p.           WindowLength = 0.2 ;
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

% Plant parameters
GH.p.           cp_lettuce = 4020 ;
GH.p.           rho_lettuce = 240.92 ; 
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

GH.p.           EmittancePipe = 0.88; %DUMMY


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

% Temperature equations parameters       (Berg check ff hoe je dit allemaal wilt integreren in de rest van de code mbt overzichtelijkheid)




EmmitanceArray = [0; GH.p.EmittanceGlass; GH.p.EmittanceGlass; GH.p.EmittanceFloor; GH.p.EmittancePlant];
SOLARAbsorbanceArray = [0; GH.p.SOLARAbsorbanceGlass; GH.p.SOLARAbsorbanceGlass; GH.p.SOLARAbsorbanceFloor; GH.p.SOLARAbsorbancePlant];
FIRAbsorbanceArray = [0; GH.p.FIRAbsorbanceGlass; GH.p.FIRAbsorbanceGlass; GH.p.FIRAbsorbanceFloor; GH.p.FIRAbsorbancePlant];
SOLARDiffuseArray = [0; GH.p.SOLARDiffuseGlass; GH.p.SOLARDiffuseGlass; GH.p.SOLARDiffuseFloor; GH.p.SOLARDiffusePlant];
FIRDiffuseArray = [0; GH.p.FIRDiffuseGlass; GH.p.FIRDiffuseGlass; GH.p.FIRDiffuseFloor; GH.p.FIRDiffusePlant];
AreaArray = [0; GH.p.GHFloorArea; GH.p.GHTotalArea- GH.p.GHFloorArea; GH.p.GHFloorArea; GH.p.GHPlantArea];
AreaSunArray = [0; GH.p.GHFloorArea; 0; ((1-GH.p.LAI)*GH.p.GHFloorArea); GH.p.GHPlantArea];
AreaArrayRad = AreaArray; AreaArrayRad(5) = 2 * AreaArray(5);
TransmissionArray = [0; 1; 1; GH.p.SOLARTauGlass; GH.p.SOLARTauGlass]; %0 for air, 1 for glass wall and roof, tau for everything underneath glass

% Viewing vectors and Areas

% F_pc=0.6; F_pf=0.1; F_wc=0.2; F_fc= 0.4; F_pw = 0.3; F_fw=0.4; F_ww = 0.4;
% F_cp = F_pc * GH.p.GHPlantArea / GH.p.GHCoverArea; 
% F_fp = F_pf * GH.p.GHPlantArea / GH.p.GHFloorArea;
% F_cf = F_fc * GH.p.GHFloorArea / GH.p.GHCoverArea;
% F_cw = F_wc * GH.p.GHWallArea / GH.p.GHCoverArea;
% F_wp = F_pw * GH.p.GHPlantArea / GH.p.GHWallArea;
% F_wf = F_fw * GH.p.GHFloorArea / GH.p.GHWallArea;

% display(F_cp; F_fp; F_cf; F_cw; F_wp; F_wf)


% F_pc=0.35; F_pf=0.4; F_wc=0.2

% syms F_cw F_cf F_cp F_ww F_wf F_wp F_fc F_fw F_fp F_pw

% F_wc = 0.1 ;

% vars = [F_cw F_cf F_cp F_ww F_wf F_wp F_fc F_fw F_fp F_pw];
% eqns = [F_cw + F_cf + F_cp == 1, F_wc + F_ww + F_wf + F_wp == 1, F_fc + F_fw + F_fp == 1, F_pc + F_pw + F_pf == 1, ...
%     F_cp == F_pc * GH.p.GHPlantArea / GH.p.GHCoverArea, F_fp == F_pf * GH.p.GHPlantArea / GH.p.GHFloorArea, ...
%     F_cf == F_fc * GH.p.GHFloorArea / GH.p.GHCoverArea, F_cw == F_wc * GH.p.GHWallArea / GH.p.GHCoverArea, ...
%     F_wp == F_pw * GH.p.GHPlantArea / GH.p.GHWallArea, F_wf == F_fw * GH.p.GHFloorArea / GH.p.GHWallArea];

% size(vars)
% size(eqns)

% [F_cw, F_cf, F_cp, F_ww, F_wf, F_wp, F_fc, F_fw, F_fp, F_pw] = solve(eqns, vars)

F_ww = 0.3; F_wc=0.35; F_wp = GH.p.LAI * F_wc; F_wf = (1-GH.p.LAI) * F_wc;

F_cw = 0.42; F_cp = GH.p.LAI * 0.58; F_cf = (1-GH.p.LAI) * 0.58;

F_fw = (1-GH.p.LAI) * 0.42; F_fc = (1-GH.p.LAI) * 0.58; F_fp = 1 - F_fw - F_fc;

F_pw = F_wp * AreaArrayRad(3) / AreaArrayRad(5); F_pc = F_cp * AreaArrayRad(2) / AreaArrayRad(5); F_pf = F_fp * AreaArrayRad(4) / AreaArrayRad(5);


ViewMatrix = [0,     0,      0,      0,      0;
             0,     0,      F_cw,   F_cf,   F_cp;
             0,     F_wc,   F_ww,   F_wf,   F_wp;
             0,     F_fc,   F_fw,   0,      F_fp;
             0,     F_pc,   F_pw,   F_pf,      0];

