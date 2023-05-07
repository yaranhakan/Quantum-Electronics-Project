
% Using picoseconds as the unit

if debugging_mode == 1
    Trep_allignment = -0.3245;
    Tbin_start = 4e12;
    Tbin_end = 5e12;
    Tp_length = 1e4;
end

% Load the data
load('synchronized_data.mat');

% Extract detector ID and detection time
detector_num = synchronized_data(:, 1);
detection_time = synchronized_data(:, 2);

% Initialize the count for each detector
count_detector_1 = 0;
count_detector_3 = 0;
count_detector_5 = 0;
count_detector_7 = 0;

% Iterate through the data and count the detections for each detector
for i = 1:length(detector_num)
    switch detector_num(i)
        case 1
            count_detector_1 = count_detector_1 + 1;
        case 3
            count_detector_3 = count_detector_3 + 1;
        case 5
            count_detector_5 = count_detector_5 + 1;
        case 7
            count_detector_7 = count_detector_7 + 1;
    end
end

% Calculate the total counts and percentages
total_counts = count_detector_1 + count_detector_3 + count_detector_5 + count_detector_7;
percentage_detector_1 = (count_detector_1 / total_counts) * 100;
percentage_detector_3 = (count_detector_3 / total_counts) * 100;
percentage_detector_5 = (count_detector_5 / total_counts) * 100;
percentage_detector_7 = (count_detector_7 / total_counts) * 100;

% Display the results
fprintf('Detector 1: %d counts, %.2f%%\n', count_detector_1, percentage_detector_1);
fprintf('Detector 3: %d counts, %.2f%%\n', count_detector_3, percentage_detector_3);
fprintf('Detector 5: %d counts, %.2f%%\n', count_detector_5, percentage_detector_5);
fprintf('Detector 7: %d counts, %.2f%%\n', count_detector_7, percentage_detector_7);
