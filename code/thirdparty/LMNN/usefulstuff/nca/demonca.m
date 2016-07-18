clear all;
setpaths

disp('Warning, the autotuning demonstrated in this demo is still experimental. Updates will follow soon...');

%% load data
try  
    load bal.mat
catch  % if it fails, download it from the web
    disp('Downloading data ...');
    urlwrite('https://dl.dropboxusercontent.com/u/4284723/DATA/bal.mat','bal.mat');
    load bal.mat
end;



%% train full muodel
fprintf('Training final model...\n');
[L,loss] = simpleNCA(xTr, yTr,'maxiter',100,'outdim',4);

testerrEUC=knncl([],xTr,yTr,xTe,yTe,1,'train',0);
testerrNCA=knncl(L,xTr,yTr,xTe,yTe,1,'train',0);
fprintf('Bal data set\n');
fprintf('\n\nTesting error before NCA: %2.2f%%\n',100.*testerrEUC);
fprintf('Testing error after  NCA: %2.2f%%\n',100.*testerrNCA);
fprintf('(NCA works great on such small data sets.)\n');

