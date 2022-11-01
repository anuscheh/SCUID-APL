%%SCUID plotting, after the CNT_Results.mat is loaded (SCUID_MFC_dataload)
close all; clear all;
%selpath='/Users/anuschehnawaz/Documents/MATLAB/SCUID_NO'; % you secify where you're at
%cd(selpath);
load('CNT_Results_NO.mat') %all data is in here

% 
% %% plotting
% %E.g. plot where temperature of the board is >35C)
% 
% for i=2:length(CNT_Results)
%     g=find(CNT_Results(i).boardtemp>35);
%     figure(1); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).rh(g),'b.');
%     figure(2); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,7),'b.');
% end
% hold off;
% %% plotting chip1, pad 11 for 3/29 and 4/11 - 3%RH and 0.5% RH
% 
% figure(10); 
% plot(CNT_Results(2).timeE-CNT_Results(2).timeE(1), CNT_Results(2).r(:,11),'r.');
% hold on;plot(CNT_Results(7).timeE-CNT_Results(7).timeE(1), CNT_Results(7).r(:,11),'b.');

%% plotting resistance for a certain pad and chip at a certain date

for i= 18:length(CNT_Results_NO)
    if CNT_Results_NO(i).chip==5
    timeF(:,i)=CNT_Results_NO(i).timeE-CNT_Results_NO(i).timeE(1);
    timeF_h(:,i)=timeF(:,i)./(60*60);
    for pad=1:6
        R0=CNT_Results_NO(i).r(22000,pad);
        figure(i);hold on;
%             fig = figure(i);
%             ax = axes(fig); 
%             ax.LineStyleOrderIndex = ax.LineStyleOrderIndex; % [1]
%             ax.LineStyleOrder = {'-','-.','--','-','-.','--'};
%             ax.ColorOrder = [1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 1];
%             hold(ax,'on') % [2]
        yyaxis left
        plot(timeF_h(:,i),movmean((CNT_Results_NO(i).r(:,pad)-R0)./R0*100,15));       
    end
    legend('pad1', 'pad2','pad3','pad4','pad5','pad6')
    title(['Pad 1-6 Chip', num2str(CNT_Results_NO(i).chip)],CNT_Results_NO(i).addinfo)
    ylabel('(R-R_0)/R_0')
    xlabel('time [h]')
    yyaxis right
    plot(timeF_h(:,i), CNT_Results_NO(i).noppm, '-r')
    ylabel('NO concentration [ppm]')
    %ylim([0 1.5]);
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
    plotedit
    hold off
    
    for pad=7:12
    R0=CNT_Results_NO(i).r(22000,pad);
    figure(i+20);hold on;
        yyaxis left
        plot(timeF_h(:,i),movmean((CNT_Results_NO(i).r(:,pad)-R0)./R0*100,15));       
    end
    legend('pad7', 'pad8','pad9','pad10','pad11','pad12')
    title(['Pad 7-12 Chip', num2str(CNT_Results_NO(i).chip)],CNT_Results_NO(i).addinfo)
    ylabel('(R-R_0)/R_0')
    xlabel('time [h]')
    yyaxis right
    plot(timeF_h(:,i), CNT_Results_NO(i).noppm, '-r')
    ylabel('NO concentration [ppm]')
    %ylim([0 1.5]);
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
    plotedit
    hold off

    figure(20); hold on
    m=(length(CNT_Results_NO)-1)/3;
    subplot(m,3,(i-1))
    yyaxis left; 
    plot(timeF_h(:,i),CNT_Results_NO(i).rh, '-b')
    xlabel('time [h]')
    ylabel('Relative hunidity [%]')
    plotedit
    yyaxis right
    plot(timeF_h(:,i),CNT_Results_NO(i).boardtemp, '-r')
    ylabel('Board Temperature [C]')
    hold off
    clear i;clear timeF_h; clear pad; clear timeF; 
    end
    %set(findall(gcf,'-property','FontSize'),'FontSize',20)
end


%%__
%plotting calibration curve, pad 7,10,12 on 6/27/22, chip 5
%figuring out times
CNT_Results_NO(10).noppm_shift=[CNT_Results_NO(10).noppm(5:end);0;0;0;0];
noppm_delta=CNT_Results_NO(10).noppm-CNT_Results_NO(10).noppm_shift;
g=find(CNT_Results_NO(10).noppm(:,1))
% %% evaluating for concentration curve
% 
% for n= 2:length(CNT_Results)
%     N2OPPM=hampel(CNT_Results(n).n2oppm);
%     plot(N2OPPM);
%     hold on
%     clear N2Oppm
% end



% %% plotting for low and high RH
% for i=2:length(CNT_Results)
%     g=find(CNT_Results(i).rh>0);
%     figure(3); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,6),'b.');
%     figure(4); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,7),'b.');
%     figure(5); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,8),'b.');
%     figure(6); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,9),'b.');
%     figure(7); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,10),'b.');
%     figure(8); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,11),'b.');
%     figure(9); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,12),'b.');
% end
% 
% for i=2:length(CNT_Results)
%     g=find(CNT_Results(i).rh>0.1);
%     figure(3); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,6),'r.');
%     figure(4); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,7),'r.');
%     figure(5); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,8),'r.');
%     figure(6); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,9),'r.');
%     figure(7); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,10),'r.');
%     figure(8); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,11),'r.');
%     figure(9); hold on; plot(CNT_Results(i).timeE(g), CNT_Results(i).r(g,12),'r.');
% end
% hold off;
% hold off;
% 
% k = find(CNT_Results.testdateM => now-60);
% 
% %______________
% for pad = 6:11
%     figure(1)
%     yyaxis left
%     plot(Results.time(k)./60, movmean(Results.r(k,pad), 15));%,'Color',color(i, :),'LineStyle', '-')
% end
% hold on
% xlabel("time (min)")
% ylabel("Resistance (Ohms)")
% %title("N2O Test at 0% O2 and 35 deg C, 0.5%RH", ["0.175 PPM Pre-Conditioning, 0% RH","AMES 3, Tests: 13, 17, 18 on Sept 1,9,10 2021"])
% 
% % Plot n2o PPM
% yyaxis right
% ylabel("Concentration N2O (PPM)")
% plot(Results.time(k)./60, Results.n2oppm(k), '-r')
% ylim([0 1.2])
% %legend([table2array(Results.testinfo(TestResults(1), 2)), table2array(Results.testinfo(TestResults(2), 2)), table2array(Results.testinfo(TestResults(3), 2)), "PPM N2O"])
%     
% figure(2)
% hold on
% for i = 1:length(Testrun)
%     
%     % Choose test
%     k = find(Results.test == Testrun(i));
%     for pad= 1:12
%         % Plot resistance data    % Normalize around 22000 (First purge)
%         yyaxis left
%         plot(Results.time(k)./60, movmean((Results.r(k,pad)-Results.r(k(1)+22000,pad))/Results.r(k(1)+22000,10)*100,15),'b-');%-'DisplayName',num2str(pad));%,'Color',color(i, :),'LineStyle','-')
%         hold on
%         %legend('-DynamicLegend');
%         %legend('show');
%     end
%     xlabel("time (min)")
%     ylabel("Normalized Resistance (delR/R) %delR")
%    % title("N2O Test at 0% O2 and 25 deg C", ["0.175 PPM Pre-Conditioning, 0% RH","AMES 3, Tests: 13, 17, 18 on Sept 1,9,10 2021"])
%     
%     % Plot n2o PPM
%     yyaxis right
%     ylabel("Concentration N2O (PPM)")
%     plot(Results.time(k)./60, Results.n2oppm(k), '-r')
%     ylim([0 1.2])
%     %legend([table2array(Results.testinfo(Testrun(1), 2)), table2array(Results.testinfo(Testrun(2), 2)), table2array(Results.testinfo(Testrun(3), 2)), "PPM N2O"])
%     
%     % Change axis colors
%     ax = gca;
%     ax.YAxis(1).Color = 'k';
%     ax.YAxis(2).Color = 'r';
% end
% 
    