%Data taken on Oct 13th 2022 with Aanderaa Optode

t_Oct13=[0,0.8, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 5.5, 6.5, 7.5, 10]; %time in minutes
S_Oct13=[80,65,57, 36.3, 22.7, 13.7, 9.5, 7.2, 5.5, 4.1, 3.8, 3.56, 3.44, 3.26];%saturation in %

t_Oct20=[0:0.5:14];
S_Oct20=[78.5, 75.3, 65.3, 56.9, 46.7, 38.2, 31.7, 25.2, 20.7, 17.2, 14.3, 12.1, 10.5, 9.4, 8.4, 7.7, 7.2, 6.8, 6.4, 6.1, 5.9, 5.7, 5.5, 5.4, 5.3, 5.19, 5.09, 5, 4.96];

figure(100)
hold on
plot(t_Oct13,S_Oct13,'bx-.')
plot(t_Oct20, S_Oct20, 'ro--')
title('October 13+20,2022; Optode evaluation of SCUID water circuit using N2 @100sccm')
legend('October 13th, smaller water bath surface','October20, larger water bath surface')
xlabel('Time [min]')
ylabel('Saturation [%]')