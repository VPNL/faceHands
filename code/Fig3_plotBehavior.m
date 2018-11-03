% This code produces Figure 3 of Rosenke et al. (201X), published in XXXX,
% doi: XXXXXXXX
% This code assumes that you are in the /code/ directory of the cloned/downloaded
% "faceHands" github repository.
%
% MR Nov 2018


%% initialization 

clearvars
load('../data/behavior.mat')

x = [1:5]';

%% Plot: Is it a face or hand?
figure('Color', [1 1 1]);

% plot average across subjects with error standard error in black
SE = nanstd(categorization);
errorbar(nanmean(categorization),SE , 'k', 'linewidth', 2);
hold on

% plot all individual subjects, color coded across all figures of the paper
color = jet(size(categorization,1)); 
for ind = 1:size(categorization,1)
plot(categorization(ind,:),'Color',color(ind,:),'LineWidth',1)
end


box off
ax = gca;
ax.XTick = [1:1:5];
ax.YTick = [0:.5:1];
ax.FontSize = 18;
ylabel('Proportion face response');

% clean up workspace
clearvars ax color ind x SE
