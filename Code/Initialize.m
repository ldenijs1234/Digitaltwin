run("SetModel")
run("SetParameters")

%Initial values:
GroundTemperature = 10 ;

AirTemperature = 10 ;  % ALL DUMMY VALUES!!!
CoverTemperature = 10 ;
WallTemperature = 10 ;
PlantTemperature = 10;
PipeTemperature = 10 ;
T_WaterIn(1) = 60 ;

water_array = T_WaterIn(1) * ones(1, GH.p.dPipe) ;

%FloorTemperature initialisation:
FloorTempIntVar = (AirTemperature - GroundTemperature)/10;

init_FloorTemperature = [AirTemperature; AirTemperature-FloorTempIntVar*1; AirTemperature-FloorTempIntVar*2; AirTemperature-FloorTempIntVar*3; AirTemperature-FloorTempIntVar*4; ...
AirTemperature-FloorTempIntVar*5; AirTemperature-FloorTempIntVar*6; AirTemperature-FloorTempIntVar*7; AirTemperature-FloorTempIntVar*8;...
AirTemperature-FloorTempIntVar*9; GroundTemperature] ;

initial_T = [AirTemperature; CoverTemperature; WallTemperature; init_FloorTemperature(1,1); PlantTemperature; PipeTemperature] ;

set_FloorTemperature = init_FloorTemperature ;


Humidity = 0.012 ; % kg/m^3 air

CO2Air = 0.000464 ; % kg/m^3 air

MassPlant = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ; % Dry Mass plant (CO2), kg
DryMassPlant = MassPlant / 20 ; % Assume plant = ~95% water, (5% Dry Mass), kg

init_AddStates(:,1) = [Humidity; CO2Air; DryMassPlant; MassPlant] ;   % additional states

set_T = initial_T ;
set_AddStates = init_AddStates ;

SimCount = 0 ;