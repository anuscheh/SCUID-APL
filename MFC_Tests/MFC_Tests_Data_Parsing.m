% this program adds test run data to the CNT_Results.mat

close all;clear all; % clean your workspace first becuase you can import data into an exisint structe and overwrite it... bad
selpath='/Users/cyano/Documents/GitHub/SCUID-APL/MFC_Tests'; % you secify where you're at
cd(selpath);

%_________________________
%% Enter data 
% date and info
addinfo = "09/0/2022 -Board2"; %enter any information about this test bthat is not contained in the headerfile
chip = 1; %enter chip number (E.G. 1 for AMES1, etc.)
% Enter MFC Parameters, % ACCEPTABLE GASES: N2O, NO, CO2, CO, NO2, Concentration in PPM

% MFC0 - what gas bottle is connected?
gas1 = "NO";
Gas1Conc = 104;%12.5;%104;[ppm] in gas bottle (source)

% MFC1 - what gas bottle is connected?
gas2 = "N2O";
Gas2Conc = 12.9;

%% load data files and struct ==================================================================

%Select .mat file to be loaded in/ modified
load('CNT_Results_NO.mat') %all data is in here


% Select .dat file to be loaded in
disp('What .dat file should be read and stored in the .mat file?');
[file2,path2] = uigetfile('.dat');  % find dat file to add to struct

%% harvest contents of the dat file
%Strip data(numbers) from .dat file
data = readtable(strcat(path2,file2),'Delimiter', '\t', 'HeaderLines', 50); % Import nmumbers

% Open the file for reading in text mode.
f = fopen(strcat(path2,file2), 'rt');
%f = fopen('/Users/anuscheh/Documents/MATLAB/SCUID_N2O/29_March2022/_Board02022_3_29.dat');

%columns = columns{1}(2:11);



textLine = fgetl(f); % Read the first line of the file.
testdate=extractAfter(textLine, ':');
columns = textscan(f, '%[^*]');
fclose(f);

testdateM=  datenum(testdate);     %convert the "3/29/2022 1:42 PM" in the first line of the to matlabtime
timeE = table2array(data(1:end,1)); % Import time column --> Epochtime from LabView
time = timeE - ones(length(timeE),1)*timeE(1); % Convert from epoch time to seconds

N2Data = table2array(data(1:end,8)); % N2 Gasflow
O2Data = table2array(data(1:end,7)); % O2 Gasflow
%NOlowData = table2array(data(:,5)); % NO Low Gasflow
MFC0Data = table2array(data(1:end,5)); % MFC0 Gasflow
MFC1Data = table2array(data(1:end,6)); % MFC1 Gasflow

%highlow = table2array(data(:,25)); % 0 is low, 1 is high  (depends on VI
%version)..AN  this is the relay state- we do not need this
BME280temp = table2array(data(1:end,2));
BME280rh = table2array(data(1:end,3));
boardtemp = table2array(data(1:end,4));


% Define the resistance data...CAN THIS BE DONE BETTER?
Rdata = zeros(length(time), 12);
for i = 1:12
        Rdata(:,i) = table2array(data(:,i+8))/100; % Rdata format: Rdata(data#, sensorpad#)    
end

%_____________
% Create desired parameters (CLM IS THIS A CALIBRATION NUMBER? 30.01?)
%AN: this assumes a whole bunch..recode when you get a chance. 
%make sure MFC0 goes with Gas1Conc etc.
totalflow=MFC0Data+N2Data+O2Data;
PPM1 = (MFC0Data).*(1000*30.01/0.001*(Gas1Conc/1000/30.01)*0.001)./(totalflow);
PPM2 = (MFC1Data).*(1000*30.01/0.001*(Gas2Conc/1000/30.01)*0.001)./(totalflow);
%PPM1 = zeros(1,length(PPM1)); %AN why is this here?
O2Conc = (O2Data./(O2Data+N2Data))*0.23*100;


%% Add parameters to master struct
[a,b]=size(CNT_Results_NO);

i= a+1;
CNT_Results_NO(i,1).testdateM = testdateM; % this is the data in matlab time at which the data was taken  (extracted from headerfile)
CNT_Results_NO(i,1).timeE = timeE; %this is the time column , epochtime from LAbview
CNT_Results_NO(i,1).chip = chip;
CNT_Results_NO(i,1).addinfo = addinfo;
CNT_Results_NO(i,1).testinfo = columns;

CNT_Results_NO(i,1).boardtemp = boardtemp;
CNT_Results_NO(i,1).bmetemp = BME280temp;
CNT_Results_NO(i,1).rh = BME280rh;


CNT_Results_NO(i).r = Rdata;


if gas1 == gas2
    PPM = PPM1 + PPM2;
    
    if gas1 == "N2O"
        CNT_Results_NO(i,1).n2oppm = PPM;
    end
    if gas1 == "NO"
        CNT_Results_NO(i,1).noppm = PPM;
    end
%     if gas1 == "CO2"
%         CNT_Results.co2ppm = [CNT_Results.co2ppm; PPM];
%     end
%     if gas1 == "CO"
%         CNT_Results.coppm = [CNT_Results.coppm; PPM];
%     end
    if gas1 == "NO2"
        CNT_Results_NO(i,1).no2ppm = PPM;
    end
    
end


if gas1 ~= gas2
    
    % Gas 1
    if gas1 == "N2O"
        CNT_Results_NO.n2oppm = [CNT_Results_NO.n2oppm; PPM1];
    end
    if gas1 == "NO"
        CNT_Results_NO.noppm = [CNT_Results_NO.noppm; PPM1];
    end
%    
    if gas1 == "NO2"
        CNT_Results_NO.no2ppm = [CNT_Results_NO.no2ppm; PPM1];
    end
    
    % Gas 2
    if gas2 == "N2O"
        CNT_Results_NO.n2oppm = [CNT_Results_NO.n2oppm; PPM2];
    end
    if gas2 == "NO"
        CNT_Results_NO.noppm = [CNT_Results_NO.noppm; PPM2];
    end

    if gas2 == "NO2"
        CNT_Results_NO.no2ppm = [CNT_Results_NO.no2ppm; PPM2];
    end
    
end

% if (gas1 ~= "N2O") && (gas2 ~= "N2O")
%     CNT_Results.n2oppm = [CNT_Results.n2oppm; zeros(length(time),1)]
% end
% 
% if (gas1 ~= "NO") && (gas2 ~= "NO")
%     CNT_Results.noppm = [CNT_Results.noppm; zeros(length(time),1)]
% end
% 
% 
% if (gas1 ~= "NO2") && (gas2 ~= "NO2")
%     CNT_Results.no2ppm = [CNT_Results.no2ppm; zeros(length(time),1)]
% end


% CNT_Results(i,1).o2ppm = O2Conc;
% 
% T = CNT_Results.testinfo;
% g = table2array(T);
% %g = [g; [num2str(prevtest+1), date, info]];
% CNT_Results.testinfo = array2table(g);


%save([path1,file1], "Run"); % ???
%disp(["Saved under test # "+ (prevtest+1)]); % ???

save CNT_Results_NO CNT_Results_NO;
    
