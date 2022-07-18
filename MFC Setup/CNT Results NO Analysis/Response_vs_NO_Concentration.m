% This script reads the sensor data from Chip 5 taken on 6/16/2022.
% It makes a plot of Response versus NO concentration.
% The plot was done on the data from Pads 7-12.
% Author: Jerry Chen
% Date Created: 7/7/2022
% Last Updated: 7/7/2022

clear; close all; clc;

%% LOADING DATA
% I put the .mat file in the same directory as this script. Make sure you
% specify the directory when you use this script.
load("CNT_Results_NO.mat")
timeE = CNT_Results_NO(7).timeE;
noppm = CNT_Results_NO(7).noppm;
% rh = CNT_Results_NO(7).rh;
r = CNT_Results_NO(7).r;

%%　BASELINE CORRECTION
% Trim down the data to one run of NO addition steps

% n_run = 3;                  % number of runs
% n_expo = 7;                 % number of exposures per run
% t_pre_purge = 10 * 60;      % pre-purge time in seconds
% t_expo = 1 * 60;            % exposure to NO in seconds
% t_purge = 5 * 60;           % purge time after each exposure in seconds
% t_post_purge = 10 * 60;     % purge time after the last run is done

sample_freq = 2;



% Find the indices where NO is added
indices_NO = find(noppm);

%% Finding Delta R and Concentration 
% The code below finds the change of response over 1 minute after each
% addition of NO into the system. There are in total seven additions, with
% incremental concentration values. These seven additions happens between
% roughly 2 and 3.75 hours after the start of data collection.

% Manually found indices corresponding to starting points of NO additions.
% This should be automated once figured out smoothing algorithm.
NO_add_indices = [14069; 15882; 17510; 19170; 20859; 22542; 24211];

% Set sampling indices to be 1 minute after the starting points.
% Data was taken every 0.5 seconds, so 120 data points for 1 minute.
sample_indices = NO_add_indices + 120;

fig = figure();
for pad = 7:12
    % Getting response data from the current pad.
    r_pad_n = r(:,pad);
    
    % Getting response data after 1 minute of NO addition. Averaged over
    % 15+15+1=31 data points before and after the 1 min mark.
    % Doing this for all seven additions.
    % **The number of stepped additions needs to be a variable if subject 
    % to change in the future. Hard coded as a number for now.**
    sampled_r_post_NO = zeros(7,1);
    for i = 1:length(sampled_r_post_NO)
        index_i = sample_indices(i) - 15;
        index_f = sample_indices(i) + 15;
        sampled_r_post_NO(i) = mean(r_pad_n(index_i:index_f));
    end

    % Getting response data before the addition of NO, averaged over 31 
    % data points prior to NO addition.
    % Doing this for all seven additions.
    sampled_r_pre_NO = zeros(7,1);
    for i = 1:length(sampled_r_pre_NO)
        index_i = NO_add_indices(i) - 30;
        index_f = NO_add_indices(i);
        sampled_r_pre_NO(i) = mean(r_pad_n(index_i:index_f));
    end
    
    % Calculating change of response as a result of NO addition. 
    % This contains the delta r for all seven additions.
    delta_r = sampled_r_post_NO - sampled_r_pre_NO;
    
    % Finding the concentration of each NO addition run, averaged over the
    % 1 minute period.
    % Doing this for all seven additions.
    sampled_conc = zeros(7,1);
    for i = 1:length(sampled_conc)
        sampled_conc(i) = mean(noppm(NO_add_indices(i):sample_indices(i)));
    end
    
    % Plot out the data.
    plot(sampled_conc, delta_r, LineWidth=1, Marker='x', LineStyle='-', ...
        DisplayName=['Pad ' num2str(pad)]); hold on;
    
end

% Setting visual aspects of the plot.
xlabel('NO Concentration (ppm)');
ylabel('Response (\DeltaR)');
title('Response at Different Added NO Concentration');
subtitle('Chip 5, Pads 7-12, 06/16/2022');
legend();
fig.Position = [100, 100, 1400, 600];
