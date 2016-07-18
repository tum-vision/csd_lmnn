clear all;
cd ..
setpaths3
cd demos

%% load data
try  
    load mnistPCA.mat
catch  % if it fails, download it from the web
    disp('Downloading data ...');
    urlwrite('https://dl.dropboxusercontent.com/u/4284723/DATA/mnistPCA.mat','mnistPCA.mat');
    load mnistPCA.mat
end;


%% tune parameters
disp('Setting hyper parameters');
K=3;
knn=3;
outdim=300;
maxiter=120; % will converge earlier

%% train full muodel
fprintf('Training final model...\n');
[L,Details] = lmnnCG(xTr, yTr,K,'maxiter',maxiter,'outdim',outdim);
testerr=knncl(L,xTr,yTr,xTe,yTe,knn,'train',0);
fprintf('\n\nTesting error: %2.2f%%\n',100.*testerr);


