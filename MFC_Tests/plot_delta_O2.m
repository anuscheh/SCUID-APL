pad=3;
for i=1:4
    AH23_delta(i,pad)=cursor_Pad3(2*i).Position(1,2)-cursor_Pad3(2*i-1).Position(1,2)
end

deltaAH23=flipud(AH23_delta);
figure(51); 
plot([0.5;1;2;3.5],(deltaAH23(:,1)),'x--')
hold on
plot([0.5;1;2;3.5],(deltaAH23(:,2)),'o--')
plot([0.5;1;2;3.5],(deltaAH23(:,3)),'+--')
legend('Pad 1','Pad 2','Pad 3');