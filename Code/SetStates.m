% States in array per time step form


% AirTemperature = 14 ;  % ALL DUMMY VALUES!!!
% CoverTemperature = 15 ;
% WallTemperature = 15 ;
% PlantTemperature = 15;

% %FloorTemperature initialisation:
% FloorTempIntVar = (AirTemperature - GroundTemperature)/10;

% FloorTemperature = [AirTemperature; AirTemperature-FloorTempIntVar*1; AirTemperature-FloorTempIntVar*2; AirTemperature-FloorTempIntVar*3; AirTemperature-FloorTempIntVar*4; ...
% AirTemperature-FloorTempIntVar*5; AirTemperature-FloorTempIntVar*6; AirTemperature-FloorTempIntVar*7; AirTemperature-FloorTempIntVar*8;...
%   AirTemperature-FloorTempIntVar*9; GroundTemperature] ;

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




  % Humidity = 0.012 ; % kg/m^3 air

  % CO2Air = 0.000464 ; % kg/m^3 air
  % MassPlant = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ; % Dry Mass plant (CO2)
  % DryMassPlant = MassPlant / 20 ; % Assume plant = ~95% water, (5% Dry Mass)

AddStates = zeros(length(set_AddStates), length(t)) ;
AddStates(:,1) = set_AddStates ;   % additional states


MassPlant = AddStates(4,1) ; 
CAPArray = [GH.p.cp_air * GH.p.rho_air * GH.p.GHVolume; 
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(2);
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(3);
            GH.p.cp_floor * GH.p.rho_floor * GH.p.GHFloorArea * GH.p.GHFloorThickness;
            GH.p.cp_lettuce * MassPlant;
            GH.p.Vpipe*GH.p.rho_steel*...
        GH.p.cp_steel+pi*GH.p.pipeL*GH.p.r_0^2*GH.p.rho_water*GH.p.cp_water]; %variable if plant grows
      