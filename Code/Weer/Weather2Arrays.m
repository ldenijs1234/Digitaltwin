
function [time_vec, OutsideTemperature, OutsideRelhumidity, SolarRadiation, Windspeed, Winddirection, Sealevelpressure, CloudCover, DewPoint] = Weather2Arrays(filename, dt, total_time)
    % Read the data using readtable
    tbl = readtable(filename);
    
    % Extract the relevant columns
    temp_out = table2array(tbl(:,3));   
    rel_hum = table2array(tbl(:,6));   
    wind_speed = table2array(tbl(:,13));
    wind_dir = table2array(tbl(:,14));  
    sealevel_pressure = table2array(tbl(:,15));
    cloud_cover = table2array(tbl(:,17));
    solar_rad = table2array(tbl(:,18)); 
    dew_point = table2array(tbl(:,5)); 

    % Generate a time vector for data points (modify as per actual data timing)
    time_hours = 0:1:((height(tbl) - 1) * 1);

    % Time vector for interpolation
    new_time_hours = 0:dt/3600:total_time;

    % Perform interpolation
    temp_interp = interp1(time_hours, temp_out, new_time_hours, 'linear', 'extrap');
    hum_interp = interp1(time_hours, rel_hum, new_time_hours, 'linear', 'extrap');
    wind_speed_interp = interp1(time_hours, wind_speed, new_time_hours, 'linear', 'extrap');
    wind_dir_interp = interp1(time_hours, wind_dir, new_time_hours, 'linear', 'extrap');
    sealevel_pressure_interp = interp1(time_hours, sealevel_pressure, new_time_hours, 'linear', 'extrap');
    cloud_cover_interp = interp1(time_hours, cloud_cover, new_time_hours, 'linear', 'extrap');
    solar_interp = interp1(time_hours, solar_rad, new_time_hours, 'linear', 'extrap');
    dew_interp = interp1(time_hours, dew_point, new_time_hours, 'linear', 'extrap');


    OutsideTemperature = temp_interp;
    OutsideRelhumidity = hum_interp;
    SolarRadiation = solar_interp;
    Windspeed = wind_speed_interp;
    Winddirection = wind_dir_interp;
    Sealevelpressure = sealevel_pressure_interp;
    CloudCover = cloud_cover_interp;
    DewPoint = dew_interp;

    % Assign outputs
    time_vec = new_time_hours;
end




