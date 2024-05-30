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

W_trans = zeros(1, length(t)) ; W_cond = zeros(1, length(t)) ; W_vent = zeros(1, length(t)) ; W_fog = zeros(1, length(t)) ;
C_trans = zeros(1, length(t)) ; C_vent = zeros(1, length(t)) ; C_resp = zeros(1, length(t)) ;

% if AddStates(4,1) == 0
%   MassPlant = MassPlanInit ;
% else
%   MassPlant = AddStates(4,1) ; 
% end


% CAPArray = [GH.p.cp_air * GH.p.rho_air * GH.p.GHVolume; 
%             GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(2);
%             GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(3);
%             GH.p.cp_floor * GH.p.rho_floor * GH.p.GHFloorArea * GH.p.GHFloorThickness;
%             GH.p.cp_lettuce * MassPlant;
%             GH.p.Vpipe*GH.p.rho_steel*...
%         GH.p.cp_steel+pi*GH.p.pipeL*GH.p.r_0^2*GH.p.rho_water*GH.p.cp_water]; %variable if plant grows
      