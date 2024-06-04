%clear ; 
run("SetModel")
run("SetParameters")

%Initial values:
GroundTemperature = 10 ; %in celcius

AirTemperature = 15 ;  % ALL DUMMY VALUES!!!
CoverTemperature = 15 ;
WallTemperature = 15 ;
PlantTemperature = 15;
PipeTemperature = 15 ;
T_WaterIn(1) = 60 ;

Humidity = 0.009 ; % kg/m^3 air
CO2Air = 0.000464 ; % kg/m^3 air

water_array = T_WaterIn(1) * ones(1, GH.p.dPipe) ;

%FloorTemperature initialisation:
FloorTempIntVar = (AirTemperature - GroundTemperature)/10;

init_FloorTemperature = [AirTemperature; AirTemperature-FloorTempIntVar*1; AirTemperature-FloorTempIntVar*2; AirTemperature-FloorTempIntVar*3; AirTemperature-FloorTempIntVar*4; ...
AirTemperature-FloorTempIntVar*5; AirTemperature-FloorTempIntVar*6; AirTemperature-FloorTempIntVar*7; AirTemperature-FloorTempIntVar*8;...
AirTemperature-FloorTempIntVar*9; GroundTemperature] ;

initial_T = [AirTemperature; CoverTemperature; WallTemperature; init_FloorTemperature(1,1); PlantTemperature; PipeTemperature] ;

set_FloorTemperature = init_FloorTemperature ;

MassPlantInit = GH.p.GHPlantArea*GH.p.rho_lettuce*0.01 ; % Dry Mass plant (CO2), kg
DryMassPlantInit = MassPlantInit / 20 ; % Assume plant = ~95% water, (5% Dry Mass), kg

init_AddStates(:,1) = [Humidity; CO2Air; DryMassPlantInit; MassPlantInit] ;   % additional states

set_T = initial_T ;
set_AddStates = init_AddStates ;

CAPArray = [GH.p.cp_air * GH.p.rho_air * GH.p.GHVolume; 
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(2);
            GH.p.cp_glass * GH.p.rho_glass * GH.p.GHWallThickness * AreaArray(3);
            GH.p.cp_floor * GH.p.rho_floor * GH.p.GHFloorArea * GH.p.GHFloorThickness;
            GH.p.cp_lettuce * MassPlantInit;
            GH.p.Vpipe*GH.p.rho_steel*...
        GH.p.cp_steel]; % Dynamic 


set_RelHumidity = VaporDens2rh(AirTemperature, Humidity) ;

SimCount = 0 ;
BoundBreak = false;