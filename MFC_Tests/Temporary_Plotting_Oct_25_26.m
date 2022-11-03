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

for line = 95:97
    figure(line)
    yyaxis("left")
    ylabel("Response")
    plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), CNT_Results_NO(line).r(:,2),'LineWidth',2);
    hold on
    yyaxis("right")
    ylabel("noppm")
    plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), CNT_Results_NO(line).noppm(:,:)*100+7500,'g','LineWidth',2)
    % plot(CNT_Results_NO(95).timeE(:,:)-CNT_Results_NO(95).timeE(1,:), CNT_Results_NO(95).boardtemp(:,:)*100+7000,'r','LineWidth',2)
    legend(["Response", "noppm"])
    title("Oct 25, Chip "+num2str(CNT_Results_NO(line).chip))
    hold off
end

for line = 98:100
    figure(line)
    yyaxis("left")
    ylabel("Response")
    plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), CNT_Results_NO(line).r(:,2),'LineWidth',2);
    hold on
    yyaxis("right")
    ylabel("noppm")
    plot(CNT_Results_NO(line).timeE(:,:)-CNT_Results_NO(line).timeE(1,:), CNT_Results_NO(line).noppm(:,:)*100+7500,'g','LineWidth',2)
    % plot(CNT_Results_NO(95).timeE(:,:)-CNT_Results_NO(95).timeE(1,:), CNT_Results_NO(95).boardtemp(:,:)*100+7000,'r','LineWidth',2)
    legend(["Response", "noppm"])
    title("Oct 26, Chip "+num2str(CNT_Results_NO(line).chip))
    hold off
end