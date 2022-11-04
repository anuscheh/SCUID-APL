%Data taken on Oct 13th 2022 with Aanderaa Optode

t_Oct13=[0,0.8, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 5.5, 6.5, 7.5, 10]; %time in minutes
S_Oct13=[80,65,57, 36.3, 22.7, 13.7, 9.5, 7.2, 5.5, 4.1, 3.8, 3.56, 3.44, 3.26];%saturation in %

t_Oct20=[0:0.5:14];
S_Oct20=[78.5, 75.3, 65.3, 56.9, 46.7, 38.2, 31.7, 25.2, 20.7, 17.2, 14.3, 12.1, 10.5, 9.4, 8.4, 7.7, 7.2, 6.8, 6.4, 6.1, 5.9, 5.7, 5.5, 5.4, 5.3, 5.19, 5.09, 5, 4.96];

t_Oct31=[0, 1, 1.5, 2, 2.25, 2.5,2.75, 3, 3.25, 3.5, 3.75, 4, 4.25, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 9, 9.5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22, 24, 26, 28, 30];
S_Oct31=[78.2, 73.9, 61.9, 49.2, 43.8, 39.6, 34.7, 31.0, 27.5, 24.56, 22.22, 19.95, 17.21, 16.03, 12.95, 10.48, 8.68, 7.27, 6.22, 5.42, 4.81, 3.96, 3.7, 3.45, 3.16, 2.96, 2.81, 2.68, 2.59, 2.57, 2.44, 2.37, 2.26, 2.17, 2.08, 2.01, 1.95, 1.9];

figure(100)
hold on
plot(t_Oct13,S_Oct13,'bx-.')
plot(t_Oct20, S_Oct20, 'ro--')
plot(t_Oct31, S_Oct31, 'gd--')
title('October 13+20,2022; Optode evaluation of SCUID water circuit using N2 @100sccm')
legend('October 13th, smaller water bath surface','October20, larger water bath surface', 'Oct31, same as Oct13')
xlabel('Time [min]')
ylabel('Optode Saturation [%]')