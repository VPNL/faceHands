function BarPlotIndivDots_r2plot(values, x_labels,tilt, y_label,ylim, lettersize,t,varargin )

nrval = size(values,2);
x = [1:nrval];

f = figure('color',[1 1 1]);
 set(f,'Position',[10 10 size(values,2)*130 500])
h = bar(nanmean(values,1),0.5);
set(h(1),'FaceColor',[.8,.8,.8])
hold on

% load colors
load('../data/subjectColors.mat')

for ind = 1:size(values,1)
    plot([repmat(1:size(values,2),1,1)],values(ind,:),'o','LineWidth',2,'Color',mycolors(ind,:),'MarkerFaceColor',mycolors(ind,:))
end

ax = gca;
ax.YLim = ylim;
ax.YTick = 0:.2:1;
ax.XTickLabel = x_labels;
ax.FontSize = lettersize;
if(tilt)
    ax.XTickLabelRotation=45;
end
ax.XTick = x;
ylabel(y_label)
tr = title(t)
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

