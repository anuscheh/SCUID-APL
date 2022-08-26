%% About This Script
% This script reads parsed TeraTerm data and makes plots.
% Author: Jerry Chen
% Time Created: August 25, 2022
% Last Edited:  August 25, 2022

clear; close all; clc;

%% Global Configurations
% Hide/Show Figures:
minimize_figures = false;   % Change this only
if minimize_figures == true
    figure_state = "minimized";
else
    figure_state = "maximized";
end

%% Loading Data
load('SCUID_Test_Results.mat')

% Change this date to the date of test you want
test_date = datetime('2022-08-10');

tgt_entry = 0;
for entry = 1:length(SCUID_Test_Results)
    if SCUID_Test_Results(entry,1).TestDate == test_date
        tgt_entry = entry;
        break
    end
end

%% Plotting
% Time stamp preparation
ts = SCUID_Test_Results(tgt_entry, 1).TimeUE;
ts = ts - ts(1);

% Relative Humidity Plot
fig_rh = figure('Name', 'Relative Humidity');
fig_rh.WindowState = figure_state;
tiledlayout(1,1);
ax_rh = nexttile;
hold(ax_rh, 'on');
box off
plot(ts, SCUID_Test_Results(tgt_entry,1).RH, 'DisplayName', ...
    'Relative Humidity', LineWidth=2);
xlabel(ax_rh, 'Time [s]');
ylabel(ax_rh, 'Relative Humidity');
legend(ax_rh, 'boxoff');
fontsize(ax_rh, 20, 'points');
hold(ax_rh, 'off');

% Temperature Plot
fig_temp = figure('Name', 'Temperature');
fig_temp.WindowState = figure_state;
tiledlayout(1,1);
ax_temp = nexttile;
hold(ax_temp, 'on');
plot(ax_temp, ts, SCUID_Test_Results(tgt_entry,1).Temp0, 'DisplayName', ...
    'Temperature 0');
plot(ax_temp, ts, SCUID_Test_Results(tgt_entry,1).Temp1, 'DisplayName', ...
    'Temperature 1');
xlabel(ax_temp, 'Time [s]');
ylabel(ax_temp, ['Temperature [' char(176) 'C]']);
legend(ax_temp, 'boxoff');
fontsize(ax_temp, 20, 'points');
hold(ax_temp, 'off')

% Pressure Plot
%fig_p = figure('Name', 'Pressure');

% Sensors 1-6 Plot
fig_sg1 = figure('Name', 'Sensors 1-6');
fig_sg1.WindowState = figure_state;
tiledlayout(1,1)
ax_sg1 = nexttile;
hold(ax_sg1, 'on');
for i = 1:6
    plot(ax_sg1, ts, SCUID_Test_Results(tgt_entry,1).Sensors(:,i), ...
        'DisplayName', ['Sensor Pad ' num2str(i)]);
end
legend(ax_sg1, 'boxoff');
fontsize(ax_sg1, 20, 'points');
hold(ax_sg1, 'off');

% Sensors 7-12 Plot
fig_sg2 = figure('Name', 'Sensors 7-12');
fig_sg2.WindowState = figure_state;
tiledlayout(1,1)
ax_sg2 = nexttile;
hold(ax_sg2, 'on');
for i = 7:12
    plot(ax_sg2, ts, SCUID_Test_Results(tgt_entry,1).Sensors(:,i), ...
        'DisplayName', ['Sensor Pad ' num2str(i)]);
end
legend(ax_sg2, 'boxoff');
fontsize(ax_sg2, 20, 'points');
hold(ax_sg2, 'off');

