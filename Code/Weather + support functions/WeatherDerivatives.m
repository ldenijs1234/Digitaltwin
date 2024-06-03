
function Derivative = WeatherDerivatives(WeatherInput, dt)

    Derivative = zeros(1, length(WeatherInput)) ;

    for i = 1:length(WeatherInput)-1
        Derivative(i) = (WeatherInput(i+1) - WeatherInput(i))/dt ;
    end

    Derivative(end) = Derivative(end-1) ;
end


% Suggested weather inputs: OutsideTemperature, OutsideHumidity, SolarRadiation, WindSpeed, CloudCover