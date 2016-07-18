clear all;
cd ..
setpaths3
cd demos

%% load data
try  
    load isolet.mat
catch  % if it fails, download it from the web
    disp('Downloading data ...');
    urlwrite('https://dl.dropboxusercontent.com/u/4284723/DATA/isolet.mat','isolet.mat');
    load isolet.mat
end;

%% perform PCA and split data into train/val/test
disp('Performing PCA (keeping 95% of variance)');
xtv=x(:,[crossValidation{1}.train crossValidation{1}.valid]);
[u,v]=pca(xtv);
d95=find(cumsum(v)./sum(v)<0.95);
x=bsxfun(@minus,x,mean(xtv,2)); % remove mean
x=u(d95,:)*x;

xTr=x(:,crossValidation{1}.train);
xVa=x(:,crossValidation{1}.valid);
xTe=x(:,crossValidation{1}.test);
yTr=y(:,crossValidation{1}.train);
yVa=y(:,crossValidation{1}.valid);
yTe=y(:,crossValidation{1}.test);

%% tune parameters
disp('Getting started');
% These parameters were found with the following search command:
%[Klmnn,Kknn,outdim,maxiter]=findLMNNparams(xTr,yTr,xVa,yVa)
Klmnn=15;
Kknn=3;
outdim=68;
maxiter=120;

%% train full muodel
fprintf('Training final model...\n');
[L,Details] = lmnnCG([xTr xVa], [yTr yVa],Klmnn,'maxiter',maxiter,'outdim',outdim);
testerr=knncl(L,xTr,yTr,xTe,yTe,Kknn,'train',0);
fprintf('\n\nTesting error: %2.2f%%\n',100.*testerr);


