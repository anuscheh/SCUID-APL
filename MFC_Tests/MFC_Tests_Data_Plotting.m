% This script is used to process the raw data from the MFC setup.
% Author: Jerry Chen
% Date Created: 8/31/2022
% Last Updated: 8/31/2022

clear; close all; clc;

%% Settings
% These are settings that are meant to be changed by the user according to 
% needs. 
% - Test Date
target_date = datetime("2022-09-01","Format","uuuu-MM-dd");
% - Target Chip
target_chip = 4;

% Time window settings
t_i = 6000;
t_f = 10000;

% - Automatically find gas exposure ranges from gas concentration readings.
%   If set to false,also specify the desired length in seconds.
auto_expo_range = false;
expo_length = 180;

% - Figure size
fig_size = [1400,600]; % 21:9 aspect ratio

%% Initialization
% Setting figure state variable
fig_pos = [200,200,fig_size];

%% Loading Data
load("CNT_Results_NO.mat")
% Finding entry in struct according to given date & chip
target_entry = get_target_entry(CNT_Results_NO,target_date,target_chip);
this_result = CNT_Results_NO(target_entry,1);

%% Data Processing
% Getting Time Stamps
ts = this_result.timeE - this_result.timeE(1);
ts_range = find(ts >= t_i & ts <= t_f);

% Concentration Data Clean-up
noppm_clean = hampel(this_result.noppm,15);

% Separating the entire data into individual runs
num_runs = 3;
run_length = 3000;
for run = 1:num_runs
    
end


%% Plotting
% RH + Board Temp vs Time (Full)
fig_rh_temp = figure('Name','Relative Humidity & Board Temp vs Time');
fig_rh_temp.Position = fig_pos;
tiledlayout(1,1);
ax_rh_temp = nexttile;
hold(ax_rh_temp,"on");
xlabel(ax_rh_temp,"Time [s]");
legend(ax_rh_temp);
colororder([0.8500 0.3250 0.0980; 0 0.4470 0.7410]) % Orange and Blue
% Temp on left y axis
yyaxis("left");
plot(ax_rh_temp,ts,this_result.boardtemp,DisplayName="Board Temperature");
ylabel(strcat("Temperature [",char(176),"C]"));
% RH on right y axis
yyaxis("right");
plot(ax_rh_temp,ts,this_result.rh,DisplayName="Relative Humidity");
ylabel("Relative Humidity [%]");
hold(ax_rh_temp,"off");

% Board Temp + BME Temp vs Time (Full)
fig_temp_temp = figure('Name','Board Temp & BME Temp');
fig_temp_temp.Position = fig_pos;
tiledlayout(1,1);
ax_temp_temp = nexttile;
hold(ax_temp_temp,"on");
xlabel(ax_temp_temp,"Time [s]");
ylabel(strcat("Temperature [",char(176),"C]"));
legend(ax_temp_temp);
plot(ax_temp_temp,ts,this_result.boardtemp,DisplayName="Board Temperature");
plot(ax_temp_temp,ts,this_result.bmetemp,DisplayName="BME Temperature");
hold(ax_temp_temp,"off");

% Normalized Signal + Concentration vs Time (Full)
fig_rsp_raw = figure('Name','Raw Data & Concentration vs Time');
fig_rsp_raw.Position = fig_pos;
tiledlayout(1,1);
ax_rsp_raw = nexttile;
hold(ax_rsp_raw,"on");
xlabel(ax_rsp_raw,"Time [s]");
% Left y axis for response
yyaxis(ax_rsp_raw,"left");
for pad=7:12
    plot(ax_rsp_raw,ts,this_result.r(:,pad),...
        DisplayName=strcat("Pad ",num2str(pad)),LineWidth=2);
end
colororder(ax_rsp_raw,'default');
ylabel(ax_rsp_raw,"Response [UNIT]");
% Right y axis for concentration
yyaxis(ax_rsp_raw,"right");
plot(ax_rsp_raw,ts,noppm_clean,DisplayName='NO Concentration',Color="k");
ylabel(ax_rsp_raw,"NO Concentration [ppm]");
legend(ax_rsp_raw,'NumColumns',2);

% Normalized Signal + Concentration vs Time (One Run,Pick Run 2,)

% Baseline Corrected Signal + Concentration vs Time (Each Run)

% Response vs Concentration (Pads 7-12,Each Run)


%% Overall Plot Format Settings
all_figs = findall(groot,'type','figure');
all_axes = findall(all_figs,'type','axes');
set(all_axes,'FontSize',20, 'box','off')
all_lgds = findall(all_figs,'type','legend');
set(all_lgds,'edgecolor','none', 'location','northeast');


%% Custom Functions
% Find the desired entry in the struct
function target_entry = get_target_entry(Data_Struct,target_date,target_chip)
    for entry = 1:length(Data_Struct)
        if isempty(Data_Struct(entry,1).testdateM)
            continue
        elseif contains(datestr(Data_Struct(entry,1).testdateM),datestr(target_date))
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