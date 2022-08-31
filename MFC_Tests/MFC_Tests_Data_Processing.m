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
if minimize_figures == true
    figure_state = "minimized";
else
    figure_state = "normal";
end

%% Loading Data
load("CNT_Results_NO.mat")

target_entry = get_target_entry(CNT_Results_NO, target_date, target_chip);

target_result = CNT_Results_NO(target_entry,1);

%% Getting Time Stamps
ts = target_result.timeE - target_result.timeE(1);
ts_range = find(ts >= t_i & ts <= t_f);

%% Plotting
plot(ts, movmean(target_result.r(:,7),15))
plot(ts(ts_range), movmean(target_result.r(ts_range,7), 15))

%% Custom Functions
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