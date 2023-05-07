%% This project was made for Quantum Electronics course at Syracuse University
% Author: O. Hakan Yaran
% yaranhakan@gmail.com
% 04/27/2023
% Reference paper to this project: 
% "Photon statistics characterization of a single-photon source" R Alléaume

% Using picoseconds as the unit

clc
clear

% Variable declerations (Experimental)
% Default Trep_alignment = - 0.324465
Trep_alignment = - 0.324465;

% Photon emission time length of the SPE (Given)
Tp_length = 2e4;

% Td Synchronization
% Default Td_upper_lim = 8.62e4 (Experimental)
% Adjust these values to change Td
Td_upper_lim = 9.12e4;
Td_lower_lim = Td_upper_lim - Tp_length;

% Team data is from 4s to 6s (Given)
time_start = 4e12;
time_end = time_start + 1e12;

% Inject the default values for debugging purposes 
% Enter '1' for debugging
debugging_mode = 0;

% Gating Feature Variable
% Gating ON: Td_filter_max = Tp_length
% Gating OFF: Td_filter_max = 100e3-Trep_alignment
Td_filter_max = 100e3-Trep_alignment;

% Td_filter_max = Tp_length;

%% Choose the time period of the team (4s-5s for our team)
%create_team_data(time_start, time_end)

%% Organize the command window
    disp('=================================================================');
    disp('Part I - Time 4-5s');
    disp('=================================================================');


%% Synch and normalize the data and save it
% Task #1

% '1' to calculate the regression line, else to bypass
regression_disp = 0;
synch_data(Trep_alignment, time_start, time_end, Td_upper_lim, Td_lower_lim, regression_disp);


%% Graph the normalized data
normalized_graph(Trep_alignment, time_start, time_end, Tp_length);

%% Detector Statistics
% Task #2
detector_statistics()


%% Calculate occurances and probabilities
% Task #3 and Task #4
probability_hists(Trep_alignment, time_start, time_end, debugging_mode, Td_filter_max);

%% Display Deliverables

fprintf('Trep = %f ps\n', 100e3 + Trep_alignment);

fprintf('Tstart = %d ps ps\n', Td_lower_lim);



%% Reimplement the program for T = 5-6
% Task #5

% REMOVE THE COMMENT OPERATOR TO CALCULATE T = 5-6
% task5(Tp_length)
