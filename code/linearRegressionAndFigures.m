% This code generates all linear regression models of Rosenke et al. (201X),
% published in XXXX, doi: XXXXXXXX
% This code assumes that you are in the /code/ directory of the cloned/downloaded
% "faceHands" github repository.
%
% ---- Specify in line 17 which model/figure to run ----
%
% MR Nov 2018

%% initialization
clearvars
clc
addpath(genpath('../code/helperFunctions/'))
load('../data/roiBetas.mat')
load('../data/behavior.mat')

type = 'Fig4cde_Fig5'; % options are: 'Fig4cde_Fig5','Fig6b','suppFig2abc','suppFig3','suppFig4'

%% z-score ROI betas
yb = [];
for s = 1:size(roi_glm,1)
    for r = 1:size(roi_glm,2)
        if(~isempty(roi_glm(s,r).betas))
            yb(s,:,r) = zscore(roi_glm(s,r).betas);
        else
            yb(s,:,r) = NaN;
        end
    end
end

%% specify models
modelspec = [];

switch type
    case 'Fig4cde_Fig5'
        wsbs = 'ws';
        modelspec(1).m = 'behavior ~ rh_mFus';
        modelspec(2).m = 'behavior ~ rh_pFus';
        modelspec(3).m = 'behavior ~ rh_OTS';
        modelspec(4).m = 'behavior ~ rh_pFus+rh_OTS';
    case 'Fig6b'
        wsbs = 'bs';
        modelspec(1).m = 'behavior ~ rh_pFus+rh_OTS';
    case 'suppFig2abc'
        wsbs = 'ws';
        modelspec(1).m = 'behavior ~ lh_mFus';
        modelspec(2).m = 'behavior ~ lh_pFus';
        modelspec(3).m = 'behavior ~ lh_OTS';
        modelspec(4).m = 'behavior ~ lh_pFus+lh_OTS';
        modelspec(5).m = 'behavior ~ lh_V02+lh_CoS';
        modelspec(6).m = 'behavior ~ rh_V02+rh_CoS';
    case 'suppFig3'
        wsbs = 'ws';
        modelspec(1).m = 'behavior ~ lh_mFus';
        modelspec(2).m = 'behavior ~ rh_mFus';
        modelspec(3).m = 'behavior ~ lh_pFus';
        modelspec(4).m = 'behavior ~ rh_pFus';
        modelspec(5).m = 'behavior ~ lh_OTS';
        modelspec(6).m = 'behavior ~ rh_OTS';
    case 'suppFig4'
        wsbs = 'bs';
        modelspec(1).m = 'behavior ~ lh_pFus+lh_OTS';
        modelspec(2).m = 'behavior ~ rh_pFus+rh_OTS';
        modelspec(3).m = 'behavior ~ lh_V02+lh_CoS';
        modelspec(4).m = 'behavior ~ rh_V02+rh_CoS';
end

%% build table for linear regression

% prepare table
neuralD = [];
for r = 1:length(rois)
    temp = yb(:,:,r);
    neuralD = [neuralD temp(:)];
end

behav = categorization(:);
subj = repmat(1:14,1,5)';
ml = repmat(1:5,14,1);
ml = ml(:);

t = array2table([ ml subj behav neuralD],...
    'VariableNames',{'morph', 'subject', 'behavior', 'lh_mFus', 'lh_OTS','lh_pFus'...
    'rh_mFus','rh_OTS','rh_pFus','lh_V02','rh_V02','lh_CoS','rh_CoS'})

%% run the models specified above

switch wsbs
    
    case 'ws' % within-subject models, relating brain to behavior          
        rcollect = []; namecollect = []; r = [];
        rmse = []; coefficients_all = [];
        % loop over all specified models for that analysis
        for m = 1:length(modelspec)
            if strfind(modelspec(m).m,'rh_pFus+rh_OTS')
                figure('Color',[1 1 1],'Name',modelspec(m).m(12:end),'units','norm', 'position', [ 0.1 .1 .4 .4]);
            elseif strfind(type,'suppFig3')
                figure('Color',[1 1 1],'Name',modelspec(m).m(12:end),'units','norm', 'position', [ 0.1 .1 .4 .4]);
            end
            c = 1;
            % run the model and plot it
            ypred = []; coefficients = []; pvalues = [];
            for ind = 1:length(unique(t.subject))
                traindata = t(t.subject==ind,:);
                temp = modelspec(m).m(12:end);
                temp = strsplit(temp,'+');
                notnan = 1;
                for ii = 1:length(temp)
                    if(isnan(traindata.(temp{ii})))
                        notnan = 0;
                    end
                end
                if notnan
                    mdl = fitlm(traindata,modelspec(m).m)
                    aic(ind,m) = mdl.ModelCriterion.AIC;
                    r(ind,m) = mdl.Rsquared.Ordinary;
                    
                    r_adj(ind) = mdl.Rsquared.Adjusted;
                    ypred(:,ind) = predict(mdl,traindata)
                    
                    % calculate mean square error
                    err = ypred(:,ind) - traindata.behavior;
                    sqerr = err.^2;
                    meansqerr = mean(sqerr);
                    rmse(ind,m) = sqrt(meansqerr);
                    
                    pvalues(:,ind) = mdl.Coefficients.pValue;
                    coefficients(:,ind) = mdl.Coefficients.Estimate;
                    coefficients_all{m} = coefficients;
                    temp = corrcoef(ypred(:,ind),categorization(ind,:));
                    corr_pred_cat(ind,m) = temp(1,2);
                    
                    if strfind(modelspec(m).m,'rh_pFus+rh_OTS')
                        subplot(3,5,c)
                        plot(1:5,categorization(ind,:),'k',1:5,ypred(:,ind)','--','Color',[round(10/255,2),round(200/255,2),round(25/255,2)],'LineWidth',1.5);
                        box off;
                        ax = gca;
                        ax.YLim = [-0.5 1.5];
                        ax.XTick = [0:6];
                        ax.XTickLabel = {' ' '1' '2' '3' '4' '5' ' '};
                        c = c+1;
                        title(['R^2: ' num2str(round(corr_pred_cat(ind,m)^2,2))]);
                        ax.FontSize = 12;
                        ax.YTick = [0:1:1];
                    elseif strfind(type,'suppFig3')
                        subplot(3,5,c)
                        plot(1:5,categorization(ind,:),'k',1:5,ypred(:,ind)','--','Color',[round(10/255,2),round(200/255,2),round(25/255,2)],'LineWidth',1.5);
                        box off;
                        ax = gca;
                        ax.YLim = [-0.5 1.5];
                        ax.XTick = [0:6];
                        ax.XTickLabel = {' ' '1' '2' '3' '4' '5' ' '};
                        c = c+1;
                        title(['R^2: ' num2str(round(corr_pred_cat(ind,m)^2,2))]);
                        ax.FontSize = 12;
                        ax.YTick = [0:1:1];
                    end
                else
                    aic(ind,m) = NaN;
                    corr_pred_cat(ind,m) = NaN;
                    temp = NaN(5,1);
                    ypred(:,ind) = temp;
                    r(ind,m) = NaN;
                    r_adj(ind) = NaN;
                    pvalues(:,ind) = NaN(length(mdl.Coefficients.pValue),1);
                    coefficients(:,ind) = NaN(length(mdl.Coefficients.pValue),1);
                end
            end
            rcollect = [rcollect round(nanmean(r),2)];
            temp = modelspec(m).m(12:end);
            temp= strrep(temp,'_', ' ');
            namecollect{m} = temp;
            i = i+1;
            
        end
        r_within = r;
        
        if strcmp(type,'Fig4cde_Fig5')
            BarPlotIndivDots_r2plot(r,namecollect,1,'R^2',[0 1],20,'')
            fh_linegraph(r(:,[3:4]),namecollect(3:4),0,'R^2',[0 1],18,'')
            fh_linegraph(r(:,[2,4]),namecollect([2,4]),0,'R^2',[0 1],18,'')
            BarPlotIndivDots_coeff(coefficients([3,2],:)',{'pFus','OTS'},0,'beta coefficient',[-.6 .8],27,'')
        elseif strfind(type,'suppFig2abc')
            BarPlotIndivDots_r2plot(r,namecollect,1,'R^2',[0 1],20,'')
        end
        
    case 'bs' % cross-validated between-subject model, leave-subject-out
        namecollect = []; coefficients_all = [];
        r2pred = NaN(length(unique(t.subject)),length(modelspec));
        for m = 1:length(modelspec)
            if strcmp(type,'Fig6b')
                figure('Color',[1 1 1],'Name',modelspec(m).m(12:end),'units','norm', 'position', [ 0.1 .1 .4 .4]);
            end
            c = 1;
            % run the crossvalidated model and plot it
            ypred = []; coefficients = []; pvalues = [];
            for ind = 1:length(unique(t.subject))
                testdata = t(t.subject==ind,:);
                traindata = t(t.subject~=ind,:);
                
                mdl = fitlm(traindata,modelspec(m).m)
                aic(ind,m) = mdl.ModelCriterion.AIC;
                ypred(:,ind) = predict(mdl,testdata);
                [ypred(:,ind) testdata.behavior]
                temp = corrcoef(ypred(:,ind),testdata.behavior)
                r2pred(ind,m) = temp(2,1)^2; r2pred(ind,m)
                pvalues(:,ind) = mdl.Coefficients.pValue;
                coefficients(:,ind) = mdl.Coefficients.Estimate;
                coefficients_all{m} = coefficients;
                
                if strcmp(type,'Fig6b')
                    if(mean(ypred(:,ind))>0)
                        subplot(3,5,c)
                        plot(1:5,categorization(ind,:),'k',1:5,ypred(:,ind)','--','Color',[round(102/255,2),round(178/255,2),round(255/255,2)],'LineWidth',1.5);
                        box off;
                        ax = gca;
                        ax.YLim = [-0.5 1.5];
                        ax.XTick = [0:6];
                        ax.XTickLabel = {' ' '1' '2' '3' '4' '5' ' '};
                        ax.FontSize = 12;
                        ax.YTick = [0:1:1];
                        title(['R^2: ' num2str(round(r2pred(ind,m),2))]);
                        c = c+1;
                    end
                end
            end
            temp = modelspec(m).m([12:end]);
            temp= strrep(temp,'_', ' ');
            namecollect{m} = temp;
            i = i+1;
        end
        if strcmp(type,'suppFig4')
            BarPlotIndivDots_r2plot(r2pred,namecollect,1,'R^2',[0 1],20,'')
        end
end

% clean up workspace
clearvars ans c i ind m r s temp type subj ii meansqerr notnan ax