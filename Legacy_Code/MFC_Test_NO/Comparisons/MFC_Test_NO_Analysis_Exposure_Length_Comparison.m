%% OPTIONS
clear; close all; clc;
% Some Options
% entry index in struct.
entry = 18;
% - Ignore result of relative humidity check. If true, the program will
%       proceed even if relative humidity is not zero.
ignore_rh_chk = true;
% - Enable/disable response data smoothing (using movmean)
rsp_smooth = true;
% - Enable/disable manual step width (in seconds)
step_man_range = true;
% step_man_width = 180;
% - Hide/Show Figures:
minimize_figures = false;
if minimize_figures == true
    figure_state = "minimized";
else
    figure_state = "maximized";
end
% - Time window finding method: 
% ----- true  = auto define from flow file info
% ----- false = manually pick window
time_wndw_auto_find = false;
% ----- If use auto find, please fill in the following flow file info

if time_wndw_auto_find == true
    n_run = 3;                  % number of runs
    n_expo = 7;                 % number of total exposures per run
    t_expo = 1 * 60;            % exposure duration in seconds
    t_pre_purge = 10 * 60;      % pre-purge time in seconds
    t_exp_purge = 5 * 60;       % purge time after each exposure in seconds
    t_post_purge = 10 * 60;     % purge time after the last run is done
    t_i = t_pre_purge + n_expo * (t_expo + t_exp_purge) + t_post_purge;
    t_f = t_i + t_pre_purge + n_expo * (t_expo + t_exp_purge) + t_post_purge;
else
    % ----- If use manual find, define the time window in seconds below.
    t_i = 3.8 * 60 * 60;
    t_f = 4.8 * 60 * 60;
end

% ==========> Comparison Settings <==========
movmean_k = 30;
exposure_length = [60; 120; 180; 240];
designated_pad = 12;

%% LOADING DATA

% I put the .mat file in the same directory as this script. Make sure you
% specify the directory when you use this script.
data_loc = cd;
data_loc = fullfile(data_loc, '..');
load(fullfile(data_loc, "CNT_Results_NO.mat"))


%% Moving mean range comparison figures
exp_len_comp_rvc = figure('Name', ...
    'Exposure Length Comparison - Response vs. Concentration', ...
    'NumberTitle', 'off');
exp_len_comp_rvc.WindowState = figure_state;
tiledlayout(1,1)
ax4 = nexttile;
hold(ax4, "on")
legend()
title({'Response vs. Concentration', 'Using Different Lengths of Time', ...
    'for Mean Concentration'});
subtitle({"Chip " + num2str(CNT_Results_NO(entry).chip) + " Pad " + ...
    designated_pad + ", " + CNT_Results_NO(entry).addinfo, 'Moving Mean with 30 points'});
xlabel('NO Concentration')
ylabel('Response');
ax4.FontSize = 16;

exp_len_comp_rvt = figure('Name', ...
    'Exposure Length Comparison - Response vs. Time', ...
    'NumberTitle', 'off');
exp_len_comp_rvt.WindowState = figure_state;
tiledlayout(1,1)
ax5 = nexttile;
hold(ax5, "on")
legend()
title({'Response vs. Time', 'Using Different Lengths of Time', ...
    'for Mean Concentration'});
subtitle({"Chip " + num2str(CNT_Results_NO(entry).chip) + " Pad " + ...
    designated_pad + ", " + CNT_Results_NO(entry).addinfo, 'Moving Mean with 30 points'});
xlabel('Time')
ylabel('Response');
ax5.FontSize = 16;

%% DATA PROCESSING
% Define start of collection to be zero second.
time = CNT_Results_NO(entry).timeE - CNT_Results_NO(entry).timeE(1);
% define the time window interested
run_range = find(time >= t_i & time <= t_f);
% pick out that time period
time_wndw = time(run_range);
% Check relative humidity within the time period. If not consistently zero,
% notify. 
if mean(CNT_Results_NO(entry).rh) ~= 0
    disp('Relative Humidity is NOT consistently zero!')
    if ignore_rh_chk == false
        disp('The script will terminate itself due to non-zero RH!')
        return
    else
        disp('You asked to ignore non-zero RH!')
        disp('The script will proceed!')
    end
else
    disp('Relative Humidity is consistently zero.')
end


% pick out concentration data in that period
noppm_wndw = CNT_Results_NO(entry).noppm(run_range);
NO_free_indices = find(~noppm_wndw);

% Process the noppm data to remove pre-spikes.
% noppm_spike = figure('Name', 'NO Spike Removal', 'NumberTitle', 'off');
% noppm_spike.WindowState = figure_state;
% plot(time_wndw, noppm_wndw, 'r-'); hold on;

noppm_wndw_rmspk = hampel(noppm_wndw, 15);
% plot(time_wndw, noppm_wndw_rmspk, 'b-', LineWidth=2); 
% title('NO Concentration over time')
% legend('Original Data', 'Pre-Spikes Removed')
% xlabel('Time (s)')
% ylabel('Concentration')
% hold off

% Auto detect start and end of exposure
stp_i = detect_start(noppm_wndw_rmspk);
disp('beginings')
disp(stp_i)
stp_f = zeros(size(stp_i));
% if step_man_range == false
%     stp_f = detect_end(noppm_wndw_rmspk);
% else
%     for stp = 1:length(stp_i)
%         [~, end_ind] = min(abs((time_wndw(stp_i(stp)) + step_man_width)-time_wndw));
%         stp_f(stp) = end_ind;
%     end
%     disp('endings')
%     disp(stp_f)
% end
% disp('intervals')
% disp(time_wndw(stp_f) - time_wndw(stp_i))
%%
for pad = designated_pad

    % pick out response data for specific pad
    r_pad = CNT_Results_NO(entry).r(:,pad);
    r_pad_wndw = r_pad(run_range);

    % normalize data using r0 = response at end of pre-purge
    r0 = r_pad_wndw(stp_i(1)-10);
    r_pad_wndw_norm = (r_pad_wndw)./r0 * 100;
   
    %　BASELINE CORRECTION
    % Curve fitting on data when there isn't NO exposure
    X = time_wndw(NO_free_indices);
    Y = r_pad_wndw_norm(NO_free_indices);
    [r_pad_wndw_blfit, gof] = fit(X, Y, 'exp1');
    disp(gof)

    % Subtracting baseline from original response data
    r_pad_wndw_bl = r_pad_wndw_blfit(time_wndw);
    r_pad_wndw_blred = r_pad_wndw_norm - r_pad_wndw_bl;
    disp(length(r_pad_wndw_blred))
    [r_pad_wndw_blred_rmol, TF] = rmoutliers(r_pad_wndw_blred, 'mean');
    rm_indices = find(TF);
    time_wndw_rmol = time_wndw;
    time_wndw_rmol(rm_indices) = [];

    disp(length(time_wndw_rmol))
    disp(length(r_pad_wndw_blred_rmol))

    % Response Data Smoothening
    r_pad_wndw_blred_rmol_smth = r_pad_wndw_blred_rmol;
    if rsp_smooth == true
        r_pad_wndw_blred_rmol_smth = movmean(r_pad_wndw_blred_rmol_smth, movmean_k);
    end
    
    % Plot Response over time curve (same for all)
    plot(ax5, time_wndw_rmol, r_pad_wndw_blred_rmol_smth, 'k', ...
        DisplayName = ['Response (movmean k=', num2str(movmean_k), ')'], LineWidth= 1.5)

    % Plot each exposure length.
    for j = 1:length(exposure_length)
        disp("current exposure length is")
        disp(exposure_length(j,1))

        % Define End of Step
        for stp = 1:length(stp_i)
            [~, end_ind] = min(abs((time_wndw(stp_i(stp)) + exposure_length(j,1))-time_wndw));
            stp_f(stp) = end_ind;
        end

        % average concentration within each exposure
        noppm_stp_avg = zeros(size(stp_i));
        for step = 1:length(stp_i)
            noppm_stp_avg(step) = mean(noppm_wndw_rmspk(stp_i(step):stp_f(step)));
        end
        
        % Responses at end of defined length
        end_rsp = r_pad_wndw_blred_rmol_smth(stp_f);
        disp('========> Response value picked are:')
        disp(end_rsp)

        plot(ax4, noppm_stp_avg, end_rsp, '.-', MarkerSize=18, ...
            DisplayName = strcat("length=", num2str(exposure_length(j,1)), ...
            ' seconds'), LineWidth= 1.5)

        
        
        plot(ax5, time_wndw_rmol(stp_f), end_rsp, '*', MarkerSize=24, ...
            DisplayName = strcat('R sample point for length=', ...
            num2str(exposure_length(j,1)), ' seconds'), LineWidth= 1.5)
    end
%     color_reorder = colororder(ax5);
%     color_reorder = kron(color_reorder,ones(2,1));
%     disp(color_reorder)
%     colororder(ax5, color_reorder)
end

%% Saving Figure(s)
figfilename1 = ['/MFC_Test_NO_Analysis_Exposure_Length_Comparison_Results/chip_' num2str(CNT_Results_NO(entry).chip) '_pad_'  num2str(designated_pad)  '_rvc.png'];
saveas(exp_len_comp_rvc,[pwd figfilename1]);
figfilename2 = ['/MFC_Test_NO_Analysis_Exposure_Length_Comparison_Results/chip_' num2str(CNT_Results_NO(entry).chip) '_pad_'  num2str(designated_pad)  '_rvt.png'];
saveas(exp_len_comp_rvt,[pwd figfilename2]);

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
