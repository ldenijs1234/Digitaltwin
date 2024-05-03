% Set variables for matrices

A_plant= 86; A_cover= 2*1100; A_floor= 300;
cap = [3000*1.293*1000; 100*4020; A_cover*0.003*840*2500; 830*A_floor*0.2*1600];

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

% Convection radiation
h_ap = 5;  % Convection between air and plant
h_ac = 2;  % Convection between air and cover
h_af = 3;  % Convection between air and floor
h_out = 10;  % Convection between outside air and greenhouse


ConvectionCoefficientsIn = [0; h_ap; h_ac; h_af] ;
h_matrix = ConvectionCoefficientsIn .* [ 0,0,0,0; 
                                        1,-1,0,0 ; 
                                        1,0,-1,0 ;
                                        1,0,0,-1] ;
ConvectionCoefficientsOut = [h_out] ;
