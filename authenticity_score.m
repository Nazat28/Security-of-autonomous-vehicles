close all; clear all; clc; 

pltn1 = [3,1,1,3,5,5,1,3,5,1];
pltn2 = [3,3,3,3,3,3,3,3,3,3];
pltn3 = [5,5,5,5,5,5,5,5,5,5];
pltn4 = [1,1,1,1,1,1,1,1,1,1];

total_scores = zeros(1, 4);

figure; % create a new figure

hold on; % enable "hold on" to add multiple plots to the same figure

for j = 1:4
    pltn = eval(['pltn', num2str(j)]); % get the platoon from the variable name
    
    total_score = zeros(size(pltn));
    
    for i = 2:numel(pltn)
        merit = 0;
        demerit = 0;
        
        if pltn(i) > 1
            if pltn(i) == 3
                demerit = demerit + 1;
            else 
                pltn(i) == 5;
                merit = merit + 1;
            end
        else
            merit = merit + 0.25;
        end
        
        total_score(i) = merit - demerit + total_score(i-1);
        %disp(['platoon_', num2str(j), '_score(', num2str(i), ') = ', num2str(total_score(i))]);
    end
    
    plot(1:i, total_score(1:i), '-o'); % plot the total score for the platoon
    %total_scores(j) = total_score(end); % store the total score for the platoon
end

hold off; % disable "hold on"

%% For increasing Fonts
hold on;
set(findall(gca, 'Type', 'Line'),'LineWidth',3);

ax = gca;
ax.FontSize = 22;

%% For Different Legends
leg = legend('\alpha = 1','\alpha = 0.8','\alpha = 0.6','\alpha = 0.4', '\alpha = 0.2');
leg.FontSize = 24;

xlabel('Time','FontSize',24);
ylabel('Total Score of Platoon','FontSize',24);
title('Total Scores for All Platoons with time','FontSize',24);
legend('Platoon 1', 'Platoon 2', 'Platoon 3', 'Platoon 4','best','FontSize',24);
