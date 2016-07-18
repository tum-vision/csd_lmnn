clear all;
cd ..
setpaths3
cd demos

%% load data
try  
    load usps.mat
catch  % if it fails, download it from the web
    disp('Downloading data ...');
    urlwrite('https://dl.dropboxusercontent.com/u/4284723/DATA/usps.mat','usps.mat');
    load usps.mat
end;

%% perform PCA and split data into train/val/test
disp('Performing PCA (keeping 95% of variance)');
[u,v]=pca(xTr);
d95=find(cumsum(v)./sum(v)<0.95);
mtr=mean(xTr,2);
xTr=10.*u(d95,:)*bsxfun(@minus,xTr,mtr);
xTe=10.*u(d95,:)*bsxfun(@minus,xTe,mtr);


%% tune parameters
disp('Getting started');
% These parameters were found with the following search command:
%[K,knn,outdim,maxiter]=findLMNNparams(xTr,yTr); 
K=3;
knn=1;
outdim=32;
maxiter=60;


%% train full muodel
fprintf('Training final model...\n');
[L,Details] = lmnnCG(xTr, yTr,K,'maxiter',maxiter,'outdim',outdim);
testerr=knncl(L,xTr,yTr,xTe,yTe,knn,'train',0);
fprintf('\n\nTesting error: %2.2f%%\n',100.*testerr);


