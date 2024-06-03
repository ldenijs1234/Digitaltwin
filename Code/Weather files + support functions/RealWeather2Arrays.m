
function [time_vec, OutsideTemperature, OutsideRelhumidity, SolarRadiation, Windspeed, Winddirection, Sealevelpressure, CloudCover, DewPoint] = Weather2Arrays(filename, dt, total_time)
    % Read the data using readtable
    tbl = readtable(filename);
    
    % Extract the relevant columns
    temp_out = table2array(tbl(:,3));   
    rel_hum = table2array(tbl(:,6));   
    wind_speed = table2array(tbl(:,13));
    wind_dir = table2array(tbl(:,14));  
    sealevel_pressure = table2array(tbl(:,15));
    cloud_cover = table2array(tbl(:,16));
    solar_rad = table2array(tbl(:,18)); 
    dew_point = table2array(tbl(:,5)); 

    % Randomize the data
    temp_out = temp_out *(0.95 + 0.1 * rand(length(temp_out)));
    rel_hum = rel_hum *(0.95 + 0.1 * rand(length(rel_hum)));
    wind_speed = wind_speed *(0.95 + 0.1 * rand(length(wind_speed)));
    wind_dir = wind_dir *(0.95 + 0.1 * rand(length(wind_dir)));
    sealevel_pressure = sealevel_pressure *(0.95 + 0.1 * rand(length(sealevel_pressure)));
    cloud_cover = cloud_cover *(0.95 + 0.1 * rand(length(cloud_cover)));
    solar_rad = solar_rad *(0.95 + 0.1 * rand(length(solar_rad)));
    dew_point = dew_point *(0.95 + 0.1 * rand(length(dew_point)));


    % Generate a time vector for data points (modify as per actual data timing)
    time_hours = 0:1:((height(tbl) - 1) * 1);

    % Time vector for interpolation
    new_time_hours = 0:dt/3600:total_time;

    % Perform interpolation
    OutsideTemperature = interp1(time_hours, temp_out, new_time_hours, 'linear', 'extrap');
    OutsideRelhumidity = interp1(time_hours, rel_hum, new_time_hours, 'linear', 'extrap');
    Windspeed = interp1(time_hours, wind_speed, new_time_hours, 'linear', 'extrap');
    Winddirection = interp1(time_hours, wind_dir, new_time_hours, 'linear', 'extrap');
    Sealevelpressure = interp1(time_hours, sealevel_pressure, new_time_hours, 'linear', 'extrap');
    CloudCover = interp1(time_hours, cloud_cover, new_time_hours, 'linear', 'extrap');
    SolarRadiation = interp1(time_hours, solar_rad, new_time_hours, 'linear', 'extrap');
    DewPoint = interp1(time_hours, dew_point, new_time_hours, 'linear', 'extrap');

    % Assign outputs
    time_vec = new_time_hours;
end

