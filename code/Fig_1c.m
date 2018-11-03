% This code produces Figure 1b of Rosenke et al. (201X), published in XXXX,
% doi: XXXXXXXX
% This code assumes that you are in the /code/ directory of the cloned/downloaded
% "faceHands" github repository.
%
% MR Nov 2018

%% initialization
clearvars
load('../data/dissimilarityRatings.mat')
rem_o = 1;
levs = [1:5];
m=length(levs);
%% generate mean and SEM

% define means & sems for the mTurk round with 75% variability on the morph
% stimuli across exemplars within the same morph level
means = zeros(1,m);
sems  = zeros(1,m);
for lev1=levs
    k1 = find(dissimilarityRating75(:,1)==lev1);
    vk = dissimilarityRating75(k1,3);
    %remove outliers
    if rem_o == 1
        vkm = mean(vk);
        vke = std(vk);
        o = find(abs(vk-vkm)>2*vke);
        vk(o)=[];
    end
    means(lev1)=mean(vk);
    sems(lev1)=std(vk)/sqrt(length(vk));
end
means1 = means;
sems1 = sems;


% same as above but for 100% variability on the morph stimuli
means = zeros(1,m);
sems  = zeros(1,m);
for lev1=levs
    k1 = find(dissimilarityRating100(:,1)==lev1);
    vk = dissimilarityRating100(k1,3);
    %remove outliers
    if rem_o == 1
        vkm = mean(vk);
        vke = std(vk);
        o = find(abs(vk-vkm)>1.5*vke);
        vk(o)=[];
    end
    means(lev1)=mean(vk);
    sems(lev1)=std(vk)/sqrt(length(vk));
end
means2 = means;
sems2 = sems;


%% use the 75% variability stimuli for the face morph level, 100% for the others

finaldata_mean = [means2(1) means1(2:end)];
finaldata_se = [sems2(1) sems1(2:end)];

%% plot similarity ratings
figure(6); clf; set(gcf,'color','w','units','norm', 'position', [ 0.1 .1 .3 .3]);
set(gca,'FontSize',20);
errorbar([1:5],finaldata_mean,finaldata_se,'Color',[170/255 0 0],'linewidth',3);
xlabel('Morph level (1=face, 5=hand)');
ylabel('dissimilarity score (1-7)');
title('Calibrating dissimilarity');
ax = gca;
ax.FontSize = 18;
ax.LineWidth = 1;
set(gca,'xtick',[1:5]);
set(gca,'ytick',[1:2:7]);
axis([.9 5.1 0.5 7.5])
box off;

% clean up workspace
clearvars o rem_o means means sems vk vke vkm lev1 levs m k1 ax means1 means2 sems1 sems2




