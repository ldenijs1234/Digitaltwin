% Function to calculate the energy cost for a given week and day
function [price_array_W6, price_array_W5, price_array_W4, simdaycost, day_average] = Energycost(file, dt, total_time, date)
    
    tbl = readtable(file);
    dayNumber = -1*(weekday(date)-1) ; % Get the day of the week starting from 0 for Sunday, -1 for Monday, etc.
    

    EnergyCost_Euro_per_MWh = table2array(tbl(:,5));
    EnergyCost_Euro_per_kWh = EnergyCost_Euro_per_MWh ./ 1000;
    
    price_arrayy_W6 = EnergyCost_Euro_per_kWh(end-((dayNumber+24)*24)-1:end-((dayNumber+23)*24)-1); % 6 weeks ago
    price_arrayy_W5 = EnergyCost_Euro_per_kWh(end-((dayNumber+17)*24)-1:end-((dayNumber+16)*24)-1); % 5 weeks ago
    price_arrayy_W4 = EnergyCost_Euro_per_kWh(end-((dayNumber+10)*24)-1:end-((dayNumber+9)*24)-1); % 4 weeks ago
    
    price_forecast = mean([price_arrayy_W6, price_arrayy_W5, price_arrayy_W4], 2); % day average of the last 3 weeks
    price_forecast = (price_forecast)';
    
    % Time vector for data points
    time_hours = 0:1:(length(price_forecast)-1);

    % Time vector for interpolation
    new_time_hours = 0:dt/3600:24;

    % Interpolate the price array for a day
    daycost = interp1(time_hours, price_forecast, new_time_hours, 'linear', 'extrap');
    price_array_W6 = interp1(time_hours, price_arrayy_W6, new_time_hours, 'linear', 'extrap');
    price_array_W5 = interp1(time_hours, price_arrayy_W5, new_time_hours, 'linear', 'extrap');
    price_array_W4 = interp1(time_hours, price_arrayy_W4, new_time_hours, 'linear', 'extrap');
    
    % Give price array for length of simulation
    simdaycost = daycost(1:total_time*(length(new_time_hours)/24));
    day_average = sum(simdaycost)/length(simdaycost)*ones(1, length(new_time_hours));
    
end


