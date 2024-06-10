run("SetModel")
SimStart = 1 ;
SimEnd = length(t) ;
run("SetInputs")
run("SetParameters")

sinefunction = sin(3);

Cost_Derivative = diff(simdaycost)./diff(t);

function output_array = weighted_average_with_hann_window(input_array, window_size)
    if nargin < 2
        window_size = 60;
    end
    
    % Create a Hann window of the specified size
    window = hann(window_size);
    
    % Normalize the window to make sure it sums to 1
    window = window / sum(window);
    
    % Initialize the result array
    result_length = length(input_array) - window_size + 1;
    output_array = zeros(1, result_length);
    
    % Compute the weighted average using the Hann window
    for i = 1:result_length
        output_array(i) = sum(input_array(i:i+window_size-1) .* window');
    end
end

weighted_average = weighted_average_with_hann_window(Cost_Derivative);