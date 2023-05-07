function task5(Tp_length)

    %% Reimplement for time 5-6s
    % Using picoseconds as the unit
    
    
    % Variable declerations (Experimental)
    % Default Trep_alignment2 = - 0.32476
    Trep_alignment2 = - 0.32476;
    
    
    % Default Td_upper_lim2 = 4.25e4 (Experimental)
    % Adjust these values to change Td
    Td_upper_lim2 = 4.75e4;
    Td_lower_lim2 = Td_upper_lim2 - Tp_length;
    
    % Team data is from 4s to 6s (Given)
    time_start2 = 5e12;
    time_end2 = time_start2 + 1e12;
    
    % Inject the default values for debugging purposes 
    % Enter '1' for debugging, else for bypassing
    debugging_mode = 0;

    % Td filter variable. Default: Td_max = Tp_length
    Td_filter_max = 100e3-Trep_alignment2;
    
    %% Organize the command window
    disp('=================================================================');
    disp('Part II - Time 5-6s');
    disp('=================================================================');
    
    
    %% Enter the time period
    create_team_data(time_start2, time_end2)
    
    
    %% Synch and normalize the data and save it
    % Task #1
    
    % '1' to calculate the regression line, else to bypass
    regression_disp = 0;
    synch_data(Trep_alignment2, time_start2, time_end2, Td_upper_lim2, Td_lower_lim2, regression_disp);
    
    
    %% Graph the normalized data
    normalized_graph(Trep_alignment2, time_start2, time_end2, Tp_length);
    
    %% Detector Statistics
    % Task #2
    detector_statistics()
    
    
    %% Calculate occurances and probabilities
    % Task #3 and Task #4
    probability_hists(Trep_alignment2, time_start2, time_end2, debugging_mode, Td_filter_max);

    %% Display Deliverables

    fprintf('Trep = %f ps\n', 100e3 + Trep_alignment2);
    
    fprintf('Tstart = %d ps ps\n', Td_lower_lim2);


end
