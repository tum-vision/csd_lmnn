function [ trainingsetidx ] = define_trainingset( gtlabels, ratio )
%DEFINE_TRAININGSET Summary of this function goes here
%   Split a dataset in 2 disjoint subsets according to ratio

if ratio == 1
    trainingsetidx = true(size(gtlabels));
    return;
end


% Get generator settings.
warning('off','MATLAB:RandStream:ActivatingLegacyGenerators')
s = rng;
rng(0,'v4')

trainingsetidx = false(size(gtlabels));
uniqueLabels = unique(gtlabels);

for i = 1:length(uniqueLabels)
    iscurlabel = (gtlabels == uniqueLabels(i)); % get current label instances
    numinstances = nnz(iscurlabel);             % count class instances
    sel = randsample(find(iscurlabel),ceil(ratio*numinstances));    % randomly sample ratio of class instances
    trainingsetidx(sel) = 1;                                        
end


% Restore previous generator settings.
rng(s);
warning('on','MATLAB:RandStream:ActivatingLegacyGenerators')



end

