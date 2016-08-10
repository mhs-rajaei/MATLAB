function draw_MSE(Y1)
%CREATEFIGURE(Y1)

% Create figure
figure10 = figure;

% Create axes
axes1 = axes('Parent',figure10);
hold(axes1,'on');

% Create plot
plot(Y1,'DisplayName','MSE','LineWidth',3,'LineStyle','-.',...
    'Color',[0.85 0.32 0.1]);

% Create xlabel
xlabel({'Epoch'});

% Create ylabel
ylabel({'MSE'});

% Create title
title({'MSE'});

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XGrid','on','YGrid','on');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.83 0.86 0.06 0.036]);

