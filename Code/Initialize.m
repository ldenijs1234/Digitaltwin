clear ; 
run("SetModel")
run("SetParameters")

%Initial values:
GroundTemperature = 10 ; %in celcius

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


Humidity = 0.009 ; % kg/m^3 air

CO2Air = 0.000464 ; % kg/m^3 air

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
        GH.p.cp_steel]; %dynamic

        % pi*GH.p.pipeL*GH.p.r_0^2*GH.p.rho_water*GH.p.cp_water


set_RelHumidity = VaporDens2rh(AirTemperature, Humidity) ;

SimCount = 0 ;