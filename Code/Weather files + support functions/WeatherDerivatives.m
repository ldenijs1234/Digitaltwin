
function Derivative = WeatherDerivatives(WeatherInput, dt)

    Derivative = zeros(1, length(WeatherInput)) ;    % Empty array

    for i = 1:length(WeatherInput)-1
        Derivative(i) = (WeatherInput(i+1) - WeatherInput(i))/dt ;   % Take forward derivative of desired input
    end

    Derivative(end) = Derivative(end-1) ;   % Set last derivative for array size continuity
end


% Suggested weather inputs: OutsideTemperature, OutsideHumidity, SolarRadiation, WindSpeed, CloudCover