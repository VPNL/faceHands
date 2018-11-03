% This code produces Figure 1b of Rosenke et al. (201X), published in XXXX,
% doi: XXXXXXXX
% This code assumes that you are in the /code/ directory of the cloned/downloaded
% "faceHands" github repository.
%
% MR Nov 2018


%% initialization
clearvars
load('../data/facehandLikenessRatings.mat')
% input files each have 3 columns:
% (1) morph level (1-5)
% (2) exemplar (1-60)
% (3) mTurk worker rating (1-5)

avg_facelike = [];
se_facelike = [];

%% compute mean and standard error for face- and hand-likeness ratings

for i = 1:5 % for each morphing level
    temp = facelike(facelike(:,1)==i,3);
    avg_facelike(i) = mean(temp);
    se_facelike(i) = std(temp)/sqrt(numel(temp));
end

avg_handlike = [];
se_handlike = [];
for i = 1:5 % for each morphing level
    temp = handlike(handlike(:,1)==i,3);
    avg_handlike(i) = mean(temp);
    se_handlike(i) = std(temp)/sqrt(numel(temp));
end

%% plot how face-/hand-like
figure('Color', [1 1 1],'units','norm', 'position', [ 0.1 .1 .25 .3]);

errorbar(avg_facelike,se_facelike , 'Color',[.6 0 0], 'linewidth', 2);
hold on
errorbar(avg_handlike,se_handlike , 'Color',[0 .6 0], 'linewidth', 2);
box off
ax = gca;
ax.XTick = [1:1:5];
ax.YTick = [1:1:5];
ax.YLim = [1,5.1];
ax.FontSize = 25;
ax.LineWidth = 1;

% clean up workspace
clearvars ax i temp facelike handlike