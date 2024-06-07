customsetpoint = true;

% Create a figure window
figure;

% Set the axes limits
xlim([0 24]);
ylim([10 25]);
hold on;
grid on;

% Initialize arrays to store the points
x = zeros(1, 25);
y = zeros(1, 25);

% Loop to collect 25 points from user clicks
for i = 1:25
    % Get the current point clicked by the user
    [x(i), y(i)] = ginput(1);
    
    % Ensure the y value is within the specified range
    y(i) = max(10, min(25, y(i)));
    
    % Plot the current point
    plot(x(i), y(i), 'ro');
    
    % Draw a line connecting to the previous points
    if i > 1
        plot(x(1:i), y(1:i), 'b-');
    end
end

% Ensure the first and last points
x(1) = 0;
x(25) = 24;

% Store the interpolated points in an array
points = [x' y'];

% Display the array of points
disp('Array of interpolated points:');
disp(points);

% Plot the interpolated line with 25 points
plot(x, y, 'ro-');

% Label the axes
xlabel('X');
ylabel('Y');
title('Interpolated Line with 25 Points');

T_st = points(:, 2);

run("GradientDescend");