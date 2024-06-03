## Intro
This Digital Twin simulates Temperature, Humidity and CO2 of conditions in a Venlo type greenhouse. 
The plant model used is a lettuce model from Van Henten, 2003. The model can be scaled in size by adjusting the parameters
for length, width and height of the greenhouse in parameters.m. 

## Run the model
To run the model first run Initialize.m to initialize the inside conditions in the Digital Twin.

Set up the date and filenames in RunFullSim.m
The weather file should be hourly for 24 hours or hourly for x hours. X hours should be the same as total time in SetModel.m line 5. 
Weatherfiles are from: https://www.visualcrossing.com/
Energycostfiles are from: https://ember-climate.org/data-catalogue/european-wholesale-electricity-price-data/
Now run RunFullSim.m to simulate the conditions over a time of 24 hours (standard).
To change the simulation time edit SetModel.m line 4 to the disered simulation time, this cannot be bigger than the total time.




