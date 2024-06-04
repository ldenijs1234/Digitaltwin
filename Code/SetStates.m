% States in array per time step form

T = zeros(length(set_T), length(t)) ;
T(:,1) = set_T;                         % Initialize with set value from initiation, previous simulation or measurements

FloorTemperature = zeros(length(set_FloorTemperature), length(t)) ;
FloorTemperature(:,1) = set_FloorTemperature ; % Initialize with set value from initiation, previous simulation or measurements



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
AddStates(:,1) = set_AddStates ;   % Initialize with set value from initiation, previous simulation or measurements

RelHumidity = zeros(1, length(t)) ;
RelHumidity(1) = set_RelHumidity ; % Initialize with set value from initiation, previous simulation or measurements

W_trans = zeros(1, length(t)-1) ; W_cond = zeros(1, length(t)-1) ; W_vent = zeros(1, length(t)-1) ; W_fog = zeros(1, length(t)-1) ;
C_trans = zeros(1, length(t)-1) ; C_vent = zeros(1, length(t)-1) ; C_resp = zeros(1, length(t)-1) ;





      