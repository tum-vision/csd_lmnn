clear all;
cd ..
setpaths3
cd demos

disp('Warning, the autotuning demonstrated in this demo is still experimental. Updates will follow soon...');

%% load data
try  
    load bal.mat
catch  % if it fails, download it from the web
    disp('Downloading data ...');
    urlwrite('https://dl.dropboxusercontent.com/u/4284723/DATA/bal.mat','bal.mat');
    load bal.mat
end;


%% tune parameters
disp('Setting hyper parameters');
[K,knn,outdim,maxiter]=findLMNNparams(xTr,yTr,'averages',3,'maxK',20);
%K=20;
%knn=3;
%maxiter=8;

%% train full muodel
fprintf('Training final model...\n');
[L,Details] = lmnnCG(xTr, yTr,K,'maxiter',maxiter);


testerrEUC=knncl([],xTr,yTr,xTe,yTe,1,'train',0);
testerrLMNN=knncl(L,xTr,yTr,xTe,yTe,1,'train',0);
fprintf('Bal data set\n');
fprintf('\n\nTesting error before LMNN: %2.2f%%\n',100.*testerrEUC);
fprintf('Testing error after  LMNN: %2.2f%%\n',100.*testerrLMNN);



