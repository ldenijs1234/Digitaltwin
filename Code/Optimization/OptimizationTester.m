global file_weather date;
dates = [    
    "2023-10-14.csv", "2023-10-29.csv", "2023-11-06.csv", "2023-11-21.csv", "2023-11-28.csv", 
    "2023-12-07.csv", "2023-12-15.csv", "2023-12-23.csv", "2023-12-31.csv", "2024-01-01.csv",
    "2024-01-11.csv", "2024-01-16.csv", "2024-01-24.csv", "2024-02-01.csv", "2024-02-16.csv",
    "2024-02-24.csv", "2024-03-03.csv", "2024-03-11.csv", "2024-03-26.csv", "2024-04-03.csv",
    "2024-04-18.csv", "2024-04-26.csv", "2024-05-02.csv", "2024-05-19.csv", "2024-05-21.csv",
    "2024-05-27.csv", "2024-05-30.csv", "2024-06-04.csv", "2024-06-12.csv", "2024-06-20.csv"]

days = [
    "2023-10-14", "2023-10-29", "2023-11-06", "2023-11-21", "2023-11-28", 
    "2023-12-07", "2023-12-15", "2023-12-23", "2023-12-31", "2024-01-01",
    "2024-01-11", "2024-01-16", "2024-01-24", "2024-02-01", "2024-02-16",
    "2024-02-24", "2024-03-03", "2024-03-11", "2024-03-26", "2024-04-03",
    "2024-04-18", "2024-04-26", "2024-05-02", "2024-05-19", "2024-05-21",
    "2024-05-27", "2024-05-30", "2024-06-04", "2024-06-12", "2024-06-20"]

results = "results.xlsx";
disp(['Current Directory: ', pwd]);
hWaitBar3 = waitbar(0, sprintf('File %d/%d', 0, length(dates)));
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
    percentage_improve_lowerbound(z) = (1 - (min_cost(z)/lowerboundcost(z))) * 100;
     % Create a table for the current results
     T = table(date, guess(z), min_cost(z), max_cost(z), lowerboundcost(z), percentage_improve(z), percentage_improve_lowerbound(z), ...
        'VariableNames', {'Date', 'Guess', 'Cost after optimization', 'Cost at first guess', 'Lowerbound Cost', 'Improvement to first guess', 'Improvement to lowerbound'});

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


