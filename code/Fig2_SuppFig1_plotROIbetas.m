% This code produces Figure 2 and Supplementary Figure 1 of Rosenke et al. (201X),
% published in XXXX, doi: XXXXXXXX
% This code assumes that you are in the /code/ directory of the cloned/downloaded
% "faceHands" github repository.
%
% MR Nov 2018


%% initialization 
clearvars
load('../data/roiBetas.mat')

%% z-score betas
yb = [];
for r = 1:6
    for s = 1:size(roi_glm,1)       
        if(~isempty(roi_glm(s,r).betas))
           yb{r}(s,:) = zscore(roi_glm(s,r).betas);
        else
            yb{r}(s,:) = NaN;
       end
    end
end


%% plot ROI betas
figure('color',[1 1 1],'units','norm', 'position', [ 0.1 .1 .4 .3]);

for i = 1:length(yb)
    f(i) = subplot(2,3,i)
    if(~isempty(strfind(rois{i},'OTS')))
        color = [0 0.6 0];
    else
        color = [.6 0 0];
    end
    
    SE = nanstd(yb{i})/sqrt(size(yb{i},1));
    errorbar(nanmean(yb{i}),SE , 'Color',color, 'linewidth', 2);
   
    ax = gca;
    ax.XTick = 1:1:5;
    ax.FontSize = 13;
    ax.YLim = [-1.5 1.5];
    ax.XLim = [0 size(yb{i},2)+1];                                                     
    ylength(i) = ax.YLim(2);
    if (i == 1 || i == 4)
        ylabel('z-scored beta values')
    end
    t = title(rois{i})
    set(t, 'Interpreter', 'none')
    box off;
end

% clean up workspace
clearvars ax color i r s t ylength f SE

