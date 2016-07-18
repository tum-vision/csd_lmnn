function [ h ] = plot_spaceofshapes( X, GT, plotlegend, pointLabels )
%PLOT_SPACEOFSHAPES Summary of this function goes here
%   Make a scatter plot of a dataset, coloring each sample according to the
%   groundtruth labels GT. Optionally give a legend for the figure and 
%   labels for the samples

[N, dataDim] = size(X);

n = length(GT);
if n < N
    dummyLabel = max(unique(GT)) + 1;
    GT = [double(GT); ones(N-n,1)*double(dummyLabel)];
end


dx = 0;

colormap(jet);

if (dataDim==1)
    h = scatter(1:n, X, 10, GT);
elseif (dataDim==2)
    h = scatter(X(:,1),X(:,2), 10, GT); %axis off, axis equal, drawnow
    if nargin > 4, text(X(:,1)+dx, X(:,2)+dx, pointLabels); end
elseif (dataDim>=3)
    h = scatter3(X(:,1),X(:,2), X(:,3), 10, GT); %axis off, axis equal, drawnow
    if nargin > 4, text(X(:,1)+dx, X(:,2)+dx, X(:,3)+dx, pointLabels); end
end

global CUR;
datasetName = strrep(CUR.DATASET, '_', ' ');
datasetName = [datasetName(1:5) '''' datasetName(6:end)];

colorbar;
if nargin > 2
    legend(sprintf(plotlegend), 'Location', 'Best');
end
title(datasetName);
end

