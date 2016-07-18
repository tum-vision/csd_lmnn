function [ Xtrain, Ltrain, Xtest, Ltest ] = define_learningset( X, GT, ratio, shuffle )
%DEFINE_LEARNINGSET Summary of this function goes here
%   X       - (nxd) inputs matrix
%   GT      - (nx1) labels vector
%   ratio   - (double) ratio by which to split the dataset 
%   shuffle - (boolean) whether to shuffle the dataset or not (default: true)
 
if nargin < 4, shuffle = true; end

% Shuffle dataset
if shuffle
    n = length(GT);
    perm = randperm(n);
    X = X(perm, :);
    GT = GT(perm);
end


% Split dataset
Labels = double(GT);
trainIdx = define_trainingset(Labels, ratio);
testIdx = ~trainIdx;

% Return subsets
Xtrain = X(trainIdx, :);
Ltrain = Labels(trainIdx);
Xtest = X(testIdx,:);
Ltest = Labels(testIdx);


end

