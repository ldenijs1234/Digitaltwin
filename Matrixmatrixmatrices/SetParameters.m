% Set variables (for matrices)

% Greenhouse parameters                 ALL DUMMY!!!!!!!!!!!!!
GH.p.           GHWidth = 10 ; %m 
GH.p.           GHLength = 10 ; %m
GH.p.           GHHeight = 3 ; %m
GH.p.           GHWallThickness = 3e-3 ; %m
GH.p.           GHFloorThickness = 1e-2 ;	%m

GH.p.           NumberOfWindows = 10 ; 
GH.p.           WindowLength = 0.2 ;
GH.p.           WindowHeight = 0.1 ;
GH.p.           RoofAngle = 10 ; % degrees

GH.p.           WindowArea = GH.p.WindowHeight*GH.p.WindowLength ;
GH.p.           GHVolume = GH.p.GHLength*GH.p.GHWidth*GH.p.GHHeight ;
GH.p.           GHFloorArea = GH.p.GHLength * GH.p.GHWidth ;
GH.p.           GHSideArea1 = GH.p.GHLength * GH.p.GHHeight ;
GH.p.           GHSideArea2 = GH.p.GHWidth * GH.p.GHHeight ;
GH.p.           GHTotalArea = GH.p.GHFloorArea + 2* GH.p.GHSideArea1 + 2* GH.p.GHSideArea2 ;
GH.p.           GHPlantArea = 0.3 * GH.p.GHFloorArea ; %DUMMY

% Plant parameters
GH.p.           cp_lettuce = 4020 ;
GH.p.           EmittancePlant = 0.90 ; %DUMMY
GH.p.           YieldFactor = 0.544 ; %- (effective CO2 use efficiency)
GH.p.           C_resp = 2.65e-7 ; %s^-1 (respiration rate in terms of respired dry matter)

% Humidity equations parameters
GH.p.           C_pld = 53 ; %m^2 kg^-1 (effective canopy surface)
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

AlfaGlass = 0.04 ; %DUMMY
EmittanceGlass = 0.8 ; %DUMMY
TauGlass = 0.80 ;
EmittanceFloor = 0.9 ; %DUMMY
KFloor = 0.3 ; %accurate enough for prototype
LFloorGround = 19e-2 ; % meter
EmittanceGlassSky = GH.p.EmittanceGlass ; %DUMMY






A_plant= 86; A_cover= 2*1100; A_floor= 300;

% Radiation variables
epsilon_plant=0.8; epsilon_cover=0.7; epsilon_floor=0.77;
tau_cover = 0.89;
alfa_plant = 0.8; alfa_cover= 0.05; alfa_floor = 0.77;
rho_plant = 1-alfa_plant; rho_cover = 1-tau_cover-alfa_cover; rho_floor= 1-alfa_floor;

% Viewing vectors and Areas
F_pc=0.6; F_pf=0.4; F_cp=0.3; F_cf=0.2; F_fp=0.7; F_fc=0.3;

sigma= 5.67*10^-8;


A_plant_sun = 30; A_cover_sun= 300; A_floor_sun= 270;
I_sun = 1300;
emissivity = [0; epsilon_plant; epsilon_cover; epsilon_floor];
alfa = [0; alfa_plant; alfa_cover; alfa_floor];
rho = [0; rho_plant; rho_cover; rho_floor];
Area = [0; A_plant; A_cover; A_floor];
Area_sun = [1; A_plant_sun; A_cover_sun; A_floor_sun];

View = [0, 0, 0, 0;
    0, 0, F_pc, F_pf;
    0, F_cp, 0, F_cf;
    0, F_fp, F_fc, 0];


