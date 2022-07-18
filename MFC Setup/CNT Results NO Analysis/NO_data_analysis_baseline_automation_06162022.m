% This script reads the sensor data from Chip 5 taken on 6/16/2022.
% It does baseline correction on the data, and finds the response vs
% concentration plot.
% This script only deals with the data from Pads 7-12.
% Author: Jerry Chen
% Date Created: 7/13/2022
% Last Updated: 7/13/2022

%%
% OPTIONS
clear; close all; clc;
% Some Options
entry = 6;
% - Enable/disable data smoothing (using movmean)
rsp_smooth = true;
% - Enable/disable manual step width (in seconds)
step_man_range = true;
step_man_width = 180;
% - Hide/Show Figures:
minimize_figures = false;
if minimize_figures == true
    figure_state = "minimized";
else
    figure_state = "normal";
end
% - Time window finding method: 
% ----- true  = auto define from flow file info
% ----- false = manually pick window
time_wndw_auto_find = false;
% ----- If use auto find, please fill in the following flow file info
n_run = 3;                  % number of runs
n_expo = 7;                 % number of total exposures per run
t_expo = 1 * 60;            % exposure duration in seconds
t_pre_purge = 10 * 60;      % pre-purge time in seconds
t_exp_purge = 5 * 60;       % purge time after each exposure in seconds
t_post_purge = 10 * 60;     % purge time after the last run is done

% LOADING DATA

% I put the .mat file in the same directory as this script. Make sure you
% specify the directory when you use this script.
load("CNT_Results_NO.mat")


% Trim down the data to one run of NO addition steps




% Manually trim down between 2 and 3.75 hours after start of collection
t_i = 3.75 * 60 * 60;
t_f = 5.25 * 60 * 60;
time = CNT_Results_NO(entry).timeE - CNT_Results_NO(entry).timeE(1);
run_range = find(time >= t_i & time <= t_f);
% disp(length(run_range))
time_wndw = time(run_range);
noppm_wndw = CNT_Results_NO(entry).noppm(run_range);
NO_free_indices = find(~noppm_wndw);

% Process the noppm data to remove pre-spikes.

noppm_spike = figure('Name', 'NO Spike Removal', 'NumberTitle', 'off');
noppm_spike.WindowState = figure_state;
plot(time_wndw, noppm_wndw, 'r-'); hold on;

noppm_wndw_rmspk = hampel(noppm_wndw, 15);
plot(time_wndw, noppm_wndw_rmspk, 'b-', LineWidth=2); 
title('NO Concentration over time')
legend('Original Data', 'Pre-Spikes Removed')
xlabel('Time (s)')
ylabel('Concentration')
hold off

% Auto detect start and end of exposure
stp_i = detect_start(noppm_wndw_rmspk);
disp('beginings')
disp(stp_i)
stp_f = zeros(size(stp_i));
if step_man_range == false
    stp_f = detect_end(noppm_wndw_rmspk);
else
    for stp = 1:length(stp_i)
        [~, end_ind] = min(abs((time_wndw(stp_i(stp)) + step_man_width)-time_wndw));
        stp_f(stp) = end_ind;
    end
    disp('endings')
    disp(stp_f)
end
disp('intervals')
disp(time_wndw(stp_f) - time_wndw(stp_i))
%%
% average concentration within each exposure
noppm_stp_avg = zeros(size(stp_i));
for step = 1:length(stp_i)
    noppm_stp_avg(step) = mean(noppm_wndw_rmspk(stp_i(step):stp_f(step)));
end

% Plotting response vs concentration (raw response)
rsp_vs_noppm = figure('Name', 'Response vs. Concentration', ...
    'NumberTitle', 'off');
rsp_vs_noppm.WindowState = figure_state;
tiledlayout(1,1)
ax1 = nexttile;
hold(ax1, "on")
legend()
title('Response at Different Added NO Concentration');
subtitle(strcat('Chip ', num2str(CNT_Results_NO(entry).chip) ,', Pads 7-12, 06/16/2022'));
xlabel('NO Concentration');
ylabel('Response');

% Plotting response over time (baseline corrected)
rsp_blc = figure('Name', 'Response - Baseline Corrected', ...
    'NumberTitle', 'off');
rsp_blc.WindowState = figure_state;
tiledlayout(1,1)
ax2 = nexttile;
hold(ax2, "on")
legend()
title('Response Over Time - Baseline Corrected');
subtitle('Chip 5, Pads 7-12, 06/16/2022');
xlabel('Time (s)')
ylabel('Response');
%%
for pad = 7:12
    % pick out data for specific pad
    % r0 =  CNT_Results_NO(entry).r(22000,pad);
    r_pad = CNT_Results_NO(entry).r(:,pad);
    r_pad_wndw = r_pad(run_range);
    
    rsp_raw = figure('Name', "Pad "+pad+" Response - Raw", 'NumberTitle', 'off');
    rsp_raw.WindowState = figure_state;
    plot(time_wndw, r_pad_wndw); hold on;
    
    %　BASELINE CORRECTION
    % Curve fitting on data when there isn't NO exposure
    X = time_wndw(NO_free_indices);
    Y = r_pad_wndw(NO_free_indices);
    [r_pad_wndw_blfit, gof] = fit(X, Y, 'exp1', 'Exclude', Y>2*mean(Y));
    
    % Visual check of fit
    plot(r_pad_wndw_blfit, time_wndw, r_pad_wndw);
    title('Response Before Baseline Correction')
    subtitle("chip " + num2str(CNT_Results_NO(entry).chip) + " - pad " + ...
        num2str(pad) + " - date: " + CNT_Results_NO(entry).addinfo)
    hold off;
    disp(gof)

    % Subtracting baseline from original response data
    r_pad_wndw_bl = r_pad_wndw_blfit(time_wndw);
    r_pad_wndw_blred = r_pad_wndw - r_pad_wndw_bl;
    disp(length(r_pad_wndw_blred))
    [r_pad_wndw_blred_rmol, TF] = rmoutliers(r_pad_wndw_blred, 'mean');
    rm_indices = find(TF);
    time_wndw_rmol = time_wndw;
    time_wndw_rmol(rm_indices) = [];

    disp(length(time_wndw_rmol))
    disp(length(r_pad_wndw_blred_rmol))
    
    rsp_blc = figure('Name', "Pad "+pad+" Response - Baseline Corrected", ...
        'NumberTitle', 'off');
    rsp_blc.WindowState = figure_state;
    if rsp_smooth == true
        r_pad_wndw_blred_rmol = movmean(r_pad_wndw_blred_rmol, 15);
    end
    plot(time_wndw_rmol, r_pad_wndw_blred_rmol)
    title('Response After Baseline Correction')
    subtitle("chip " + num2str(CNT_Results_NO(entry).chip) + " - pad " + ...
        num2str(pad) + " - date: " + CNT_Results_NO(entry).addinfo)
    
    plot(ax2, time_wndw_rmol, r_pad_wndw_blred_rmol, ...
        DisplayName=['Pad ' num2str(pad)])

    % RESPONSE VS CONCENTRATION PLOT DATA
    max_rsp = zeros(size(stp_i));
    for step = 1:length(stp_i)
        max_rsp(step) = max(r_pad_wndw_blred_rmol(stp_i(step):stp_f(step)));   
    end
    plot(ax1, noppm_stp_avg, max_rsp, DisplayName=['Pad ' num2str(pad)])
end

%% CUSTOM FUNCTIONS
% Detect Start of Exposure
function start_indices = detect_start(noppm)
    start_indices = [];
    for i = 16:length(noppm)-15
        if noppm(i) ~= 0
            if noppm(i-15:i-1) ==0
                if noppm(i+1:i+15) ~= 0
                    start_indices = [start_indices; i];
                end
            end
        end
    end
    disp('Found the start of exposures at the following indices:');
    disp(start_indices)
end
% Detect End of Exposure
function end_indices = detect_end(noppm)
    end_indices = [];
    for i = 16:length(noppm)-15
        if noppm(i) == 0
%             if noppm(i+1:i+15) ==0
                if noppm(i-15:i-1) ~= 0
                    end_indices = [end_indices; i];
                end
%             end
        end
    end
    disp('Found the end of exposures at the following indices:');
    disp(end_indices)
end
