%Data taken on Oct 13th 2022 with Aanderaa Optode

t=[0,0.8, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 5.5, 6.5, 7.5, 10]; %time in minutes
S=[80,65,57, 36.3, 22.7, 13.7, 9.5, 7.2, 5.5, 4.1, 3.8, 3.56, 3.44, 3.26];%saturation in %

figure(100)
hold on
plot(t,S,'bx')
title('October 13,2022; Optode evaluation of SCUID water circuit using N2 @100sccm')
xlabel('Time [min]')
ylabel('Saturation [%]')