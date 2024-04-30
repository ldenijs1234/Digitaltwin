%% Set those states homie


GH.x.            AirTemperature(1) = 20 ;  % ALL DUMMY VALUES!!!
GH.x.            WallTemperature(1) = 20 ;
GH.x.            FloorTemperature(1) = 20 ;
GH.x.            PlantTemperature(1) = 20 ;

GH.x.            AirHumidity(1) = 0.012 ; % kg/m^3 air
GH.x.            VentilationSpeed(1) = 0 ; % DUMMY

GH.x.            CO2Air(1) = 0.0464 ; % kg/m^3 air
GH.x.            DryMassPlant = 10 * ones(1, length(t)) ; % Dry Mass plant (CO2)
GH.x.            MassPlant = GH.x.DryMassPlant / 0.05 ; % Assume plant = ~95% water, (5% Dry Mass)
   