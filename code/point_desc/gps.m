function [ desc ] = gps( evecs, evals, dim, autoSignFlip )
%GPS - Compute the Global Point Signature for a shape
% Input:  evecs   - (n x k) Laplace-Beltrami eigenvectors arranged as columns 
%         evals   - (k x 1) corresponding Laplace-Beltrami eigenvalues 
%
% Output:   desc  - (n x k) Global Point Signature descriptors 


[n, k] = size(evecs);
k = min(k, dim);
evecs = evecs(:, 1:k);
evals = evals(1:k);

% Make majority of evecs signs positive
if nargin == 4 && autoSignFlip
    for j=1:k
        count = nnz(evecs(:,j) > 0);
        if count/n < 0.5
            evecs(:,j) = -evecs(:,j);
        end
    end
end


sqrtevals = sqrt(evals)';
desc = zeros(n, k);

for i=1:n
    desc(i,:) = evecs(i,:) ./ sqrtevals;
end


end

