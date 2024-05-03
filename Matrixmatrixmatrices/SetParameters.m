% Set variables for matrices

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


