function [L,Det]=lmnnCG(xTr,yTr,Kg,varargin)
% function [L,Det]=lmnnCG(x,y,Kg,'Parameter1',Value1,'Parameter2',Value2,...);
%
% Input:
% x = input matrix (each column is an input vector) 
% y = labels 
% Kg = attract Kg nearest similar labeled vectors 
% 
% Important Parameters:
% outdim = (default: size(x,1)) output dimensionality
% maxiter = maximum number of iterations (default: 1000)
% quiet = true/false surpress output (default=false)  
%
%
% Specific parameters (for experts only):
% initL = define initial matrix L to be passed in (default initL=[])
% thresh = termination criterion (default=1e-05)
% single = true/false performs most computations in sigle precision (default=true)
% GPU = true/false performs computation on GPU (default: false)
%
%
% Output:
%
% L = linear transformation xnew=L*x
%    
% Det.obj = objective function over time
% Det.nimp = number of impostors over time
% Det.pars = all parameters used in run
% Det.time = time needed for computation
% Det.iter = number of iterations
% Det.verify = verify (results of validation - if used) 
%  
% Version 3.0.0
% copyright by Kilian Q. Weinbergerr (2005-2015)
% Cornell University
% contact kilianweinberger@cornell.edu
%

global Gx
global Gy
global pars;

[d,n]=size(xTr);
% sanity tests:
if size(yTr,2)<size(yTr,1), yTr=yTr';end;
assert(size(yTr,2)==n,'There must be as many labels as inputs. (Each _column_ is an input.)')
assert(size(yTr,2)>0,'Data must be non-empty.');

minclass=min(diff(find(diff([min(yTr)-1 sort(yTr) max(yTr)+1]))));
if minclass<=Kg,
 Kg=min(Kg,minclass-1);
 fprintf('Warning: K too high. Setting K=%i\n',minclass-1);
end;

if exist('SODWsp','file')~=2,
	fprintf('Helperfunctions not in path ...\n')
	if exist('setpaths3.m','file')==2,
		fprintf('calling setpaths3.m ...\n')
		setpaths3();
	end;
	assert(exist('SODWsp','file')==2,'Please add directory helperfunctions to the path.')
end;


%% test if GPU is installed 
%% There seem to be compatibility problems with MATLAB GPU commands
%% please activate manually
% try 
%     gpuExists=gpuDevice();
%     xTr=gather(xTr); % check if 'gather' exists
%     pars.GPU=true;
% catch
%     pars.GPU=false;
% end;
pars.GPU=false;

%% Set default parameters
pars.thresh=1e-05; % optimality criterion
pars.maximp=500000;
pars.quiet=0;
pars.outdim=d;
pars.maxiter=50;
pars.Ki=0;
pars.initL=[];
pars.subsample=1; % hidden feature for large data - if <1 allow to subsample constraints
pars.single=true; % performs some computation in single precision
pars=extractpars(varargin,pars);


if pars.GPU,
    Gx=gpuArray((xTr));
    Gy=gpuArray(yTr);
else
    Gx=xTr;
    Gy=yTr;
end;
% perform computations in single precision if 'single' is true
if pars.single,
   Gx=single(Gx);
end;


% find initialization 
if isempty(pars.initL)
 L=pca(xTr)';
else
 L=pars.initL;
end;
L=L(1:pars.outdim,:);

try
tic;
 lmnnInit(xTr,yTr,Kg,pars);
 options.optTol=pars.thresh;
 options.MaxFunEvals=pars.maxiter;
 lmfunc=@(L) lmnnLossGradient(L(:),xTr,yTr,pars);
 [L,loss,~,Det]=minFunc(lmfunc,L(:),options);
 Det.loss=loss;
 Det.time=toc;
 L=reshape(L,[pars.outdim,d]);
catch
  fprintf('\n****************************\n')
  disp('Sorry, lmnnCG.m threw an error.');
  disp(sprintf('If this is not easily fixable, please feel free to email me at <a href="mailto:kilian@gmail.com">kilian@gmail.com</a>.'));
  disp('Please don''t forget to paste the following error message into the email:');  
  rethrow(lasterror);

end;


