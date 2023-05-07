function probability_hists(Trep_alignment, Tbin_start, Tbin_end, debugging_mode, Td_filter_max)
    
    % Using picoseconds as the unit

    if debugging_mode == 1
        Trep_alignment = - 0.324465;
        Tbin_start = 4e12;
        Tbin_end = 5e12;
    end

    
    % Initialize variables
    
    load('synchronized_data.mat');

    Trep = 100e3 + Trep_alignment;
    
    
    % Find the bins and Tp boundaries
    bins = (Tbin_start:Trep:Tbin_end)'; %find bin times
    Tp_limits = [bins, bins + Td_filter_max];
    
    %% Find the detection counts of each pulse
    
    s_data = synchronized_data(:, 2);
    Tp_l = Tp_limits(:, 1);
    Tp_h = Tp_limits(:, 2);
    
    corresponding_data_count = zeros(size(Tp_l));
    
    for i = 1:length(Tp_l)
        lower_limit = Tp_l(i);
        upper_limit = Tp_h(i);
        
        % Binary search for the lower limit index
        left = 1;
        right = length(s_data);
        while left < right
            mid = left + floor((right - left) / 2);
            if s_data(mid) < lower_limit
                left = mid + 1;
            else
                right = mid;
            end
        end
        lower_idx = left;
        
        % Binary search for the upper limit index
        left = 1;
        right = length(s_data);
        while left < right
            mid = left + ceil((right - left) / 2);
            if s_data(mid) > upper_limit
                right = mid - 1;
            else
                left = mid;
            end
        end
        upper_idx = left;
        
        corresponding_data_count(i) = upper_idx - lower_idx + 1;
    end
    
    occurrences = histcounts(corresponding_data_count, -0.5:1:4.5);
    
    result = struct();
    result.zero_corresponding = occurrences(1);
    result.one_corresponding = occurrences(2);
    result.two_corresponding = occurrences(3);
    result.three_corresponding = occurrences(4);
    result.four_corresponding = occurrences(5);

    %% Create a histogram to show the results
    
    % Create the histogram with separate bar plot objects
    figure;
    bar_positions = 0:4;
    bar_handles = zeros(1, 5);
    for i = 1:5
        bar_handles(i) = bar(bar_positions(i), occurrences(i), 'FaceColor', 'b');
        hold on;
    end
    
    xlabel('Number of Corresponding Data');
    ylabel('Occurrences');
    title('Histogram of Corresponding Data Occurrences');
    
    % Calculate percentages
    total_occurrences = sum(occurrences);
    percentages = occurrences / total_occurrences * 100;
    
    % Create legend labels with percentages and occurrences
    legend_labels = cell(1, 5);
    for i = 1:5
        legend_labels{i} = sprintf('%d: %.4f%% (%d)', i-1, percentages(i), occurrences(i));
    end
    
    % Add legend with percentages and occurrences
    legend(bar_handles, legend_labels, 'Location', 'eastoutside');
    
    

    %% Poisson Distribution
    % Merged the two figures into a single figure

    % Number of samples to generate
    num_samples = 10000;

    total_occurrences = sum(occurrences);

    % Calculate average photon per bin
    avg_photon_per_bin_exp = sum((0:4) .* occurrences) / total_occurrences;
    
    % Generate random values from a Poisson distribution
    random_values = poissrnd(avg_photon_per_bin_exp, [1, num_samples]);
    
    % Calculate the Poisson PMF
    max_val = max(random_values);
    x = 0:max_val;
    pmf = poisspdf(x, avg_photon_per_bin_exp);
    
    % Create the merged figure
    figure;
    
    % Plot the histogram
    histogram(random_values, 'Normalization', 'pdf');
    hold on;
    
    
    bar_positions = 0:4;

    % Plot the corresponding data occurrences histogram
    for i = 1:5
        bar(bar_positions(i), occurrences(i) / total_occurrences, 'FaceColor', "#77AC30");
        hold on;
    end
    
    hold off;
    xlabel('Number of photons per bin');
    ylabel('Probability');
    title('Comparison of Poisson Distribution and Corresponding Data Occurrences');
    legend('Poisson Distribution', 'Experimental Data', 'Location', 'eastoutside');
    
    %% Task #4
    % Calculate experimental probabilities P(0), P(1), and P(2)
    P_exp = occurrences / total_occurrences;
    P0_exp = P_exp(1);
    P1_exp = P_exp(2);
    P2_exp = P_exp(3);
    
    % Calculate average photon per bin
    avg_photon_per_bin_exp = sum((0:4) .* occurrences) / total_occurrences;
    
    % Theoretical values from the paper
    Pc1 = 0.04514;
    Pc2 = 53e-5;
    avg_photon_per_bin_theory = 0.04620;
    
    % Theoretical Poisson probabilities
    P_theory = zeros(1, 5);
    P_theory(1) = 1 - Pc1 - Pc2;
    P_theory(2) = Pc1;
    P_theory(3) = Pc2;
    
    % Plot the experimental and theoretical probability histograms
    figure;
    bar_handle = bar(0:4, [P_exp; P_theory]', 'grouped');
    xlabel('Number of Detected Photons');
    ylabel('Probability');
    title('Probability Histogram');
    legend('Experimental', 'Theoretical', 'Location', 'eastoutside');
    
    % Display P(n) values on the bars
    for i = 1:5
        x_exp = bar_handle(1).XEndPoints(i);
        y_exp = bar_handle(1).YEndPoints(i);
        x_theory = bar_handle(2).XEndPoints(i);
        y_theory = bar_handle(2).YEndPoints(i);
        
        text(x_exp, y_exp, sprintf('%.6f', P_exp(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        text(x_theory, y_theory, sprintf('%.6f', P_theory(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end

    % Display probabilities
    disp('Experimental Probabilities:');
    fprintf('P(0) = %.6f\n', P_exp(1));
    fprintf('P(1) = %.6f\n', P_exp(2));
    fprintf('P(2) = %.6f\n', P_exp(3));
    fprintf('P(3) = %.6f\n', P_exp(4));
    fprintf('P(4) = %.6f\n', P_exp(5));
    
    disp('Theoretical Probabilities:');
    fprintf('P(0) = %.6f\n', P_theory(1));
    fprintf('P(1) = %.6f\n', P_theory(2));
    fprintf('P(2) = %.6f\n', P_theory(3));
    fprintf('P(3) = %.6f\n', P_theory(4));
    fprintf('P(4) = %.6f\n', P_theory(5));

    fprintf('n_bar = %f\n', avg_photon_per_bin_exp);

end

