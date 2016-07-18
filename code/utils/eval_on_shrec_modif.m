function [ shrecres ] = eval_on_shrec_modif( Distances, Labels, plotPR )
%EVAL_ON_SHREC_MODIF Summary of this function goes here
%   Use SHREC evaluation code

if nargin < 3
    plotPR = 0;
end

classSize = nnz(Labels == Labels(1));

n = size(Distances,1);
simrankings = zeros(n, n-1);
clarankings = zeros(n, classSize-1);

[~, sortedDistances] = sort(Distances);
sortedDistances = sortedDistances';

for i=1:n
    rankingsi = sortedDistances(i,:);
    rankingsi(rankingsi==i) = []; % remove self similarity
    simrankings(i,:) = rankingsi;
    clarankings(i,:) = rankingsi(1:(classSize-1));
end


simtask = 1;
simres = SHREC14Eval_modif(simrankings, Labels, simtask);

clatask = 2;
clares = SHREC14Eval_modif(clarankings, Labels, clatask);


shrecres = simres;
shrecres.fm = clares.fm;


if plotPR
    figure;
    plot(shrecres.R, shrecres.P);
    xlabel('Recall');
    ylabel('Precision');
    axis([0 1 0 1]);
end

end

