## Intro
This Digital Twin (DT) simulates Temperature, Humidity and CO2 of conditions in a Venlo type greenhouse. 
The plant model used is a lettuce model from Van Henten, 2003. The DT can be scaled in size by adjusting the parameters
for length, width and height of the greenhouse in 'SetParameters' line 24-26. The DT is controlled by heating input, window and fogging control. 
There is no artificial lighting or CO2 injection in the DT. Although for the latter, the option does exist to include it.

## The model
The model consists of a number of main scripts and two maps with support and controller functions.
The map 'controls' consists of controller and optimization functions used in the model. It also includes support functions for these functions, such as the energy cost during a day.
'Weather files + support functions' contains multiple weather files from different dates and in different sizes (read the explanation below how to operate thes different sizes) and multiple support functions to calculate certain variables at a timestep. Such variables include convection coefficients in- and outside the greenhouse, conversion from relative humidity to vapor density and vice versa.

'Initialize' allows to set initial values for each state in the simulation. Make sure to set the humidity, inserted in the form of vapor density to a value lower than 100% humidity.

'SetModel' creates the time-framework for the simulation. Here it is important that "total_time" matches the total time of the weather forecast used. In this file, the timestep "dt" can also be adjusted for stability and precision purposes, do not that this heavily influences the duration of the simulation.

'SetParameters' contains all the parameters used in calculation. These parameters can be adjusted, for example to change the size of the greenhouse. All parameters are saved in the structure GH for easy accesibilty in the functions.

'SetInputs' is used to extract the different elements of the weather forecasts. It can also be used to define control bounds. However, these can also be set using an optimization function from the 'controls' map.

'SetStates' is used to set the starting states for the simulation. These can either come from 'Initialize', a previous simulation or can be inserted from measurements.

'Structure' is the main calculation file. It includes all functions defining heat, humidity and CO2 flows as well as the ventilation rate and even a nifty progress bar.

'RunFullSim' runs all the files in order for a full simulation. It also includes a possibility to run multiple (short) simulations after
one another and automatically shift the weather forecast horizon.. This makes use of the 'SimCount'. By default it is not used and set to 0. 

'plots' allows to plot different processes going on in the DT.


## Run the model
A standard procedure for simulation will go as follows:

First, make sure to to add all the files from all the folders to the matlab path. By running a file from the 'controls' folder and the 'Weather files + support functions' folder . 

To run the model, first run 'Initialize' to initialize the inside conditions in the Digital Twin. 

 
Set up the date and filenames in 'SetInputs' The date is used to predict the energy price forecast for the day of the week. 
The weather file should be hourly for 24 hours or hourly for X hours. X hours should be the same as total_time in 'SetModel' line 5. 
This is because of the 'SimCount' which by default is set to 0 in 'RunFullSim'. In 'SetInputs' set the variable 'MultipleDates' to be false.

Weatherfiles are from: https://www.visualcrossing.com/

Energycostfiles are from: https://ember-climate.org/data-catalogue/european-wholesale-electricity-price-data/

Now run 'RunFullSim' to simulate the conditions over the set simulation time of (standard = 24 hours).
To change the simulation time edit 'SetModel' line 4 to the desired simulation time, this cannot be bigger than the total time.

Run 'plots' to show the different types of data displayed in graphs. These can include heat flows, humidity flows, relative humidity etc.

## Optimize setpoint line
The optimization map contains files, that aim to reduce the cost while staying whitin the bounds by optimizing the heater setpoint line. 

'InitialGuess' makes educated guesses of the optimal setpoint line

'GradientDescend' optimizes the best InitialGuess.
To run this, first run the 'IntialGuess' script and
make sure to to add all the files from all the folders to the matlab path. By running a file from the 'controls' folder and the 'Weather files + support functions' folder.

'OptimizationTester' tests the 'GradientDescend' file on multiple dates.
To run this first set the variable 'MultipleDates' in 'SetInputs' line 2 to be true. Then make sure to to add all the files from all the folders to the matlab path. By running a file from the 'controls' folder and the 'Weather files + support functions' folder.
