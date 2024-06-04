## Intro
This Digital Twin (DT) simulates Temperature, Humidity and CO2 of conditions in a Venlo type greenhouse. 
The plant model used is a lettuce model from Van Henten, 2003. The DT can be scaled in size by adjusting the parameters
for length, width and height of the greenhouse in parameters.m line 24-26. The DT is controlled by heating input, window and fogging control. 
There is no artificial lighting or CO2 injection in the DT.

## Run the model
First run a file from the 'controls' folder and the 'Weather files + support functions' folder to add all the files in the folders to the path. 

To run the model first run Initialize.m to initialize the inside conditions in the Digital Twin.

Set up the date and filenames in RunFullSim.m. The date is used to predict the energy price forecast for the day of the week. 
The weather file should be hourly for 24 hours or hourly for x hours. X hours should be the same as total time in SetModel.m line 5. 

Weatherfiles are from: https://www.visualcrossing.com/

Energycostfiles are from: https://ember-climate.org/data-catalogue/european-wholesale-electricity-price-data/

Now run RunFullSim.m to simulate the conditions over a time of 24 hours (standard).
To change the simulation time edit SetModel.m line 4 to the disered simulation time, this cannot be bigger than the total time.

Run plots.m to show the data displayed in graphs 

