% States in array per time step form

AirTemperature = 15 ;  % ALL DUMMY VALUES!!!
CoverTemperature = 10 ;
FloorTemperature = [AirTemperature; AirTemperature; AirTemperature; AirTemperature; AirTemperature; AirTemperature;...
 AirTemperature; AirTemperature; AirTemperature; AirTemperature; GH.d.GroundTemperature] ;
PlantTemperature = 25 ;

Temperatures(:,1) = [AirTemperature; CoverTemperature; PlantTemperature; FloorTemperature] ;




Humidity = 0.012 ; % kg/m^3 air

CO2Air = 0.000464 ; % kg/m^3 air
DryMassPlant = 1  ; % Dry Mass plant (CO2)
MassPlant = DryMassPlant / 0.05 ; % Assume plant = ~95% water, (5% Dry Mass)

AddStates(:,1) = [Humidity; CO2Air; DryMassPlant; MassPlant] ;   % additional states