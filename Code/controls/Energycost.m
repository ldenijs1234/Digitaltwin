% Function to calculate the energy cost for a given week and day
function [weekcost, simdaycost] = Energycosttt(file, dt, total_time, dayNumber)
    
    tbl = readtable(file);

    EnergyCost_Euro_per_MWh = table2array(tbl(:,5));
    EnergyCost_Euro_per_kWh = EnergyCost_Euro_per_MWh ./ 1000;
    
    price_array_W6 = EnergyCost_Euro_per_kWh(end-(21*24)-1:end-(14*24)-1); % 6 weeks ago
    price_array_W5 = EnergyCost_Euro_per_kWh(end-(14*24)-1:end-(7*24)-1); % 5 weeks ago
    price_array_W4 = EnergyCost_Euro_per_kWh(end-(7*24)-1:end-1); % 4 weeks ago
    
    price_forecast = mean([price_array_W6, price_array_W5, price_array_W4], 2); % Week average of the last 3 weeks
    price_forecast = (price_forecast)';
    
    % Time vector for data points
    time_hours = 0:1:(length(price_forecast)-1);

    % Time vector for interpolation
    new_time_hours = 0:dt/3600:24*7;
    
    % Interpolate the price array for a week
    weekcost = interp1(time_hours, price_forecast, new_time_hours, 'linear', 'extrap');
    
    % Give price array for length of simulation
    simdaycost = weekcost(1:total_time*((length(new_time_hours)-1)/24*7));
end

date = '2024-05-30' ; % Date of the simulation 'yyyy-mm-dd'
dayNumber = weekday(date) ; % Get the day of the week starting from 1 for Sunday