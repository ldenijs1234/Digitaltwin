% States in array per time step form

AirTemperature = 15 ;  % ALL DUMMY VALUES!!!
CoverTemperature = 15 ;
WallTemperature = 15 ;
PlantTemperature = 20 ;
%FloorTemperature initialisation:
FloorTempIntVar = (AirTemperature - GroundTemperature)/10;

FloorTemperature = [AirTemperature; AirTemperature-FloorTempIntVar*1; AirTemperature-FloorTempIntVar*2; AirTemperature-FloorTempIntVar*3; AirTemperature-FloorTempIntVar*4; ...
 AirTemperature-FloorTempIntVar*5; AirTemperature-FloorTempIntVar*6; AirTemperature-FloorTempIntVar*7; AirTemperature-FloorTempIntVar*8;...
  AirTemperature-FloorTempIntVar*9; GroundTemperature] ;
T(:,1) = [AirTemperature; CoverTemperature; WallTemperature; FloorTemperature(1,1); PlantTemperature] ;





Humidity = 0.012 ; % kg/m^3 air

CO2Air = 0.000464 ; % kg/m^3 air
MassPlant = GH.p.GHPlantArea*0.01*241 ; % Dry Mass plant (CO2)
DryMassPlant = MassPlant / 20 ; % Assume plant = ~95% water, (5% Dry Mass)

AddStates(:,1) = [Humidity; CO2Air; DryMassPlant; MassPlant] ;   % additional states

CAPArray = [GH.p.cp_air * GH.p.rho_air * GH.p.GHVolume; 
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(2);
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(3);
            GH.p.cp_floor * GH.p.rho_floor * GH.p.GHFloorArea * GH.p.GHFloorThickness;
            GH.p.cp_lettuce * MassPlant]; %variable if plant grows