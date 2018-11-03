function fh_linegraph( values, x_labels,tilt, y_label,ylim, lettersize,t,varargin )
%create a bar graph with as many bars as entries in Values
%   x_Labels = cells with names for x-axis
%   tilt = true or false ( 1 or 0) if x-axis should be tilted 90 degrees
%   values = (double) columns for each entry which means is to be plotted, number of
%   columns defines how many bars, rows are single values within each bar
%   y_label = string
%   lettersize integer defining the size of x axis labels
%   t = title, string
% can enter: chance level mean and std and transparency for plotting (see
% line 45 and 46)
%
% MR Apr 2018
    
    nrval = size(values,2);
    x = [1:nrval];
    
    load('../data/subjectColors.mat')
    color = mycolors; 
    
    values = [values(1:4,:);values(8:11,:);values(13:14,:)];
    colorstotake = [1 2 3 4 8 9 10 11 13 14];
    
    f = figure('color',[1 1 1],'units','norm', 'position', [ 0.1 .1 .2 .5]);
    
    
    for ind = 1:size(values,1)
         h = line([1:size(values,2)],values(ind,:),'LineWidth',2','Color',color(colorstotake(ind),:));
         hold on
    end
  

    ax = gca;
    ax.YLim = ylim;
    ax.XLim = [0.9 size(values,2)+.1];
    ax.XTick = x;
    ax.YTick = [0 .2 .4 .6 .8 1];
    ax.XTickLabel = x_labels;
    ax.FontSize = lettersize;
    if(tilt)
    ax.XTickLabelRotation=45;
    end
    
    ylabel(y_label)
    tr = title(t);
    set(tr, 'Interpreter', 'none')
    if ~isempty(varargin)
        chancelevel = varargin{1};
        chancestd = varargin{2};
        transparency = varargin{3};
        hold on
         y2 = repmat(chancelevel,nrval+2,1);
        SE = repmat(chancestd,nrval+2,1); %se
        xi = [0:nrval+1]'
        f = fill([xi;flipud(xi)],[y2-SE;flipud(y2+SE)],[.7 0 0],'linestyle','none');
        line(xi,y2, 'LineWidth',1,'Color',[0.5 0 0])
        set(f, 'FaceAlpha', transparency);
        
                hold on
         y2 = repmat(abs(chancelevel),nrval+2,1);
        SE = repmat(chancestd,nrval+2,1); %se
        xi = [0:nrval+1]'
        f = fill([xi;flipud(xi)],[y2-SE;flipud(y2+SE)],[.7 0 0],'linestyle','none');
        line(xi,y2, 'LineWidth',1,'Color',[0.5 0 0])
        set(f, 'FaceAlpha', transparency);
    end

    box off;
end

