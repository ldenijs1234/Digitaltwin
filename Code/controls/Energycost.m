filename = 'Netherlands.csv';
function [cost, dailycost, time_hours, price_forecast, new_time_hours] = Energycostt(filename, dt, total_time)
    
    tbl = readtable(filename);

    EnergyCost_Euro_per_MWh = table2array(tbl(:,5));
    EnergyCost_Euro_per_kWh = EnergyCost_Euro_per_MWh ./ 1000;

    price_array_W6 = EnergyCost_Euro_per_kWh(end-(21*24)-1:end-(14*24)-1); % 6 weeks ago
    price_array_W5 = EnergyCost_Euro_per_kWh(end-(14*24)-1:end-(7*24)-1); % 5 weeks ago
    price_array_W4 = EnergyCost_Euro_per_kWh(end-(7*24)-1:end-1); % 4 weeks ago
    
    price_forecast = mean([price_array_W6, price_array_W5, price_array_W4], 2); % Average of the last 3 weeks
    price_forecast = price_forecast';

    % Time vector for data points
    time_hours = 0:1:(length(price_forecast)-1);

    % Time vector for interpolation
    new_time_hours = 0:dt/3600:time_hours*60*60;

    % Interpolate the price array
    cost = interp1(time_hours, price_forecast, new_time_hours, 'linear', 'extrap');
    dailycost = cost(1:1);
end

[cost, dailycost, time_hours, price_forecast, new_time_hours] = Energycostt(filename, dt, total_time);
