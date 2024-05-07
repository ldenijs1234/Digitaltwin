% States in array per time step form

AirTemperature = 15 ;  % ALL DUMMY VALUES!!!
CoverTemperature = 15 ;
WallTemperature = 15 ;
PlantTemperature = 20 ;
%FloorTemperature initialisation:
FloorTempIntVar = (AirTemperature - GH.d.GroundTemperature(1))/10;
display(FloorTempIntVar)
FloorTemperature = [AirTemperature; AirTemperature-FloorTempIntVar*1; AirTemperature-FloorTempIntVar*2; AirTemperature-FloorTempIntVar*3; AirTemperature-FloorTempIntVar*4; ...
 AirTemperature-FloorTempIntVar*5; AirTemperature-FloorTempIntVar*6; AirTemperature-FloorTempIntVar*7; AirTemperature-FloorTempIntVar*8;...
  AirTemperature-FloorTempIntVar*9; GH.d.GroundTemperature(1)] ;
T(:,1) = [AirTemperature; CoverTemperature; WallTemperature; FloorTemperature(1,1); PlantTemperature] ;
display(AirTemperature);




Humidity = 0.012 ; % kg/m^3 air

CO2Air = 0.000464 ; % kg/m^3 air
DryMassPlant = 1  ; % Dry Mass plant (CO2)
MassPlant = DryMassPlant / 0.05 ; % Assume plant = ~95% water, (5% Dry Mass)

AddStates(:,1) = [Humidity; CO2Air; DryMassPlant; MassPlant] ;   % additional states