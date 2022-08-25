%% About This Script
% This script reads parsed TeraTerm data and makes plots.
% Author: Jerry Chen
% Time Created: August 25, 2022
% Last Edited:  August 25, 2022

clear; close all; clc;

%% Loading Data
load('SCUID_Test_Results.mat')

% Change this date to the date of test you want
test_date = datetime('2022-08-10');

target_entry = 0;
for entry = 1:length(SCUID_Test_Results)
    if SCUID_Test_Results(entry,1).TestDate == test_date
        target_entry = entry;
        break
    end
end

%% Plotting
% Time stamp preparation
ts = SCUID_Test_Results(target_entry, 1).TimeUE;
ts = ts - ts(1);

% Relative Humidity Plot
fig_rh = figure('Name', 'Relative Humidity');
fontsize(fig_rh, 20, 'points');
tiledlayout(1,1);
ax_rh = nexttile;
hold(ax_rh, 'on');
plot(ts, SCUID_Test_Results(target_entry,1).RH, 'DisplayName', ...
    'Relative Humidity', LineWidth=2);
xlabel(ax_rh, 'Time [s]');
ylabel(ax_rh, 'Relative Humidity');
legend();
hold(ax_rh, 'off');

% Temperature Plot
fig_temp = figure('Name', 'Temperature');
fontsize(fig_temp, 20, 'points');
tiledlayout(1,1);
ax_temp = nexttile;
hold(ax_temp, 'on');
plot(ts, SCUID_Test_Results(target_entry,1).Temp0, 'DisplayName', ...
    'Temperature 0');
plot(ts, SCUID_Test_Results(target_entry,1).Temp1, 'DisplayName', ...
    'Temperature 1');
xlabel(ax_temp, 'Time [s]');
ylabel(ax_temp, ['Temperature [' char(176) 'C]']);
legend();
hold(ax_temp, 'off')

% Pressure Plot
%fig_p = figure('Name', 'Pressure');

% Sensors 1-6 Plot
fig_sa = figure('Name', 'Sensors 1-6');
fontsize(fig_sa, 20, 'points');
tiledlayout(1,1)


% Sensors 7-12 Plot


