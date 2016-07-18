function [Klmnn,knn,outdim,maxiter]=findLMNNparams(xTr,yTr,xVa,yVa,varargin)
%function [Klmnn,knn,outdim,maxiter]=findLMNNparams(xTr,yTr,xVa,yVa,varargin)
% This function automatically finds the best hyper-parameters for LMNN
% Please see demo2.m for a use case. 
%
% copyright Kilian Weinberger 2015

startup;

%% create valiadation data set 
if nargin>=4 && isstr(xVa),  % oops, xVa is a parameter not a validation set
        for i=length(varargin):-1:1
            varargin{i+2}=varargin{i};
        end;
        varargin{1}=xVa;
        varargin{2}=yVa;        
        clear('xVa','yVa');
end;



%% Setting parameters for Bayesian Global Optimization
opt = defaultopt(); % Get some default values for non problem-specific options.
%%min/max for Klmnn Kknn   OUTDIM  MAXITER
opt.mins =  [ 1,    1    min(size(xTr,1),2)  10]; % Minimum value for each of the parameters. Should be 1-by-opt.dims
opt.dims = length(opt.mins); % Number of parameters.
opt.max_iters = 12; % How many parameter settings do you want to try?
opt.grid_size = 20000;
opt.maxK=15;
opt.maxLMNNiter=200;
opt.averages=1;
opt=extractpars(varargin,opt);

opt.maxes = [ opt.maxK,   opt.maxK   size(xTr,1)    opt.maxLMNNiter]; % Vector of maximum values for each parameter. 


%% split off val
if ~exist('xVa','var'),
	[train,val]=makesplits(yTr,0.8,opt.averages,opt.maxK);
    x=xTr;
    y=yTr;
else
    train=1:length(yTr);
    val=length(yTr)+1:length(yTr)+length(yVa);
    x=[xTr xVa];
    y=[yTr yVa];
end;

%% Start the optimization
F = @(P) optimizeLMNN(x,y,train,val,P); % CBO needs a function handle whose sole parameter is a vector of the parameters to optimize over.
[bestP,mv,T] = bayesopt(F,opt);   % ms - Best parameter setting found
                               % mv - best function value for that setting L(ms)
                               % T  - Trace of all settings tried, their function values, and constraint values.


Klmnn=round(bestP(1));
knn=round(bestP(2));
outdim=ceil(bestP(3));
maxiter=ceil(bestP(4));
fprintf('\nBest parameters: K(LMNN)=%i K(knn)=%i  outdim=%i maxiter=%i!\n',Klmnn,knn,outdim,maxiter);


function valerr=optimizeLMNN(x,y,train,val,P)
%function valerr=optimizeLMNN(xTr,yTr,xVa,yVa,P)

outdim=ceil(P(3));
knn=round(P(2));
K=round(P(1));
maxiter=ceil(P(4));
fprintf('\nTrying K(lmnn)=%i K(knn)=%i outdim=%i maxiter=%i ...\n',K,knn,outdim,maxiter);
for i=1:size(train,1)
 [L,~] = lmnnCG(x(:,train(i,:)), y(train(i,:)),K,'maxiter',maxiter,'quiet',1,'outdim',outdim);
 valerr(i,:)=knncl(L,x(:,train(i,:)), y(train(i,:)),x(:,val(i,:)), y(val(i,:)),knn,'train',0);
end;
valerr=mean(valerr,1);
fprintf('\nvalidation error=%2.4f\n',valerr);
