function [obj,gr]=nca_grad_SODW_gpu(A,X,y,Q0,iis,r)
% A - the metric (r,d)
% X - the data (d,n)
% y - the labels (1,n)
% Q0 - a label agreement matrix (n,n)
% iis - cell array of label indices for each unique label
% IX - row indices for SODW
% JX - column indices for SODW
% INDX - the matrix indices corresponding to IX and JX
% r - the first dimension of r


%% reshape input
[d,n]=size(X);
A=reshape(A,[r,d]);

XA = A*X;

%% compute matrices
K=exp(-distance(XA,XA));
K(1:n+1:end) = 0;

% for testing
Z=sum(K,2);
P=bsxfun(@times,K,1./Z);
logP = log(P);

% Compute p (probability of input i to be classified with label y(i))
p=gpuArray(zeros(n,1));
un=unique(y);
for i=1:length(un)
        ii=iis{i};
	% for each i find max
	pis = max(logP(ii,:),[],2); 
	
	% for each i compute log of sum of exponents
	log_plus = pis + log(sum(exp(bsxfun(@minus, logP(ii,ii), pis)),2));  
	p(ii)=exp(log_plus);
end;
obj=-sum(log(p));%-sum(log(p));

Q=bsxfun(@minus,Q0,p);
inv_p = 1.0./p;
T = -(Q.*P);
ww = bsxfun(@times,T,inv_p);
pixx = 2*SODWkqwAx(XA,X,ww');
gr=-pixx(:);
