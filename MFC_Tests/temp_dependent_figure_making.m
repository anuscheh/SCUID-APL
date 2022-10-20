figure(50)
hold on
plot(CNT_Results_NO(73).timeE(:,:)-CNT_Results_NO(73).timeE(1,:), CNT_Results_NO(73).r(:,2)./CNT_Results_NO(73).r(2371,2),'b');
plot(CNT_Results_NO(75).timeE(:,:)-CNT_Results_NO(75).timeE(1,:), CNT_Results_NO(75).r(:,2)./CNT_Results_NO(75).r(3734,2),'m');
plot(CNT_Results_NO(77).timeE(:,:)-CNT_Results_NO(77).timeE(1,:), CNT_Results_NO(77).r(:,2)./CNT_Results_NO(77).r(2385,2),'r');
legend('AMES17,P2 - 24C','AMES 17,P2 - 28C','AMES 17,P2 - 32C')


figure(51)
hold on
plot(CNT_Results_NO(73).timeE(:,:)-CNT_Results_NO(73).timeE(1,:), CNT_Results_NO(73).r(:,3)./CNT_Results_NO(73).r(2371,3),'b');
plot(CNT_Results_NO(75).timeE(:,:)-CNT_Results_NO(75).timeE(1,:), CNT_Results_NO(75).r(:,3)./CNT_Results_NO(75).r(3734,3),'m');
plot(CNT_Results_NO(77).timeE(:,:)-CNT_Results_NO(77).timeE(1,:), CNT_Results_NO(77).r(:,3)./CNT_Results_NO(77).r(2385,3),'r');
legend('AMES17,P3 - 24C','AMES 17,P3 - 28C','AMES 17,P3 - 32C')

figure(52)
hold on
plot(CNT_Results_NO(73).timeE(:,:)-CNT_Results_NO(73).timeE(1,:), CNT_Results_NO(73).r(:,4)./CNT_Results_NO(73).r(2371,4),'b');
plot(CNT_Results_NO(75).timeE(:,:)-CNT_Results_NO(75).timeE(1,:), CNT_Results_NO(75).r(:,4)./CNT_Results_NO(75).r(3734,4),'m');
plot(CNT_Results_NO(77).timeE(:,:)-CNT_Results_NO(77).timeE(1,:), CNT_Results_NO(77).r(:,4)./CNT_Results_NO(77).r(2385,4),'r');
legend('AMES17,P4 - 24C','AMES 17,P4 - 28C','AMES 17,P4 - 32C')


figure(60)
hold on
plot(CNT_Results_NO(73).timeE(:,:)-CNT_Results_NO(72).timeE(1,:), CNT_Results_NO(72).r(:,2)./CNT_Results_NO(72).r(2238,2),'b');
plot(CNT_Results_NO(75).timeE(:,:)-CNT_Results_NO(74).timeE(1,:), CNT_Results_NO(74).r(:,2)./CNT_Results_NO(74).r(2257,2),'m');
plot(CNT_Results_NO(77).timeE(:,:)-CNT_Results_NO(76).timeE(1,:), CNT_Results_NO(76).r(:,2)./CNT_Results_NO(76).r(2262,2),'r');
legend('AMES19,P2 - 24C','AMES 19,P2 - 28C','AMES 19,P2 - 32C')


figure(61)
hold on
plot(CNT_Results_NO(73).timeE(:,:)-CNT_Results_NO(72).timeE(1,:), CNT_Results_NO(72).r(:,3)./CNT_Results_NO(72).r(2238,3),'b');
plot(CNT_Results_NO(75).timeE(:,:)-CNT_Results_NO(74).timeE(1,:), CNT_Results_NO(74).r(:,3)./CNT_Results_NO(74).r(2257,3),'m');
plot(CNT_Results_NO(77).timeE(:,:)-CNT_Results_NO(76).timeE(1,:), CNT_Results_NO(76).r(:,3)./CNT_Results_NO(76).r(2262,3),'r');
legend('AMES19,P3 - 24C','AMES 19,P3 - 28C','AMES 19,P3 - 32C')


figure(62)
hold on
plot(CNT_Results_NO(73).timeE(:,:)-CNT_Results_NO(72).timeE(1,:), CNT_Results_NO(72).r(:,4)./CNT_Results_NO(72).r(2238,4),'b');
plot(CNT_Results_NO(75).timeE(:,:)-CNT_Results_NO(74).timeE(1,:), CNT_Results_NO(74).r(:,4)./CNT_Results_NO(74).r(2257,4),'m');
plot(CNT_Results_NO(77).timeE(:,:)-CNT_Results_NO(76).timeE(1,:), CNT_Results_NO(76).r(:,4)./CNT_Results_NO(76).r(2262,4),'r');
legend('AMES19,P3 - 24C','AMES 19,P3 - 28C','AMES 19,P3 - 32C')



figure(71)
hold on
plot( CNT_Results_NO(73).r(:,2));
plot(CNT_Results_NO(75).r(:,2));
plot(CNT_Results_NO(77).r(:,2));
legend('24C','28C','32C')
