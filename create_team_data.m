function create_team_data(time_start, time_end)

% Specify the input file name and the range of data to be copied
input_file = 'data.txt';
% time_start = 4e12; % Start time in picoseconds
% time_end = 5e12; % End time in picoseconds

% Specify the output file name
output_file = 'Team3_data.txt';

% Read the input data file
data = dlmread(input_file);

% Find the indices of the rows that fall within the specified time range
indices = find(data(:,2) >= time_start & data(:,2) <= time_end);

% Copy the data to the output file
dlmwrite(output_file, data(indices,:), 'delimiter', '\t', 'precision', '%d');

end