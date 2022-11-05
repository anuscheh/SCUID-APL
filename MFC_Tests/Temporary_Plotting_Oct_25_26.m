% This script is used to plot data collected on Oct 25 & 26, 2022
% Author: Jerry Chen
% Date Created: 11/03/2022
% Last Updated: 11/03/2022

% example plotting by hand - leaving this here just in case we need to plot
% something on the fly
% figure(30)
% hold on
% plot(CNT_Results_NO(92).timeE(:,:)-CNT_Results_NO(92).timeE(1,:), CNT_Results_NO(92).r(:,2));
% plot(CNT_Results_NO(92).timeE(:,:)-CNT_Results_NO(92).timeE(1,:), CNT_Results_NO(92).noppm(:,:)*100+7500,'g')
% plot(CNT_Results_NO(92).timeE(:,:)-CNT_Results_NO(92).timeE(1,:), CNT_Results_NO(92).boardtemp(:,:)*100+7000,'r')
% 
% figure(31)
% hold on
% plot(CNT_Results_NO(93).timeE(:,:)-CNT_Results_NO(93).timeE(1,:), CNT_Results_NO(93).r(:,2));
% plot(CNT_Results_NO(93).timeE(:,:)-CNT_Results_NO(93).timeE(1,:), CNT_Results_NO(93).noppm(:,:)*100+6000,'g')
% plot(CNT_Results_NO(93).timeE(:,:)-CNT_Results_NO(93).timeE(1,:), CNT_Results_NO(93).boardtemp(:,:)*100+6000,'r')
% 
% figure(32)
% hold on
% plot(CNT_Results_NO(94).timeE(:,:)-CNT_Results_NO(94).timeE(1,:), CNT_Results_NO(94).r(:,2));
% plot(CNT_Results_NO(94).timeE(:,:)-CNT_Results_NO(94).timeE(1,:), CNT_Results_NO(94).noppm(:,:)*100+7500,'g')
% plot(CNT_Results_NO(94).timeE(:,:)-CNT_Results_NO(94).timeE(1,:), CNT_Results_NO(94).boardtemp(:,:)*100+7000,'r')


clear; close all; clc;

load("CNT_Results_NO.mat")
pads = 7:12;

for line = 95:97
    figure(line)
    hold on
    yyaxis("left")
    for pad = pads
        plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), ...
            CNT_Results_NO(line).r(:,pad),'-','LineWidth',2,'DisplayName',strcat("Pad ",num2str(pad)));
    end
    colororder('default');
    ylabel("Response")
    yyaxis("right")
    ylabel("noppm")
    plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), ...
        CNT_Results_NO(line).noppm(:,:)*100+7500,':k','LineWidth',2,'DisplayName',"noppm")
    % plot(CNT_Results_NO(95).timeE(:,:)-CNT_Results_NO(95).timeE(1,:), CNT_Results_NO(95).boardtemp(:,:)*100+7000,'r','LineWidth',2)
    legend()
    title("Oct 25, Chip "+num2str(CNT_Results_NO(line).chip))
    hold off
end

for line = 98:100
    figure(line)
    hold on
    yyaxis("left")
    for pad = pads
        plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), ...
            CNT_Results_NO(line).r(:,pad),'-','LineWidth',2,'DisplayName',strcat("Pad ",num2str(pad)));
    end
    colororder('default');
    ylabel("Response")
    yyaxis("right")
    ylabel("noppm")
    plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), ...
        CNT_Results_NO(line).noppm(:,:)*100+7500,':k','LineWidth',2,'DisplayName',"noppm")
    % plot(CNT_Results_NO(95).timeE(:,:)-CNT_Results_NO(95).timeE(1,:), CNT_Results_NO(95).boardtemp(:,:)*100+7000,'r','LineWidth',2)
    legend()
    title("Oct 26, Chip "+num2str(CNT_Results_NO(line).chip))
    hold off
end




%% == Overall Plot Format Settings
all_figs = findall(groot,'type','figure');
set(all_figs, 'Position',[200,200,1400,600])
all_axes = findall(all_figs,'type','axes');
all_lines = findall(all_figs,'Type','Line');
set(all_axes,'FontSize',20, 'box','off')
% all_lgds = findall(all_figs,'type','legend');
% set(all_lgds,'edgecolor','none', 'location','northeast');
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
grid on;