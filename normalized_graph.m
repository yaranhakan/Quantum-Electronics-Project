function normalized_graph(Trep_allignment, Tbin_start, Tbin_end, Tp)

    % Using picoseconds as the unit
    
    
    % Initialize variables
    Trep = 100e3 + Trep_allignment;
    
    load('synchronized_data.mat');
    
    % Extract columns
    % detector = synchronized_data(:, 1);
    timestamp = synchronized_data(:, 2);
    
    bins = (Tbin_start:Trep:Tbin_end)'; %find bin times
    
    %% Calculate Td
    
    % Initialize Td and counters
    Td = NaN(size(bins));
    bins_idx = 1;
    timestamp_idx = 1;
    
    % Iterate through the bins and timestamp arrays
    while bins_idx <= numel(bins) && timestamp_idx <= numel(timestamp)
        % Calculate the difference between the current timestamp and bin elements
        diff = timestamp(timestamp_idx) - bins(bins_idx);
    
        % Check if the difference meets the constraint
        if diff > 0 && diff <= 100e3
            % Save the difference to Td and move to the next bin
            Td(bins_idx) = diff;
            bins_idx = bins_idx + 1;
        elseif diff > 100e3
            % Move to the next bin if the difference exceeds the constraint
            bins_idx = bins_idx + 1;
        else
            % Move to the next timestamp if the difference is less than or equal to 0
            timestamp_idx = timestamp_idx + 1;
        end
    end
    
    %% Process
    
    % Find the corresponding timestamp values for Td
    corresponding_timestamp = bins + Td;
        

    
    %% Plotting
    % Scatter plot Td vs corresponding_timestamp
    figure;
    scatter(corresponding_timestamp, Td);
    xlabel('Corresponding Timestamp');
    ylabel('Td');
    title('Scatter Plot of Td vs Corresponding Timestamp');
    grid on;
    
    yline(Tp, 'r--', 'LineWidth', 2);
    
    yline(0, 'r--', 'LineWidth', 2);
    
    
    % xlim([4e12, 5e12]);

end