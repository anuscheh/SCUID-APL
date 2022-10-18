%% About This Script
% This script reads parsed TeraTerm data and makes plots.
% Author: Jerry Chen
% Time Created: August 25,2022
% Last Edited:  August 25,2022

clear; close all; clc;

%% Global Configurations
% Hide/Show Figures:
minimize_figures = false;   % Change this only
if minimize_figures == true
    figure_state = "minimized";
else
    figure_state = "maximized";
end

% Save figures automatically
auto_save = false;

%% Loading Data
load('SCUID_Test_Results.mat')

% Change this date to the date of test you want
% test_date = datetime('2022-09-01');
test_date = datetime(input("When was the data from? [YYYY-MM-DD]: ","s"));

for entry = 1:length(SCUID_Test_Results)
    if SCUID_Test_Results(entry,1).TestDate == test_date
        tgt_entry = entry;
        break
    end
end
tgt_entry = 7;

%% Plotting
% Time stamp preparation
ts = SCUID_Test_Results(tgt_entry,1).TimeUE;
ts = ts - ts(1);

% Relative Humidity Plot
fig_rh = figure('Name','Relative Humidity');
fig_rh.WindowState = figure_state;
tiledlayout(1,1);
ax_rh = nexttile;
hold(ax_rh,'on');
box off
plot(ts,SCUID_Test_Results(tgt_entry,1).RH,'DisplayName',...
    'Relative Humidity',LineWidth=2);
xlabel(ax_rh,'Time [s]');
ylabel(ax_rh,'Relative Humidity');
legend(ax_rh,'edgecolor','none', 'location','northeast');
%fontsize(fig_rh,20,'points');
hold(ax_rh,'off');

% Temperature Plot
fig_temp = figure('Name','Temperature');
fig_temp.WindowState = figure_state;
tiledlayout(1,1);
ax_temp = nexttile;
hold(ax_temp,'on');
plot(ax_temp,ts,SCUID_Test_Results(tgt_entry,1).Temp0,'DisplayName',...
    'Temperature 0');
plot(ax_temp,ts,SCUID_Test_Results(tgt_entry,1).Temp1,'DisplayName',...
    'Temperature 1',LineWidth=2);
xlabel(ax_temp,'Time [s]');
ylabel(ax_temp,['Temperature [' char(176) 'C]']);
legend(ax_temp,'edgecolor','none', 'location','northeast');
%fontsize(fig_temp,20,'points');
hold(ax_temp,'off')

% Pressure Plot
fig_p = figure('Name','Pressure');
fig_p.WindowState = figure_state;
tiledlayout(1,1);
ax_p = nexttile;
hold(ax_p,'on');
plot(ax_p,ts,SCUID_Test_Results(tgt_entry,1).P0,'DisplayName',...
    'Pressure 0');
plot(ax_p,ts,SCUID_Test_Results(tgt_entry,1).P1,'DisplayName',...
    'Pressure 1',LineWidth=2);
xlabel(ax_p,'Time [s]');
ylabel(ax_p,'Pressure [mBar]');
legend(ax_p,'edgecolor','none', 'location','northeast');
%fontsize(fig_p,20,'points');
hold(ax_p,'off')

% Sensors 1-6 Plot
fig_sg1 = figure('Name','Sensors 1-6');
fig_sg1.WindowState = figure_state;
tiledlayout(1,1)
ax_sg1 = nexttile;
hold(ax_sg1,'on');
for i = 1:6
    plot(ax_sg1,ts,SCUID_Test_Results(tgt_entry,1).Sensors(:,i)./SCUID_Test_Results(tgt_entry,1).Sensors(1,i),...
        'DisplayName',['Sensor Pad ' num2str(i)]);
end
xlabel(ax_sg1,'Time [s]');
ylabel(ax_sg1,"Response")
legend(ax_sg1,'edgecolor','none', 'location','northeast');
%fontsize(fig_sg1,20,'points');
hold(ax_sg1,'off');

% Sensors 7-12 Plot
fig_sg2 = figure('Name','Sensors 7-12');
fig_sg2.WindowState = figure_state;
tiledlayout(1,1)
ax_sg2 = nexttile;
hold(ax_sg2,'on');
for i = 7:12
    plot(ax_sg2,ts,SCUID_Test_Results(tgt_entry,1).Sensors(:,i)./SCUID_Test_Results(tgt_entry,1).Sensors(1,i),...
        'DisplayName',['Sensor Pad ' num2str(i)]);
end
xlabel(ax_sg2,'Time [s]');
ylabel(ax_sg2,"Response")
legend(ax_sg2,'edgecolor','none', 'location','northeast');
%fontsize(fig_sg2,20,'points');
hold(ax_sg2,'off');

% Plotting injection x lines
gas_type = SCUID_Test_Results(tgt_entry,1).GasType;
for i = 1:length(SCUID_Test_Results(tgt_entry,1).InjectionTime)
    time_inj = SCUID_Test_Results(tgt_entry,1).InjectionTime(i,1);
    time_inj_ue = convertTo(time_inj,'posixtime');
    xline_pos = time_inj_ue - SCUID_Test_Results(tgt_entry,1).TimeUE(1);
    for ax = [ax_rh ax_temp ax_p ax_sg1 ax_sg2]
        display_name = strcat(gas_type," Injection ",num2str(i));
        xline(ax,xline_pos,'-',display_name)%,...
            %FontSize=20,LineWidth=2,HandleVisibility='off')
    end
end

%% Saving figures
if auto_save
    % TBD: automatically save all figures into folders. 
    % Working on folder naming scheme.
end