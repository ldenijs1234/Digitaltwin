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

T = set_T;

FloorTemperature = set_FloorTemperature ;


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
Q_heat(1,:) = Heating ;
Q_pipes(1) = 0 ;
T_water(1) = 20 ;


  % Humidity = 0.012 ; % kg/m^3 air

  % CO2Air = 0.000464 ; % kg/m^3 air
  % MassPlant = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ; % Dry Mass plant (CO2)
  % DryMassPlant = MassPlant / 20 ; % Assume plant = ~95% water, (5% Dry Mass)

AddStates = set_AddStates ;   % additional states


MassPlant = AddStates(4,1) ; 
CAPArray = [GH.p.cp_air * GH.p.rho_air * GH.p.GHVolume; 
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(2);
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(3);
            GH.p.cp_floor * GH.p.rho_floor * GH.p.GHFloorArea * GH.p.GHFloorThickness;
            GH.p.cp_lettuce * MassPlant;
            0.25*pi*GH.p.pipeL*((GH.p.r_1^2-GH.p.r_0^2)*GH.p.rho_steel*...
        GH.p.cp_steel+GH.p.r_1^2*GH.p.rho_water*GH.p.cp_water)]; %variable if plant grows