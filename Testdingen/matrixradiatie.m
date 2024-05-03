%%
%syms epsilon_plant epsilon_cover epsilon_floor T_air T_plant T_cover T_floor F_pc F_pf F_cp F_cf F_fp F_fc A_plant A_cover A_floor sigma alfa_plant alfa_cover alfa_floor rho_plant rho_cover rho_floor tau_cover A_plant_sun A_cover_sun A_floor_sun I_sun
epsilon_plant=0.8; epsilon_cover=0.7; epsilon_floor=0.77;
tau_cover = 0.89;
alfa_plant = 0.8; alfa_cover= 0.05; alfa_floor = 0.77;
rho_plant = 1-alfa_plant; rho_cover = 1-tau_cover-alfa_cover; rho_floor= 1-alfa_floor;

T_air =12; T_plant= 12; T_cover= 12; T_floor=12; 
F_pc=0.6; F_pf=0.4; F_cp=0.3; F_cf=0.2; F_fp=0.7; F_fc=0.3;
A_plant= 86; A_cover= 2*1100; A_floor= 300;
sigma= 5.67*10^-8;

cap = [3000*1.293*1000; 100*4020; A_cover*0.003*840*2500; 830*A_floor*0.2*1600];

A_plant_sun = 30; A_cover_sun= 300; A_floor_sun= 270;
I_sun = 1300;
emissivity = [0; epsilon_plant; epsilon_cover; epsilon_floor];
alfa = [0; alfa_plant; alfa_cover; alfa_floor];
rho = [0; rho_plant; rho_cover; rho_floor];
T(:,1) = [T_air; T_plant; T_cover; T_floor];
Area = [0; A_plant; A_cover; A_floor];
Area_sun = [1; A_plant_sun; A_cover_sun; A_floor_sun];
View = [0, 0, 0, 0;
    0, 0, F_pc, F_pf;
    0, F_cp, 0, F_cf;
    0, F_fp, F_fc, 0];
start_time = 1;
dt = 60;
simulation_time = 100 * 60^2; 
t = start_time:dt:simulation_time;
%%
for i = 1 : length(t) - 1
    q_rad_out(:,i) = sigma * emissivity .* ((T(:,i) + 372).^4); %calculate how much each object emits
    
    Q_rad_in(:,i) =alfa .* (Area .* View * q_rad_out(:,i)); %calculate how much each object absorbs
    Q_rad_in(1,i) = sum(rho .* Area .* View * q_rad_out(:,i) ); %Q to air is calulated by howmuch is diffused by other objects

    Q_solar(:,i) = [0; tau_cover; 1; tau_cover] .* alfa .* Area_sun * I_sun;
    Q_solar(1,i) = rho_plant * Q_solar(2,i) + rho_floor * Q_solar(4,i);

    Q(:,i) = Q_solar(:,i) + Q_rad_in(:,i) - Area .* q_rad_out(:,i); %total Q
    
    T(:,i+1) =  Q(:,i) ./ cap * dt + T(:,i); %temperature rise over dt caused by Q
end

plot(t,T)
legend('T_air','T_plant','T_cover','T_floor')