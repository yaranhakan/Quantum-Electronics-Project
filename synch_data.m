function synch_data(Trep_allignment, Tbin_start, Tbin_end, Td_lim_high, Td_lim_low, regression_disp)

    % Using picoseconds as the unit
    
    
    % Load data from text file
    filename = 'Team3_data.txt';
    data = load(filename);
    
    % Extract columns
    timestamp = data(:, 2);
    
    % Initialize variables
    Trep_init = 100e3; % convert 100ns to ps (estimated)
    
    % Calibrate here (- 0.3245)
    Trep = Trep_init + Trep_allignment;
    
    bins = (Tbin_start:Trep:Tbin_end)'; %find bin times
    
    %% Calculate Td
    
    % Initialize Td and counters
    Td = NaN(size(bins));
    bins_idx = 1;
    timestamp_idx = 1;
    
    % Iterate through the bins and timestamp arrays
    while bins_idx <= numel(bins) && timestamp_idx <= numel(timestamp)
        % Calculate the difference between the current timestamp and bin elements
        diff_var = timestamp(timestamp_idx) - bins(bins_idx);
    
        % Check if the difference meets the constraint
        if diff_var > 0 && diff_var <= 100e3
            % Save the difference to Td and move to the next bin
            Td(bins_idx) = diff_var;
            bins_idx = bins_idx + 1;
        elseif diff_var > 100e3
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
    
    % Find NaN rows using the isnan function
    nan_rows = isnan(Td);
    
    % Remove NaN rows using logical indexing
    Td_no_nan = Td(~nan_rows);
    corresponding_timestamp_no_nan = corresponding_timestamp(~nan_rows);
    
    % Merge the two arrays into one
    Td_mat = [Td_no_nan, corresponding_timestamp_no_nan];
    
    %% Find the Td limits
%     Td_lim_high = 8.6e4;
%     Td_lim_low = 7.6e4;
    
    % Find the percentage of the data falls in the desired range
    idx = find(Td_mat(:,1) >= Td_lim_low & Td_mat(:,1) <= Td_lim_high);
    
    % Calculate the percentage of the data that meet the criteria
    percentage = length(idx)/size(Td_mat,1) * 100;
    
    % Display the percentage
    fprintf('%.2f%% of the data in the first column are between %dps and %dps.\n', percentage, Td_lim_low, Td_lim_high);
    
    %% Save the results data
    
    synchronized_data = [data(:,1), data(:,2)-Td_lim_low];
    
    save('synchronized_data.mat', 'synchronized_data');
    save('Trep.mat', 'Trep');
    save('Td.mat', 'Td');
    
    
    %% Plotting
    % Scatter plot Td vs corresponding_timestamp
    figure;
    scatter(corresponding_timestamp, Td);
    xlabel('Corresponding Timestamp');
    ylabel('Td');
    title('Scatter Plot of Td vs Corresponding Timestamp');
    grid on;
    
    
    
    yline(Td_lim_high, 'r--', 'LineWidth', 2);
    yline(Td_lim_low, 'r--', 'LineWidth', 2);
    
    %% Regression Calculation
    
    if regression_disp == 1
        load('Td.mat');  % Load the column array "Td.mat"
    
        % Remove NaN values from the array
        Td_no_nan = Td(~isnan(Td));
    
    
        % Center and scale the data
        centered_timestamps = Td_no_nan - mean(Td_no_nan);
        scaled_Td = (corresponding_timestamp_no_nan - mean(corresponding_timestamp_no_nan)) / std(corresponding_timestamp_no_nan);
        
        % Create a scatter plot of the centered and scaled data
        scatter(scaled_Td, centered_timestamps);
        xlabel('Scaled corresponding_timestamp_no_nan');
        ylabel('Centered Td_no_nan');
        title('Scatter Plot of Centered Td_no_nan vs Scaled corresponding_timestamp_no_nan');
        
        % Fit a linear regression model using the 'fitlm' function
        lm = fitlm(scaled_Td, centered_timestamps);
        
        % Get the fitted values (regression line) from the linear regression model
        regression_line = lm.Fitted;
        
        % Add the regression line to the scatter plot
        hold on;
        plot(scaled_Td, regression_line, 'r');
        legend('Data Points', 'Regression Line');
        hold off;
        
        reg_slope = (regression_line(end) - regression_line(1)) / numel(regression_line);
        
        disp(['Slope of the regression line = ', num2str(reg_slope)]);
    end

end