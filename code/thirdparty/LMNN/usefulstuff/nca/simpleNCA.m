function [A,loss]=simpleNCA(xtr,ytr,varargin);
%  function [A,loss]=fastNCA(xtr,ytr,varargin);
%
% Input:
% xtr : dxn input feature matrix, each _column_ is a vector
% ytr : 1xn input vector of labels
%
% Optional Parameters:
% 'maxiter' : maximum number of gradient evaluations (default=50)
% 'outdim'  : enables rectangular A (default=d)
% 'GPU'     : enables GPU computation  (default=true if GPU present)
% 'initA'   : initialization (default=PCA)
%
% Experts only:
% 'maxN'    : subsamples inputs if n>maxN (default 5000) 
% 'single'  : switches to single precision (default=true)
%
%
% Output:
% A : transformation matrix x->Ax
%
% copyright Matt Kusner, Jake Gardner and  Kilian Weinberger 2015
%
% based on "Neighbourhood components analysis"
% by J Goldberger, S Roweis, G Hinton, R Salakhutdinov - NIPS 2004 
%

[d,n] = size(xtr);

try
    gpuDevice();
    xtr=gather(xtr);
    pars.GPU=true;
catch
    pars.GPU=false;
end;
pars.maxiter=50;
pars.outdim=d;
pars.single=true;
pars.initA=pca(xtr)';
pars.maxN=5000;
pars=extractpars(varargin,pars);

pars.initA = pars.initA(1:pars.outdim,:);

if n>5000
    disp('Too many input vectors, subsample 5000.')
    isub=makesplits(ytr,5000/n,1,1);
    xtr=xtr(:,isub);
    ytr=ytr(isub);
    [d,n]=size(xtr);
end;
% helper variables that don't need to be recomputed every gradient step
Q0=double(repmat(ytr',1,n)==repmat(ytr,n,1));
un = unique(ytr);
iis = {};
for i = 1:length(un)
    iis{i} = find(ytr == un(i));
end
all_ind = 1:n;
all_ind = repmat(1:n,n,1);
ii = all_ind(:);
jj = all_ind';
jj = jj(:);
indx = sub2ind([n,n],ii,jj);


disp('learning A');
if pars.single,
    xtr=single(xtr);
    pars.initA=single(pars.initA);
end;    
if pars.GPU
    xtr=gpuArray(xtr);
    ytr=gpuArray(ytr);
    pars.initA=gpuArray(pars.initA);
    [A,loss]=minimizeNCAgpu(pars.initA(:),'nca_grad_SODW_gpu',pars.maxiter,xtr,ytr,Q0,iis,pars.outdim);
    A=gather(reshape(A,[pars.outdim,ceil(length(A)/pars.outdim)]));    
else
    [A,loss]=minimizeNCA(pars.initA(:),'nca_grad_SODW',pars.maxiter,xtr,ytr,Q0,iis,pars.outdim);
    A=reshape(A,[pars.outdim,ceil(length(A)/pars.outdim)]);    
end;

