%% About This Script
% This script reads TeraTerm Logs from the SCUID setup and converts it into
% easy-to-process data.
% Author: Jerry Chen
% Time Created: August 11, 2022
% Last Edited:  August 25, 2022

clear; close all; clc;
%% General Parameters
% Name of the .mat data file (stores parsed data)
data_file_name = "SCUID_Test_Results.mat";
% Number of sensors on each chip (default = 12)
sensor_count = 12;

%% Intro
fprintf("Welcome to Jerry's new TeraTerm Log Parsing Script for SCUID ")
fprintf("water test.\nIf you would like to stop at any time, hit ")
cprintf('blue', 'Ctrl + C')
cprintf('text', " to abort the script.\n")
input("Press any key to continue.\n")

%% Reading Log File
% log_file_name = "test_log.txt";
% Prompting user to input log file name.
log_raw_lines = string.empty;
while isempty(log_raw_lines)
    log_file= input("Type log file name here, " + ...
        "or hit ENTER to choose a file: ","s");
    if isempty(log_file)
        [file, path] = uigetfile({'*'});
        log_file = fullfile(path, file);
        fprintf("The chosen log file is: ")
    else
        log_file = fullfile(pwd, log_file);
        fprintf("The given log file is: ")
    end
    cprintf('hyper', "%s\n", log_file)
    if isfile(log_file)
        confirm_file = input("File successfully located, proceed? [Y/n]:", "s");
        if isempty(confirm_file) || strcmpi(confirm_file, "Y")
            disp("OK! I will use this file!")
            log_raw_lines = readlines(log_file,"EmptyLineRule","skip");
            disp("File is loaded!")
            break
        elseif strcmpi(confirm_file, "n")
            disp("OK! Please re-type the file name!")
            continue
        else
            cprintf('err', "Invalid input! Try Again!\n")
            continue
        end
    else
        fprintf(2, "Cannot find this file! Please check file name!\n")
        continue
    end
end
%% Asking User to give extra information
disp("Now I'd like to request some basic information about this log.")
test_date = input("When was this test conducted? [YYYY-MM-DD]: ","s");
gas_type = input("What is the gas injected? [e.g. NO]: ","s");
inj_count = input("How many times did you inject the gas? [e.g. 2]:");
disp("When and how much was injected each time?")
inj_time = strings(inj_count,1);
inj_amount = zeros(inj_count,1);
for inj = 1:inj_count
    input_time = input("Injection " + num2str(inj) + " time [HH:MM:SS]: ","s");
    inj_time(inj) = strcat(test_date, " ", input_time);
    inj_amount(inj) = input("Injection " + num2str(inj) + " amount in mL: ");
end
chip_name = input("Which sensor chip is installed? [e.g. AMES5]: ","s");
comments = input(sprintf("Please type any extra comments you would like to add:\n"),"s");
fprintf("\nOK! I have got all the necessary information.\n" + ...
    "Now I will start processing the log file.\n")
%% Extracting Lines From Log File
% Removing non-data lines
disp("Removing useless lines...")
log_data_lines = log_raw_lines;
for i = length(log_data_lines):-1:1
    this_line = log_data_lines(i);
    % All lines with data contains "W M,", using this as condition
    is_data = contains(this_line, "W M,");
    % First data line has all zero and has ">>" so remove as well.
    if ~is_data || contains(this_line,">>") 
        log_data_lines(i) = [];
    end
end
cprintf('green', "Useless lines removed!\n\n")

see_lines = input("Do you want to see the cleaned-up log? [y,N]:", "s");
if strcmpi(see_lines, "Y")
    disp(log_data_lines)
    input("Press any key to continue.\n")
end

% Splitting each line using comma delimiter
disp("Splitting each line using comma delimiter...")
log_data_array = split(log_data_lines, ",");
cprintf('green', "Done!\n\n")

%% Getting time stamps
disp("Getting time stamps...")
time_col_raw = log_data_array(:,1);
time_col_clean = erase(time_col_raw, ["[", "]", "W M"]);

% Storing time stamps as both "human" time (datetime type) 
% and unix epoch time (double type)
timestamp_dt = datetime(time_col_clean);
timestamp_ue = convertTo(timestamp_dt, 'posixtime');
cprintf('green', "Done!\n\n")

%% Getting Temperature 0 in degrees Celcius
disp("Getting Temperature 0 in degrees Celcius...")
temp0_index = find(contains(log_data_array(1,:), "T0="));
temp0_col = log_data_array(:,temp0_index);
temp0_c = str2double(erase(temp0_col, "T0="))./100;
cprintf('green', "Done!\n\n")

%% Getting Temperature 1 in degrees Celcius
disp("Getting Temperature 1 in degrees Celcius...")
temp1_index = find(contains(log_data_array(1,:), "T1="));
temp1_col = log_data_array(:,temp1_index);
temp1_c = str2double(erase(temp1_col, "T1="))./100;
cprintf('green', "Done!\n\n")

%% Getting Humidity in percentage
disp("Getting Humidity in percentage...")
humid_index = find(contains(log_data_array(1,:), "H="));
humid_col = log_data_array(:,humid_index);
humidity = str2double(erase(humid_col, "H="))./100;
cprintf('green', "Done!\n\n")

%% Getting Sensor readings
disp("Getting Sensor readings...")
% Using index of S1 to deduct index of all sensor readings
s1_index = find(contains(log_data_array(1,:), "S1="));
sensor_indices = s1_index:s1_index+sensor_count-1;
sensor_cols = log_data_array(:, sensor_indices);
sensor_readings = str2double(erase(sensor_cols, regexpPattern("S.=")));
cprintf('green', "Done!\n\n")

%% Storing data in a struct object
disp("Now I will store this data as a new entry inside a struct object.")
store_file = string.empty;
fprintf("This struct is stored in the file ") 
cprintf('Hyperlink', "%s ", data_file_name);
cprintf('text', "under the same directory of this script.\n")

% Checking .mat file
disp("Checking if a file of the same name already exists...")
if isfile(data_file_name)
    cprintf('green', "The file already exists! Great!\n\n")
    load(data_file_name)  
else
    cprintf('err', "The file does not exist! I will create a new one.\n")
    SCUID_Test_Results = struct([]);
    save(data_file_name, 'SCUID_Test_Results')
    cprintf('green', "New file successfully created!\n\n")
end
input("Press any key to save data.\n")

% Saving all the sensor values and information into corresponding fields.
fprintf("Saving all data to a new entry in the struct object...\n")
[srow, scol] = size(SCUID_Test_Results);
entry = srow + 1;
% Basic info
SCUID_Test_Results(entry,1).TestDate = datetime(test_date);
SCUID_Test_Results(entry,1).GasType = gas_type;
SCUID_Test_Results(entry,1).InjectionTime = datetime(inj_time);
SCUID_Test_Results(entry,1).InjectionAmount = inj_amount;
SCUID_Test_Results(entry,1).Chip = chip_name;
SCUID_Test_Results(entry,1).Comments = comments;
% Actual data
SCUID_Test_Results(entry,1).Time = timestamp_dt;
SCUID_Test_Results(entry,1).TimeUE = timestamp_ue;
SCUID_Test_Results(entry,1).Temp0 = temp0_c;
SCUID_Test_Results(entry,1).Temp1 = temp1_c;
SCUID_Test_Results(entry,1).RH = humidity;
SCUID_Test_Results(entry,1).Sensors = sensor_readings;
cprintf('green', "Done!\n\n")
% Saving .mat file
fprintf("Saving the struct object to file...\n")
save(data_file_name, 'SCUID_Test_Results')
cprintf('green', "Done!\n\n")
cprintf('text', "Congratulations! All process done!\n")
