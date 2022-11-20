% Pressure Plot
figure(1)
hold on
yyaxis left
plot(ts,(SCUID_Test_Results(tgt_entry,1).P1-1025)/30,LineWidth=2);
yyaxis right
plot(ts,SCUID_Test_Results(tgt_entry,1).Sensors(:,i)./non0val);
legend('p','r')

events = SCUID_Test_Results(tgt_entry,1).Events;

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