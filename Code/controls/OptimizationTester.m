
dates = ["2024-01-01.csv", "2024-01-16.csv", "2024-01-24.csv"]; %"02-01.csv" "02-16.csv" "02-24.csv"]
    % "03-03.csv" "03-11.csv" "03-26.csv" "04-03.csv" "04-18.csv" "04-26.csv" ...
    % "05-04.csv" "05-19.csv" "05-27.csv" "06-04.csv" "06-12.csv" "06-20.csv" ...
    % "Delft.csv" "Delft21-5.csv" "Delft28-11.csv" "Delft30-5.csv" "WeerDelft2-5.csv"];

days = ['2024-01-01', '2024-01-16', '2024-01-24']; % '2024-02-01' '2024-02-16' '2024-02-24' ...
    % '2024-03-03' '2024-03-11' '2024-03-26' '2024-04-03' '2024-04-18' '2024-04-26' ...
    % '2024-05-04' '2024-05-19' '2024-05-27' '2024-06-04' '2024-06-12' '2024-06-20' ...
    % 'Delft' 'Delft21-5' 'Delft28-11' 'Delft30-5' 'WeerDelft2-5'];

for z = 1:length(dates)
    date = days(z);
    file_weather = dates(z);
    display(file_weather)
    run("GradientDescend");
    min_cost(z) = min(cost_save);
    max_cost(z) = max(cost_save);
    end_fraction(z) = min_cost(z)/max_cost(z);

end

avg_end_fraction = mean(end_fraction);


writematrix(avg_end_fraction, 'results.xlsx');

disp(['Current Directory: ', pwd]);