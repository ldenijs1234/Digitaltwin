dates = ["01-01.csv" "01-16.csv" "01-24.csv"] %"02-01.csv" "02-16.csv" "02-24.csv"]
    % "03-03.csv" "03-11.csv" "03-26.csv" "04-03.csv" "04-18.csv" "04-26.csv" ...
    % "05-04.csv" "05-19.csv" "05-27.csv" "06-04.csv" "06-12.csv" "06-20.csv" ...
    % "Delft.csv" "Delft21-5.csv" "Delft28-11.csv" "Delft30-5.csv" "WeerDelft2-5.csv"];


    
for z = 1:length(dates)
    file_weather = dates(z);
    display(file_weather)
    run("StochasticGradientDescend");
    min_cost(z) = min(cost_save);
    max_cost(z) = max(cost_save);
    end_fraction(z) = min_cost(z)/max_cost(z);

end

avg_end_fraction = mean(end_fraction);