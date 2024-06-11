hWaitBar3 = waitbar(0, 'Please wait...');

global file_weather date;
dates = ["2024-01-01.csv", "2024-01-16.csv", "2024-01-24.csv"]; %"02-01.csv" "02-16.csv" "02-24.csv"]
    % "03-03.csv" "03-11.csv" "03-26.csv" "04-03.csv" "04-18.csv" "04-26.csv" ...
    % "05-04.csv" "05-19.csv" "05-27.csv" "06-04.csv" "06-12.csv" "06-20.csv" ...
    % "Delft.csv" "Delft21-5.csv" "Delft28-11.csv" "Delft30-5.csv" "WeerDelft2-5.csv"];

days = ["2024-01-01", "2024-01-16", "2024-01-24"]; % '2024-02-01' '2024-02-16' '2024-02-24' ...
    % '2024-03-03' '2024-03-11' '2024-03-26' '2024-04-03' '2024-04-18' '2024-04-26' ...
    % '2024-05-04' '2024-05-19' '2024-05-27' '2024-06-04' '2024-06-12' '2024-06-20' ...
    % 'Delft' 'Delft21-5' 'Delft28-11' 'Delft30-5' 'WeerDelft2-5'];

results = "results.xlsx";
disp(['Current Directory: ', pwd]);

for z = 1:length(dates)
    date = days(z);
    file_weather = dates(z);
    display(file_weather);
    run("InitialGuess");
    run("GradientDescend");
    guess(z) = Guess_index;
    min_cost(z) = min(cost_save);
    max_cost(z) = max(cost_save);
    lowerboundcost(z) = costguess(1);
    percentage_improve(z) = (1 - (min_cost(z)/max_cost(z))) * 100;
    
     % Create a table for the current results
     T = table(date, guess(z), min_cost(z), max_cost(z), lowerboundcost(z), percentage_improve(z), ...
        'VariableNames', {'Date', 'Guess', 'MinCost', 'MaxCost', 'LowerboundCost', 'PercentageImprove'});

    % Append the table to the results.xlsx file
    if z == 1
        writetable(T, results, 'WriteMode', 'overwritesheet');
    else
        writetable(T, results, 'WriteMode', 'append', 'WriteVariableNames', false);
    end
    waitbar(z/length(dates), hWaitBar3, sprintf('File %d/%d', z, length(dates)))
end
close(hWaitBar3)
disp(['Current Directory: ', pwd]);


