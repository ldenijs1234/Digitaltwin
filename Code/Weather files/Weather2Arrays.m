
function [time_vec, OutsideTemperature, OutsideRelhumidity, SolarRadiation, Windspeed, Winddirection, Sealevelpressure, CloudCover, DewPoint] = Weather2Arrays(filename, dt, total_time)
    % Read the data using readtable
    tbl = readtable(filename);
    
    % Extract the relevant columns

    % Generate a time vector for data points (modify as per actual data timing)
    time_hours = 0:1:((height(tbl)) * 1);

    % Time vector for interpolation
    new_time_hours = 0:dt/3600:total_time;

    % Perform interpolation
    OutsideTemperature = interp1(time_hours, temp_out, new_time_hours, 'linear');
    OutsideRelhumidity = interp1(time_hours, rel_hum, new_time_hours, 'linear');
    Windspeed = interp1(time_hours, wind_speed, new_time_hours, 'linear');
    Winddirection = interp1(time_hours, wind_dir, new_time_hours, 'linear');
    Sealevelpressure = interp1(time_hours, sealevel_pressure, new_time_hours, 'linear');
    CloudCover = interp1(time_hours, cloud_cover, new_time_hours, 'linear');
    SolarRadiation = interp1(time_hours, solar_rad, new_time_hours, 'linear');
    DewPoint = interp1(time_hours, dew_point, new_time_hours, 'linear');

    % Assign outputs
    time_vec = new_time_hours;
end




