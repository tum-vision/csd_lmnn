function results = SHREC14Eval_modif(rankings, C, task)
% SHREC14Eval(inRank, inCla, outResult)
% Evaluated the results of a method submitted to the SHREC 14 Non-Rigid
% Human Models track (Pickup et al.).
% Variables:
% results - statistical results.
% inRank - filename of file containing the retrieval rankings.
% inCla - filename of the .cla classification file.
%
% rankings - nx(n-1) double matrix with similarities
% C - nx1 vector with class labels (starting from 1)
%
% outStats - name of file to output statistical measures to.
% outPR - name of file to output precision-recall graph to (can be ploted using gnuplot).
% task - 1 or 2 (see track report for difference).
%
% David Pickup 2014

%C = readClassification(inCla);

% Open output file.
%fid = fopen(outStats, 'w');

%
%   Modified to just return the results, without saving to file
%   John Chiotellis 2015, TUM
%

%% Task 1
if task == 1
    
    %rankings = importdata(inRank);
    if min(min(rankings)) == 0
        rankings = rankings + 1;
    end
    if (size(rankings,2) == size(rankings,1))
        rankings = rankings(:,2:end);
        warning('Result matrix is square (result contains query).');
    end

    results.nn = nearestNeighbour(rankings,C);
    results.ft = firstTier(rankings,C);
    results.st = secondTier(rankings,C);
    results.em = eMeasure(rankings,C);
    results.dcg = DCG(rankings,C);

%     fprintf(fid,'\t NN: %.4f\n', results.nn);
%     fprintf(fid,'\t 1-Tier: %.4f\n', results.ft);
%     fprintf(fid,'\t 2-Tier: %.4f\n', results.st);
%     fprintf(fid,'\t E-measure: %.4f\n', results.em);
%     fprintf(fid,'\t DCG: %.4f\n', results.dcg);

%     fidPR = fopen(outPR, 'w');
    Pi = zeros(size(rankings,2),1);
    Ri = Pi;
    for m = 1:size(rankings,1)
        for i = 1:size(rankings,2)
            Pi(i) = precisionSingle(rankings,C,i,m);
            Ri(i) = recallSingle(rankings,C,i,m);
        end
        [~,ia,~] = unique(Ri);
        sort(ia);
        idx = find(Ri==0);
        ia(ismember(ia,idx)) = [];
        if m == 1
            P = Pi(ia);
            R = Ri(ia);
        else
            P = P + Pi(ia);
            R = R + Ri(ia);
        end
    end
    R = R./size(rankings,1);
    P = P./size(rankings,1);
    R = [0;R];
    P = [1;P];
    results.P = P;
    results.R = R;
%     for i = 1:numel(P)
%         fprintf(fidPR,'%f\t%f\n', R(i), P(i));
%     end
%     fclose(fidPR);
end

%% Task 2
if task == 2
%    rankings = dlmread(inRank);
    if min(min(rankings)) == 0
        rankings = rankings + 1;
    end

    results.fm = fMeasure(rankings,C);

%     fprintf(fid,'\t F-measure: %.4f\n', results.fm);
end

%% End.
% fclose(fid);

return;

%% Functions
function P = precision(rankings,C,n)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    idx = find(C(rankings(i,1:n)) == C(i));
    count = count + (numel(idx) / n);
end
P = count / nModels;
return;

function R = recall(rankings,C,n)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    idx = find(C==C(i));
    nClass = numel(idx)-1;
    idx = find(C(rankings(i,1:n)) == C(i));
    count = count + (numel(idx) / nClass);
end
R = count / nModels;
return;

function P = precisionSingle(rankings,C,n,m)
idx = find(C(rankings(m,1:n)) == C(m));
P = (numel(idx) / n);
return;

function R = recallSingle(rankings,C,n,m)
idx = find(C==C(m));
nClass = numel(idx)-1;
idx = find(C(rankings(m,1:n)) == C(m));
R = (numel(idx) / nClass);
return;

function NN = nearestNeighbour(rankings,C)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    if C(i) == C(rankings(i,1))
        count = count + 1;
    end
end
NN = count / nModels;
return;

function FT = firstTier(rankings,C)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    idx = find(C==C(i));
    nClass = numel(idx)-1;
    idx = find(C(rankings(i,1:nClass)) == C(i));
    count = count + (numel(idx) / nClass);
end
FT = count / nModels;
return;

function ST = secondTier(rankings,C)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    idx = find(C==C(i));
    nClass = (numel(idx)-1);
    idx = find(C(rankings(i,1:(2*nClass))) == C(i));
    count = count + (numel(idx) / nClass);
end
ST = count / nModels;
return;

function EM = eMeasure(rankings,C)
P = precision(rankings,C,32);
R = recall(rankings,C,32);
EM = 2 / ((1/P) + (1/R));
return;

function DCG = DCG(rankings,C)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    idx = find(C==C(i));
    nClass = numel(idx)-1;
    
    ideal = 1 + sum(1./log2(2:nClass));
    
    idx = find(C(rankings(i,:)) == C(i));
    tmp = find(idx == 1);
    if ~isempty(tmp)
        idx(tmp) = [];
        DCGi = 1 + sum(1./log2(idx));
    else
        DCGi = sum(1./log2(idx));
    end
    count = count + (DCGi / ideal);
end
DCG = count / nModels;
return;

function FM = fMeasure(rankings,C)
nModels = size(rankings,1);
count = 0;
for i = 1:nModels
    idx = find(rankings(i,:));
    if isempty(idx)
        continue;
    end
    r = rankings(i,idx);
    r(r==i) = [];
    
    idx = find(C==C(i));
    nClass = numel(idx)-1;
    idx = find(C(r) == C(i));
    if isempty(idx)
        continue;
    end
    P = numel(idx) / numel(r);
    R = numel(idx) / nClass;
    
    count = count + (2 * ((P*R) / (P+R)));
end
FM = count / nModels;
return;


% Uses code from Lian et al.'s SHREC'11 non-rigid track.
function C = readClassification(fname)
fp = fopen(fname,'r');

%Check file header
strTemp = fscanf(fp,'%s',1);
if ~strcmp(strTemp,'PSB')
    display('The format of your classification file is incorrect!');
    return;
end
strTemp = fscanf(fp,'%s',1);
if ~strcmp(strTemp,'1')
    display('The format of your classification file is incorrect!');
    return;
end

numCategories = fscanf(fp,'%d',1);
numTotalModels = fscanf(fp,'%d',1);

testCategoryList.numCategories = numCategories;
testCategoryList.numTotalModels = numTotalModels;

currNumTotalModels = 0;

C = [];

for i=1:numCategories
    currNumCategories = i;
    testCategoryList.categories(currNumCategories).name = fscanf(fp,'%s',1);
    fscanf(fp,'%d',1);
    numModels = fscanf(fp,'%d',1);
    testCategoryList.categories(currNumCategories).numModels = numModels;
    for j=1:numModels
        currNumTotalModels = currNumTotalModels+1;
        testCategoryList.modelsNo(currNumTotalModels) = fscanf(fp,'%d',1)+1;
        testCategoryList.classNo(currNumTotalModels) = currNumCategories;
        C(testCategoryList.modelsNo(currNumTotalModels)) = ...
            testCategoryList.classNo(currNumTotalModels);
    end
end

if (currNumTotalModels~=numTotalModels)
    display('The format of your classification file is incorrect!');
    return;
else
    display('The format of your classification file is correct!');
end
fclose(fp);
return;