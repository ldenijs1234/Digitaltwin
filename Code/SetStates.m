% States in array per time step form


T = zeros(length(set_T), length(t)) ;
T(:,1) = set_T;

FloorTemperature = zeros(length(set_FloorTemperature), length(t)) ;
FloorTemperature(:,1) = set_FloorTemperature ;



%Define size
Q_tot = zeros(length(T(:,1)), length(t)-1);
Q_vent= zeros(length(T(:,1)), length(t)-1);
Q_solar = zeros(length(T(:,1)), length(t)-1);
Q_sky = zeros(length(T(:,1)), length(t)-1);
Q_conv = zeros(length(T(:,1)), length(t)-1);
Q_ground = zeros(length(T(:,1)), length(t)-1);
Q_rad_in = zeros(length(T(:,1)), length(t)-1);
q_rad_out = zeros(length(T(:,1)), length(t)-1);
Q_heat = zeros(length(T(:,1)), length(t)-1);
Q_latent = zeros(length(T(:,1)), length(t)-1);
 

AddStates = zeros(length(set_AddStates), length(t)) ;
AddStates(:,1) = set_AddStates ;   % additional states

RelHumidity = zeros(1, length(t)) ;
RelHumidity(1) = set_RelHumidity ;

W_trans = zeros(1, length(t)) ; W_cond = zeros(1, length(t)) ; W_vent = zeros(1, length(t)) ; W_fog = zeros(1, length(t)) ;
C_trans = zeros(1, length(t)) ; C_vent = zeros(1, length(t)) ; C_resp = zeros(1, length(t)) ;





      