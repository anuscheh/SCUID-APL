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
% - Pads info
num_pads = 12;
target_pads = 7:12;

% Time window settings
num_runs = 3;
num_steps = 7; % number of steps per run
run_length = 6600;
step_length = 600;

% - Automatically find gas exposure ranges from gas concentration readings.
%   If set to false, also specify the desired sample length in seconds.
auto_expo_range = false;
sample_length = 180;

% - Figure size
fig_size = [1400,600]; % 21:9 aspect ratio

%% Initialization
% Setting figure state variable
fig_pos = [200,200,fig_size];

%% Loading Data
load("CNT_Results_NO.mat")
% Finding entry in struct according to given date & chip
target_entry = get_target_entry(CNT_Results_NO,target_date,target_chip);
entry_result = CNT_Results_NO(target_entry,1);

%% Data Processing
% Getting Time Stamps
ts = entry_result.timeE - entry_result.timeE(1);

% Concentration Data Clean-up
conc_clean = hampel(entry_result.noppm,15);
conc_clean(isnan(conc_clean)) = 0;

% Separating the entire data into individual runs
run_ranges = cell(3,1);
for run = 1:num_runs-1
    ts_i = (run-1)*6600;
    ts_f = ts_i + 6600;
    run_ranges{run} = find(ts >= ts_i & ts <= ts_f);
end
run_ranges{num_runs} = find(ts >= (num_runs-1)*6600);

% Auto detecting start and end of exposure steps
stp_i = detect_start(conc_clean,ts,step_length);
stp_f = zeros(size(stp_i));
if auto_expo_range
    stp_f = detect_end(conc_clean);
else
    for stp = 1:length(stp_i)
        [~, end_ind] = min(abs((ts(stp_i(stp)) + sample_length)-ts));
        stp_f(stp) = end_ind;
    end
end
% Reshaping these vectors into [run by step] matrices for easier use.
stp_i = reshape(stp_i,num_steps,num_runs);
stp_f = reshape(stp_f,num_steps,num_runs);

% Testing if number of steps matches designed
if isequal(size(stp_i), [num_steps num_runs])
    disp("Detected step starting indices matches actual steps!")
else
    input("Unmatch!")
end

% Performing Baseline Correction for each run
r_blc = size(entry_result.r);
for run = 1:num_runs
    % Time stamps for this run
    ts_run = ts(run_ranges{run,1});
    % Indices corresponding to non-exposure
    conc_run = conc_clean(run_ranges{run,1});
    non_expo_indices = find(~conc_run);
    % baseline correction for each pad
    for pad = target_pads
        % Finding baseline by fitting to part of response with no exposure
        X = ts_run(non_expo_indices);
        r0_pad = entry_result.r(stp_i(1,run)-5,pad);
        r_norm_pad = entry_result.r(run_ranges{run,1},pad)/r0_pad;
        Y = r_norm_pad(non_expo_indices);
        [r_fit_pad, gof] = fit(X, Y, 'exp1');
        baseline_pad = r_fit_pad(ts_run);
        % Subtracting baseline from original response data
        r_blc(run_ranges{run,1},pad) = r_norm_pad - baseline_pad;
    end
end

% Calculating average concentration within each exposure step
% and response at the sample point within each step (at 3 mins)
conc_stp_avg = zeros(size(stp_i));
for run = 1:num_runs
    for step = 1:num_steps
        sample_range = stp_i(step,run):stp_f(step,run);
        conc_stp_avg(step,run) = mean(conc_clean(sample_range));
    end
end

% Finding sample values of baseline-corrected rsponse to be used in the 
% response vs concentration plot
r_samples= reshape(r_blc(stp_f,:), [num_steps num_runs num_pads]);

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
plot(ax_rh_temp,ts,entry_result.boardtemp,DisplayName="Board Temperature");
ylabel(strcat("Temperature [",char(176),"C]"));
% RH on right y axis
yyaxis("right");
plot(ax_rh_temp,ts,entry_result.rh,DisplayName="Relative Humidity");
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
plot(ax_temp_temp,ts,entry_result.boardtemp,DisplayName="Board Temperature");
plot(ax_temp_temp,ts,entry_result.bmetemp,DisplayName="BME Temperature");
hold(ax_temp_temp,"off");

% Normalized Signal + Concentration vs Time (Full)
fig_rsp_norm = figure('Name','Normalized Data & Concentration vs Time');
fig_rsp_norm.Position = fig_pos;
tiledlayout(1,1);
ax_rsp_norm = nexttile;
hold(ax_rsp_norm,"on");
xlabel(ax_rsp_norm,"Time [s]");
% Left y axis for response
yyaxis(ax_rsp_norm,"left");
for pad = target_pads
    r0 = entry_result.r(stp_i(1,1)-5,pad);
    plot(ax_rsp_norm,ts,entry_result.r(:,pad)/r0,...
        DisplayName=strcat("Pad ",num2str(pad)),LineWidth=2);
end
colororder(ax_rsp_norm,'default');
ylabel(ax_rsp_norm,"R/R_0");
% Right y axis for concentration
yyaxis(ax_rsp_norm,"right");
plot(ax_rsp_norm,ts,conc_clean,DisplayName='NO Concentration',Color="k");
ylabel(ax_rsp_norm,"NO Concentration [ppm]");
legend(ax_rsp_norm,'NumColumns',2);

% Normalized Signal + Concentration vs Time (One Run,Pick Run 2)
run_pick = 2;
fig_rsp_run_norm = figure('Name', "Normalized Data & Concentration " + ...
    "vs Time - Run " + num2str(run_pick));
fig_rsp_run_norm.Position = fig_pos;
tiledlayout(1,1);
ax_rsp_run_norm = nexttile;
hold(ax_rsp_run_norm,"on");
xlabel(ax_rsp_run_norm,"Time [s]");
% Left y axis for response
yyaxis(ax_rsp_run_norm,"left");
for pad = target_pads
    r0 = entry_result.r(stp_i(1,run_pick)-5,pad);
    plot(ax_rsp_run_norm,ts(run_ranges{run_pick}), ...
        entry_result.r(run_ranges{run_pick},pad)/r0,...
        DisplayName=strcat("Pad ",num2str(pad)),LineWidth=2);
end
colororder(ax_rsp_run_norm,'default');
ylabel(ax_rsp_run_norm,"R/R_0");
% Right y axis for concentration
yyaxis(ax_rsp_run_norm,"right");
plot(ax_rsp_run_norm,ts(run_ranges{run_pick}), ...
    conc_clean(run_ranges{run_pick}),DisplayName='NO Concentration',Color="k");
ylabel(ax_rsp_run_norm,"NO Concentration [ppm]");
legend(ax_rsp_run_norm,'NumColumns',2);


% Baseline Corrected Signal + Concentration vs Time (Each Run)
fig_rsp_blc = gobjects(num_runs,1);
for run = 1:num_runs
    fig_rsp_blc(run) = figure('Name', ...
        strcat("Response vs Time - Run ",num2str(run), ...
        " - Baseline Corrected"));
    fig_rsp_blc(run).Position = fig_pos;
    tiledlayout(1,1);
    ax_rsp_blc = nexttile;
    hold(ax_rsp_blc,"on");
    xlabel(ax_rsp_blc,"Time [s]");
    % Left y axis for response
    yyaxis(ax_rsp_blc,"left");    
    for pad = target_pads
        plot(ax_rsp_blc,ts(run_ranges{run,1}),r_blc(run_ranges{run,1}, pad), ...
            DisplayName=strcat("Pad ",num2str(pad)),LineWidth=2,LineStyle="-");
    end
    colororder(ax_rsp_blc,"default")
    ylabel(ax_rsp_blc,"R/R_0")
    % Right y axis for concentration
    yyaxis(ax_rsp_blc,"right")
    plot(ax_rsp_blc,ts(run_ranges{run}),conc_clean(run_ranges{run}), ...
        DisplayName='NO Concentration',Color="k",LineStyle="--");
    ylabel(ax_rsp_blc,"NO Concentration [ppm]");
    legend(ax_rsp_blc,'NumColumns',2)
    hold(ax_rsp_blc,"off")
end


% Response vs Concentration (Pads 7-12,Each Run)
fig_rvc = gobjects(num_runs,1);
for run = 1:num_runs
    fig_rvc(run) = figure('Name', ...
        strcat("Response vs Concentration - Run ",num2str(run), ...
        " - Baseline Corrected"));
    fig_rvc(run).Position = fig_pos;
    tiledlayout(1,1);
    ax_rvc = nexttile;
    hold(ax_rvc,"on");
    xlabel(ax_rvc,"Concentration [ppm]");
    ylabel(ax_rvc,"R/R_0")
    
    for pad = target_pads
        plot(ax_rvc,conc_stp_avg(:,run), r_samples(:,run,pad),':o',...
            DisplayName=strcat("Pad ",num2str(pad)));
    end
    legend(ax_rvc,'NumColumns',2)
    hold(ax_rvc,"off")
end

% r_samples = zeros(stp_f);
% for run = 1:num_runs
%     for step = 1:num_steps
%         r_samples(step,run) = 

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
function start_indices = detect_start(conc, time_stamp, step_length)
    start_indices = [];
    for i = 16:length(conc)-15
        if conc(i) ~= 0
            if conc(i-15:i-1) ==0
                if conc(i+1:i+15) ~= 0
                    start_indices = [start_indices; i];
                end
            end
        end
    end
%     disp('Found the start of exposures at the following indices:');
%     disp(start_indices)
    % Cleaning off indices that are too close to each other. This usually
    % happens at the beginning of each exposure step where the MFCs would
    % over-react when openning up and then close for a brief while within
    % the supposed exposure period. It looks like a hole/well/crack within
    % each exposure step on the plot.
    % First, calculate the differences in seconds between each consecutive
    % marked indices.
    start_times = time_stamp(start_indices);
    separations = diff(start_times);
%     disp('Time separations between detected step starting points:')
%     disp(separations)
    start_indices(find(separations<step_length)+1) = [];
%     disp("Fixed start indices:")
%     disp(start_indices)
end

% Detect End of Exposure
function end_indices = detect_end(conc)
    end_indices = [];
    for i = 16:length(conc)-15
        if conc(i) == 0
%             if noppm(i+1:i+15) ==0
                if conc(i-15:i-1) ~= 0
                    end_indices = [end_indices; i];
                end
%             end
        end
    end
    disp('Found the end of exposures at the following indices:');
    disp(end_indices)
end