%% Set those states homie


GH.x.            AirTemperature(1) = 20 ;  % ALL DUMMY VALUES!!!
GH.x.            WallTemperature(1) = 20 ;
GH.x.            FloorTemperature(1) = 20 ;
GH.x.            PlantTemperature(1) = 20 ;

GH.x.            AirHumidity(1) = 0.012 ; % kg/m^3 air

GH.x.            CO2Air(1) = 0.0464 ; % kg/m^3 air
GH.x.            DryMassPlant = 10 * ones(1, length(t)) ; % Dry Mass plant (CO2)
GH.x.            MassPlant = GH.x.DryMassPlant / 0.05 ; % Assume plant = ~95% water, (5% Dry Mass)
   

%Floor states: FloorLayer(1, :) is top layer. FloorLayer(10, :) is layer adjacent to groundtemp, Floorlayer (11, -) is groundtemp which is an externally defined parameter.
GH.x.            FloorLayer = [GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.d.GroundTemperature(1)] ;


% GH.x.            FloorLayer = [GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), ...
%                  GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.x.AirTemperature(1), GH.d.GroundTemperature(1)] ;

