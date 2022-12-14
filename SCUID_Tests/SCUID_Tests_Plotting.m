%% About This Script
% This script reads parsed TeraTerm data and makes plots.
% Author: Jerry Chen
% Time Created: Aug 25,2022
% Last Edited:  Oct 27,2022n

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
disp("Data file loaded!")
latest_entry = length(SCUID_Test_Results);
fprintf("The latest entry is No. %i on date: %s.\n", latest_entry, ...
        string(SCUID_Test_Results(latest_entry).TestDate,"yyyy-MM-dd"))
use_latest = input("Do you want to use the latest entry? [Y/n]: ","s");

entry_selected = false;
while ~entry_selected
    if isempty(use_latest) || strcmp(use_latest,"y")
        tgt_entry = latest_entry;
        entry_selected = true;
    elseif strcmp(use_latest,"n")
        disp("Here are the 10 latest entries:")
        PrintTenLatest(SCUID_Test_Results)
        disp("Which one do you want to use? ")
        disp("To use older entries, please check the .mat file.")
        choice = input("Please input entry number (integer only): ");
        entry_valid = false;
        while ~entry_valid
            if choice >=1 && choice <= latest_entry
                fprintf("You picked entry %i.\n",choice)
                tgt_entry = choice;
                entry_valid = true;
            else
                disp("Invalid entry number! Please try again.")
            end
        end
        entry_selected = true;
    else
        disp("Input invalid!")
    end
end

% test_date = datetime(input("When was the data from? [YYYY-MM-DD]: ","s"));

% for entry = 1:length(SCUID_Test_Results)
%     if SCUID_Test_Results(entry,1).TestDate == test_date
%         tgt_entry = entry;
%         break
%     end
% end
% tgt_entry = 13;

%% Plotting
% Time stamp preparation
ts = SCUID_Test_Results(tgt_entry,1).TimeUE;
ts = ts - ts(1);
ts = ts./60;    % Show time in minutes

% Relative Humidity Plot
fig_rh = figure('Name','Relative Humidity');
fig_rh.WindowState = figure_state;
fig_rh.FileName = "RH";
tiledlayout(1,1);
ax_rh = nexttile;
hold(ax_rh,'on');
box off
plot(ts,SCUID_Test_Results(tgt_entry,1).RH,'DisplayName',...
    'Relative Humidity',LineWidth=2);
xlabel(ax_rh,'Time [min]');
ylabel(ax_rh,'Relative Humidity');
legend(ax_rh,'edgecolor','none', 'location','southwest');
hold(ax_rh,'off');

% Temperature Plot
fig_temp = figure('Name','Temperature');
fig_temp.WindowState = figure_state;
fig_temp.FileName = "Temperature";
tiledlayout(1,1);
ax_temp = nexttile;
hold(ax_temp,'on');
plot(ax_temp,ts,SCUID_Test_Results(tgt_entry,1).Temp0,'DisplayName',...
    'Temperature 0');
plot(ax_temp,ts,SCUID_Test_Results(tgt_entry,1).Temp1,'DisplayName',...
    'Temperature 1',LineWidth=2);
xlabel(ax_temp,'Time [min]');
ylabel(ax_temp,['Temperature [' char(176) 'C]']);
legend(ax_temp,'edgecolor','none', 'location','southwest');
hold(ax_temp,'off')

% Pressure Plot
fig_p = figure('Name','Pressure');
fig_p.WindowState = figure_state;
fig_p.FileName = "Pressure";
tiledlayout(1,1);
ax_p = nexttile;
hold(ax_p,'on');
plot(ax_p,ts,SCUID_Test_Results(tgt_entry,1).P0,'DisplayName',...
    'Pressure 0');
plot(ax_p,ts,SCUID_Test_Results(tgt_entry,1).P1,'DisplayName',...
    'Pressure 1',LineWidth=2);
xlabel(ax_p,'Time [min]');
ylabel(ax_p,'Pressure [mBar]');
legend(ax_p,'edgecolor','none', 'location','southwest');
hold(ax_p,'off')

% Oxygen Plot
fig_O2 = figure('Name', "Oxygen");
fig_O2.WindowState = figure_state;
fig_O2.FileName = "Oxygen";
tiledlayout(1,1);
ax_O2 = nexttile;
hold(ax_O2,'on');
plot(ax_O2,ts,SCUID_Test_Results(tgt_entry,1).O2,'DisplayName',...
    'Oxygen',LineWidth=2);
plot(ax_O2,ts,SCUID_Test_Results(tgt_entry,1).O2Sat,'DisplayName',...
    'Oxygen Saturation',LineWidth=2);
xlabel(ax_O2,'Time [min]');
ylabel(ax_O2,'Concentration [%]');
legend(ax_O2,'edgecolor','none', 'location','southwest');
hold(ax_p,'off')

% Sensors 1-6 Plot
fig_sg1 = figure('Name','Sensors 1-6');
fig_sg1.WindowState = figure_state;
fig_sg1.FileName = "S1-6";
tiledlayout(1,1)
ax_sg1 = nexttile;
hold(ax_sg1,'on');
for i = 1:6
    non0 = find(SCUID_Test_Results(tgt_entry,1).Sensors(:,i));
    if isempty(non0)
        non0val = 1;
    else
    non0val = SCUID_Test_Results(tgt_entry,1).Sensors(non0(1,1),i);
    end
    plot(ax_sg1,ts,SCUID_Test_Results(tgt_entry,1).Sensors(:,i)./non0val,...
        'DisplayName',['Sensor Pad ' num2str(i)]);
end
xlabel(ax_sg1,'Time [min]');
ylabel(ax_sg1,"Response")
legend(ax_sg1,'edgecolor','none', 'location','southwest');
hold(ax_sg1,'off');

% Sensors 7-12 Plot
fig_sg2 = figure('Name','Sensors 7-12');
fig_sg2.WindowState = figure_state;
fig_sg2.FileName = "S7-12";
tiledlayout(1,1)
ax_sg2 = nexttile;
hold(ax_sg2,'on');
for i = 7:12
    non0 = find(SCUID_Test_Results(tgt_entry,1).Sensors(:,i));
    if isempty(non0)
        non0val = 1;
    else
    non0val = SCUID_Test_Results(tgt_entry,1).Sensors(non0(1,1),i);
    end
    plot(ax_sg2,ts,SCUID_Test_Results(tgt_entry,1).Sensors(:,i)./non0val,...
        'DisplayName',['Sensor Pad ' num2str(i)]);
end
xlabel(ax_sg2,'Time [min]');
ylabel(ax_sg2,"Response")
legend(ax_sg2,'edgecolor','none', 'location','southwest');
hold(ax_sg2,'off');

% Plotting events x lines
events = SCUID_Test_Results(tgt_entry,1).Events;
for i = 1:length(SCUID_Test_Results(tgt_entry,1).EventTimes)
    event = SCUID_Test_Results(tgt_entry,1).Events(i,1);
    event_time = SCUID_Test_Results(tgt_entry,1).EventTimes(i,1);
    event_time_ue = convertTo(event_time,'posixtime');
    xline_pos = event_time_ue - SCUID_Test_Results(tgt_entry,1).TimeUE(1);
    for ax = [ax_rh ax_temp ax_p ax_O2 ax_sg1 ax_sg2]
        xline(ax,xline_pos./60,'-',event,'HandleVisibility','off') % in Minutes
    end
end

%% Overall Plot Format Settings
all_figs = findall(groot,'type','figure');
all_axes = findall(all_figs,'type','axes');
all_lines = findall(all_figs,'Type','Line');
set(all_axes,'FontSize',20, 'box','off')
all_lgds = findall(all_figs,'type','legend');
set(all_lgds,'edgecolor','none', 'location','southeast');
set(all_lines, 'LineWidth',2, 'MarkerSize',36);
% Setting all the y-axes to black
for i = 1:length(all_axes)
    ax = all_axes(i);
%     disp(length(ax.YAxis))
    for j = 1:length(ax.YAxis)
        ax.YAxis(j).Color = 'k';
    end
end
set(all_figs,"WindowState","normal");
set(all_figs,"Position",[0,360,1500,600])
grid on;

%% Saving Figures
test_date = string(SCUID_Test_Results(tgt_entry).TestDate,"uuuu-MM-dd");
asksave = input("Save all Figures? [Y/n]: ",'s');
switch lower(asksave)
    case {"y",''}
        plotpath = pwd + "/WaterTest_Plots";
        datepath = "/Test_" + num2str(tgt_entry) + "_" + test_date;
        savepath = plotpath + datepath;
        if ~exist(savepath, 'dir')
            disp("There is no such directory:");
            disp(savepath);
            disp("I will create the directory for you.")
            mkdir(savepath)
        end
        for f = 1:length(all_figs)
            this_filename = all_figs(f).FileName;
            if contains(all_figs(f).FileName,".")
                this_filename = this_filename + ".png";
            end
            this_filename = "/Test_" + num2str(tgt_entry,'%03d') + "_" + this_filename;
                                    
            disp("Saving: " + this_filename);
            saveas(all_figs(f),fullfile(savepath, this_filename),'png');
        end
        disp("Figures saved successfully under:")
        disp(savepath)
        set(all_figs,"WindowState","normal");
    otherwise
        set(all_figs,"WindowState","normal");
end       


%% Custom Functions
function PrintTenLatest(DataStructure)
    fprintf("\t\t\tEntry #\t\tTest Date\tChip\tNumber of Events\n")
    latest = length(DataStructure);
    if latest >= 10
        tenth = latest - 9;
    else
        tenth = 1;
    end
    for i = latest:-1:tenth
        date = string(DataStructure(i).TestDate,"yyyy-MM-dd");
        chip = DataStructure(i).Chip;
        event_count = length(DataStructure(i).Events);
        if i==latest
            fprintf("LATEST=>\t%i\t\t\t%s\t%s\t%i\t\n",i,date,chip,event_count)
        else 
            fprintf("\t\t\t%i\t\t\t%s\t%s\t%i\t\n",i,date,chip,event_count)
        end
    end
end