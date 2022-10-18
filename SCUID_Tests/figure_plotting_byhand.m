%____October 6th, "blank test"
figure(40)
hold on
plot((SCUID_Test_Results(8).TimeUE(:,:)-SCUID_Test_Results(8).TimeUE(1,:))./60, SCUID_Test_Results(8).P1(:,:))
xlabel('time [min]')
ylabel('pressure [mbar]')
title('Oct 6th,  blank , AMES 18')
xline(0,'--',{'M, N2'})
xline(20,'--',{'B, N2'})
xline(25,'--',{'M, N2'})
xline(40,'--',{'B, N2'})


figure(41)
hold on
plot((SCUID_Test_Results(8).TimeUE(:,:)-SCUID_Test_Results(8).TimeUE(1,:))./60, SCUID_Test_Results(8).RH(:,:))
xlabel('time [min]')
ylabel('RH [%]')
title('Oct 6th, blank, AMES 18')
xline(0,'--',{'M, N2'})
xline(20,'--',{'B, N2'})
xline(25,'--',{'M, N2'})
xline(40,'--',{'B, N2'})

figure(42)
hold on
plot((SCUID_Test_Results(8).TimeUE(:,:)-SCUID_Test_Results(8).TimeUE(1,:))./60, SCUID_Test_Results(8).Sensors(:,1:6)./1000)
xlabel('time [min]')
ylabel('resistance P1-6 [kOhm]')
title('Oct 6th, blank, AMES 18')
xline(0,'--',{'M, N2'})
xline(20,'--',{'B, N2'})
xline(25,'--',{'M, N2'})
xline(40,'--',{'B, N2'})


figure(43)
hold on
plot((SCUID_Test_Results(8).TimeUE(:,:)-SCUID_Test_Results(8).TimeUE(1,:))./60, SCUID_Test_Results(8).Temp1(:,:))
xlabel('time [min]')
ylabel('Board Temperature [^o C]')
title('Oct 6th,blank, AMES 18')
xline(0,'--',{'M, N2'})
xline(20,'--',{'B, N2'})
xline(25,'--',{'M, N2'})
xline(40,'--',{'B, N2'})


%________ October 6th NO exposure
figure(50)
hold on
plot((SCUID_Test_Results(7).TimeUE(:,:)-SCUID_Test_Results(7).TimeUE(1,:))./60, SCUID_Test_Results(7).P1(:,:))
xlabel('time [min]')
ylabel('pressure [mbar]')
title('Oct 6th, AMES 18')
xline(6,'--',{'membrane flow N2'})
xline(36,'--',{'bypass flow, N2/NO'})
xline(41,'--',{'-->membrane flow, N2/NO'})
xline(52,'--',{'membrane flow, N2'})
xline(57,'--',{'bypass flow, N2/NO'})
xline(64,'--',{'-->membrane flow, N2/NO'})

figure(51)
hold on
plot((SCUID_Test_Results(7).TimeUE(:,:)-SCUID_Test_Results(7).TimeUE(1,:))./60, SCUID_Test_Results(7).RH(:,:))
xlabel('time [min]')
ylabel('RH [%]')
title('Oct 6th, AMES 18')
xline(6,'--',{'membrane flow N2'})
xline(36,'--',{'bypass flow, N2/NO'})
xline(41,'--',{'-->membrane flow, N2/NO'})
xline(52,'--',{'membrane flow, N2'})
xline(57,'--',{'bypass flow, N2/NO'})
xline(64,'--',{'-->membrane flow, N2/NO'})

figure(52)
hold on
plot((SCUID_Test_Results(7).TimeUE(:,:)-SCUID_Test_Results(7).TimeUE(1,:))./60, SCUID_Test_Results(7).Sensors(:,1:6)./1000)
xlabel('time [min]')
ylabel('resistance P1-6 [kOhm]')
title('Oct 6th, AMES 18')
xline(6,'--',{'membrane flow N2'})
xline(36,'--',{'bypass flow, N2/NO'})
xline(41,'--',{'-->membrane flow, N2/NO'})
xline(52,'--',{'membrane flow, N2'})
xline(57,'--',{'bypass flow, N2/NO'})
xline(64,'--',{'-->membrane flow, N2/NO'})

figure(53)
hold on
plot((SCUID_Test_Results(7).TimeUE(:,:)-SCUID_Test_Results(7).TimeUE(1,:))./60, SCUID_Test_Results(7).Temp1(:,:))
xlabel('time [min]')
ylabel('Board Temperature [^o C]')
title('Oct 6th, AMES 18')
xline(6,'--',{'membrane flow N2'})
xline(36,'--',{'bypass flow, N2/NO'})
xline(41,'--',{'-->membrane flow, N2/NO'})
xline(52,'--',{'membrane flow, N2'})
xline(57,'--',{'bypass flow, N2/NO'})
xline(64,'--',{'-->membrane flow, N2/NO'})


%_______________________ Oct 14th
figure(60)
hold on
plot((SCUID_Test_Results(9).TimeUE(:,:)-SCUID_Test_Results(9).TimeUE(6,:))./60, SCUID_Test_Results(9).P1(:,:))
xlabel('time [min]')
ylabel('pressure [mbar]')
title('Oct 14th, AMES 18')
xline(0,'--',{'B+M, N2'})
xline(28,'--',{'B, N2 - no NO'})
xline(34,'--',{'-->B+M, N2 no NO'})
xline(87,'--',{'B, N2/NO'})
xline(87,'--',{'bypass flow, N2/NO'})
xline(92,'--',{'-->B+M, N2/NO'})

figure(61)
hold on
plot((SCUID_Test_Results(9).TimeUE(:,:)-SCUID_Test_Results(9).TimeUE(6,:))./60, SCUID_Test_Results(9).RH(:,:))
xlabel('time [min]')
ylabel('RH [%]')
title('Oct 14th, AMES 18')
xline(0,'--',{'B+M, N2'})
xline(28,'--',{'B, N2 - no NO'})
xline(34,'--',{'-->B+M, N2 no NO'})
xline(87,'--',{'B, N2/NO'})
xline(87,'--',{'bypass flow, N2/NO'})
xline(92,'--',{'-->B+M, N2/NO'})

figure(62)
hold on
plot((SCUID_Test_Results(9).TimeUE(:,:)-SCUID_Test_Results(9).TimeUE(6,:))./60, SCUID_Test_Results(9).Temp1(:,:))
xlabel('time [min]')
ylabel('Board Temperature [^o C]')
title('Oct 14th, AMES 18')
xline(0,'--',{'B+M, N2'})
xline(28,'--',{'B, N2 - no NO'})
xline(34,'--',{'-->B+M, N2 no NO'})
xline(87,'--',{'B, N2/NO'})
xline(87,'--',{'bypass flow, N2/NO'})
xline(92,'--',{'-->B+M, N2/NO'})

figure(63)
hold on
plot((SCUID_Test_Results(9).TimeUE(:,:)-SCUID_Test_Results(9).TimeUE(6,:))./60, SCUID_Test_Results(9).Sensors(:,1:6)./1000)
xlabel('time [min]')
ylabel('Resistance [Ohm]')
title('Oct 14th, AMES 18')
xline(0,'--',{'B+M, N2'})
xline(28,'--',{'B, N2 - no NO'})
xline(34,'--',{'-->B+M, N2 no NO'})
xline(87,'--',{'B, N2/NO'})
xline(87,'--',{'bypass flow, N2/NO'})
xline(92,'--',{'-->B+M, N2/NO'})