% This script is used to process the raw data from the MFC setup.
% Author: Jerry Chen
% Date Created: 8/31/2022
% Last Updated: 8/31/2022

clear; close all; clc;

%% Settings
% These are settings that are meant to be changed by the user according to 
% needs. 
% - Test Date
target_date = datetime("2022-07-11","Format","uuuu-MM-dd");
% - Target Chip
target_chip = 3;

% Time window settings
t_i = 6000;
t_f = 10000;

% - Automatically find gas exposure ranges from gas concentration readings.
%   If set to false, also specify the desired length in seconds.
auto_expo_range = false;
expo_length = 180;

% - Hide/Show Figures:
minimize_figures = false;

%% Initialization
% Setting figure state variable
fig_pos = [200,200,2100,900];

%% Loading Data
load("CNT_Results_NO.mat")

target_entry = get_target_entry(CNT_Results_NO, target_date, target_chip);

target_result = CNT_Results_NO(target_entry,1);

%% Getting Time Stamps
ts = target_result.timeE - target_result.timeE(1);
ts_range = find(ts >= t_i & ts <= t_f);

%% Concentration Data Clean-up
noppm_clean = hampel(target_result.noppm, 15);



%% Plotting
% Raw Signal + Concentration vs Time (Entire Test)
fig_rsp_raw = figure('Name', 'Raw Data & Concentration vs. Time');
fig_rsp_raw.Position = fig_pos;
tiledlayout(1,1);
ax_rsp_raw = nexttile;
hold(ax_rsp_raw, "on");
fontsize(ax_rsp_raw, 20, "points");
xlabel(ax_rsp_raw, "Time [s]");
box off;
% Left y axis for response
yyaxis(ax_rsp_raw, "left");
for pad=7:12
    plot(ax_rsp_raw, ts, target_result.r(:,pad), ...
        DisplayName=strcat("Pad ", num2str(pad)),LineWidth=2);
end
colororder(ax_rsp_raw, 'default');
ylabel(ax_rsp_raw, "Response [UNIT]");
% Right y axis for concentration
yyaxis(ax_rsp_raw, "right");
plot(ax_rsp_raw, ts, noppm_clean, DisplayName='NO Concentration',Color="k");
ylabel(ax_rsp_raw, "NO Concentration [ppm]");
legend(ax_rsp_raw, Location='northeast', EdgeColor='none');

% Raw Signal + Concentration vs Time (One Run)

% Relative Humidity + Temperature vs Time (Entire Test)

% Relative Humidity + Temperature vs Time (One Run)

% Normalized Signal + Concentration vs Time (One Run)

% Baseline Corrected Signal + Concentration vs Time (One Run)

% Response vs Concentration (Pads 7-12, One Run)

% Response vs Concentration (One Pad, Three Runs)


%% Custom Functions
% Find the desired entry in the struct
function target_entry = get_target_entry(Data_Struct, target_date, target_chip)
    for entry = 1:length(Data_Struct)
        if isempty(Data_Struct(entry,1).testdateM)
            continue
        elseif contains(datestr(Data_Struct(entry,1).testdateM), datestr(target_date))
            if Data_Struct(entry,1).chip == target_chip
                target_entry = entry;
                break
            end
        end
    end
end
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