% Y = normalize(X,p,dim)
% Lp normalization of a matrix X along dimension dim
%
% (C) Copyright Alex Bronstein, Michael Bronstein, Maks Ovsjanikov,
% Stanford University, 2009. All Rights Reserved.
function [Y,n] = normalize(X,p,dim)

if nargin < 3, dim = 1; end

if ischar(p),
    switch(upper(p)),
        case 'L1', [Y,n] = normalize(X,1,dim);
        case 'L2', [Y,n] = normalize(X,2,dim);
        case {'NONE', ''}, Y = X;
    end
    return;
end

n = (sum(abs(X).^p,dim)).^(1/p);
n(n<=0) = 1;
Y = bsxfun(@rdivide,X,n);


