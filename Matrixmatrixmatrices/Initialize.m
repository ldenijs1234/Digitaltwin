%Initial values:
GroundTemperature = 10 ;

AirTemperature = 14 ;  % ALL DUMMY VALUES!!!
CoverTemperature = 15 ;
WallTemperature = 15 ;
PlantTemperature = 15 ;
PipeTemperature = 15 ;

%FloorTemperature initialisation:
FloorTempIntVar = (AirTemperature - GroundTemperature)/10;

init_FloorTemperature = [AirTemperature; AirTemperature-FloorTempIntVar*1; AirTemperature-FloorTempIntVar*2; AirTemperature-FloorTempIntVar*3; AirTemperature-FloorTempIntVar*4; ...
AirTemperature-FloorTempIntVar*5; AirTemperature-FloorTempIntVar*6; AirTemperature-FloorTempIntVar*7; AirTemperature-FloorTempIntVar*8;...
AirTemperature-FloorTempIntVar*9; GroundTemperature] ;

initial_T(:,1) = [AirTemperature; CoverTemperature; WallTemperature; init_FloorTemperature(1,1); PlantTemperature; PipeTemperature] ;

set_FloorTemperature = init_FloorTemperature ;


Humidity = OutsideHumidity(1) ; % kg/m^3 air

CO2Air = 0.000464 ; % kg/m^3 air

run("SetParameters")
MassPlant = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ; % Dry Mass plant (CO2)
DryMassPlant = MassPlant / 20 ; % Assume plant = ~95% water, (5% Dry Mass)

init_AddStates(:,1) = [Humidity; CO2Air; DryMassPlant; MassPlant] ;   % additional states

set_T = initial_T ;
set_AddStates = init_AddStates ;

SimCount = 1 ;