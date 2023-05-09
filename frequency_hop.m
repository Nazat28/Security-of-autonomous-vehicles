close all;
clear all;
clc;

x=[1:1:7];
y=[174,174,174,174,174,174,174];
hop=[172,184,172,176,176,180,182];

plot(x,hop,'*r-','Linewidth',2)
hold on
plot(x,y,'*g-','Linewidth',2)


%% For increasing Fonts
hold on;
set(findall(gca, 'Type', 'Line'),'LineWidth',3);
xlabel('Time', 'FontSize', 22);
ylabel('Channels of DSRC','FontSize',22);
ax = gca;
ax.FontSize = 22;

%% For Different Legends
leg = legend('Platoon channels','Attacker channels','Location','best');
leg.FontSize = 24;

