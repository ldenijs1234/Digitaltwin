run("SetModel")
run("SetInputs")

Cost_Derivative = diff(simdaycost)./diff(t);

    % Create a Hann window of the specified size
    
    % Normalize the window to make sure it sums to 1
    
    % Initialize the result array
    result_length = length(input_array) - window_size + 1;
    output_array = zeros(1, result_length);
    
    % Compute the weighted average using the Hann window
    for i = 1:result_length
        output_array(i) = sum(input_array(i:i+window_size-1) .* window');
    end
end

