%% Matlab code for evaluating TeraTerm data from SCUID water tests after parsing

i=1;

figure(i);
%plot RH %Jerry, we do need RH in the struct file. 
xline(440) % Jerry can you somehow use xline for the times when NO was injected?
plot(SCUID_Test_Results(2).TimeUE,SCUID_Test_Results(2).Sensors(:,7:11))
xlabel('time [s]')
ylabel('RH [%]')
title('RH')

figure(i+1); hold on;
plot(SCUID_Test_Results(2).TimeUE,SCUID_Test_Results(2).Sensors(:,7:11))
plot(Temp1,'b')
xline(440)
xline(560)
legend('T0','T1')
title('Temperature')

figure(i+2);hold on;
plot(p1,'r')
plot(p2,'b')
xline(440)
xline(560)
legend('p1','p2')
title('pressure')

figure(i+3); hold on;
plot(SCUID_Test_Results(2).TimeUE,SCUID_Test_Results(2).Sensors(:,1:6))

title('pads1-6')


figure(i+4);hold on;
plot(SCUID_Test_Results(2).TimeUE,SCUID_Test_Results(2).Sensors(:,7:11))
xline(440)
xlabel('time[s]')
ylabel ('Sensor signal')
title('pads7-11')

