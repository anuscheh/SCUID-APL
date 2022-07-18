clear; close all; clc;
tic
%Import data
text = importdata('teraterm0806.txt');
fNames = fieldnames(text);
raw = text.(fNames{2});
%Cleaning useless information
convert = cellfun(@num2str,raw,'un',0);
convert = string(convert);
n = 0;
for i = 1:size(convert,1)
    if contains(convert(i,1), 'W M')
        n = n + 1;
        strings(n,:) =  convert(i,:);
    end
end

strings = strings(3:end,:);
%Extract timestamp from string
time = str2double(strings(:,4:7));
ts = time(:,1) * 86400 + time(:,2) * 3600 + time(:,3) * 60 + time(:,4);
t0 = ts(1);
t = zeros(length(ts),1);
for i = 1:length(ts)
    t(i) = ts(i) - t0;
end


%Extract pressure info from string
pressure = erase(strings(:,15),"P=");
P = str2double(pressure);

%Extract temperature info from string
temp0 = erase(strings(:,16),"T0=");
for i = 1:length(temp0)
    if strcmp(temp0(i),'0') == 0
        temp0(i) = insertAfter(temp0(i),2,".");
    end
end
T0 = str2double(temp0);

temp1 = erase(strings(:,17),"T1=");
for i = 1:length(temp1)
    if strcmp(temp1(i),'0') == 0
        temp1(i) = insertAfter(temp1(i),2,".");
    end
end
T1 = str2double(temp1);

%Extract humidity info from string
humidity = erase(strings(:,18),"H=");
for i = 1:length(humidity)
    if strcmp(humidity(i),'0') == 0
        humidity(i) = insertAfter(humidity(i),2,".");
    end
end
H = str2double(humidity);

%Extract resistance info from string
resistance = strings(:,19:28);
resistance = eraseBetween(resistance,1,3);
S = str2double(resistance);

%Plots

%When ploting resistance, turn off the other four and vice versa.

%Plot resistance
hold on;
for i = 1:10
    plot(t,S(:,i));
end
xlabel('Time (s)');
ylabel('Resistance (Ω)');
title('Time vs. Resistance');
legend('S1','S2','S3','S4','S5','S6','S7','S8','S9','SA')
hold off;



figure(2);
tiledlayout(2,2)
%Plot Pressure
nexttile
plot(t,P,'r');
xlabel('Time (s)');
ylabel('Pressure ()');
title('Time vs. Pressure');

%Plot Humidity
nexttile
plot(t,H,'b');
xlabel('Time (s)');
ylabel('Humidity (%)');
title('Time vs. Humidity');

%Plot Temperature
nexttile
plot(t,T0,'m');
xlabel('Time (s)');
ylabel('T0 (°C)');
title('Time vs. Temperature0');

nexttile
plot(t,T1,'g');
xlabel('Time (s)');
ylabel('T2 (°C)');
title('Time vs. Temperature1');

toc


%Array for resistance and time. First column is time, then resistance
data = zeros(size(S,1),size(S,2)+1);
data(:,1) = t;
data(:,2:end) = S;
save("Time_and_Resistance.mat","data");



