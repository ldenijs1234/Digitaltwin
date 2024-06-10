run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
run("SetInputs")
run("SetParameters")

sinefunction = 6 * sin(2 * pi * t/ 24);
plot(t, sinefunction)

Cost_Derivative = diff(simdaycost)./diff(t);

window_size = 60;

function [output_array, window] = weighted_average_with_hann_window(input_array, window_size)
      
    % Create a Hann window of the specified size
    hann_window = hann(window_size);
    
    % Normalize the window to make sure it sums to 1
    window = hann_window / sum(hann_window);
    
    % Initialize the result array
    result_length = length(input_array) - window_size + 1;
    output_array = zeros(1, result_length);
    
    % Compute the weighted average using the Hann window
    for i = 1:result_length
        output_array(i) = sum(input_array(i:i+window_size-1) .* window');
    end
end

[weighted_average, hann_window] = weighted_average_with_hann_window(Cost_Derivative, window_size);