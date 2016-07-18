function [ pdesc ] = compute_pdesc( descType, evecs, evals, params, area )
%COMPUTE_PDESC Summary of this function goes here
%   Computes point descriptors for a shape
%
%   Inputs:     descType (string), the descriptor to be computed, can be 
%               'hks' (Heat Kernel Signature),
%               'sihks' (Scale Invariant Heat Kernel Signature),
%               'wks' (Wave Kernel Signature), 
%               'gps' (Global Point Signature), 
%
%               evecs (n x k matrix), the LB eigenvectors of the shape
%
%               evals (k x 1 vector), the LB eigenvalues of the shape
%
%               params (struct), parameters for the descriptor computation
%
%               area (n x 1 vector), the area each point/vertex covers, 
%               if given, the point descriptors get weighted by it
%
%   Outputs:    pdesc (n x m matrix), the point/vertex descriptors 
%


switch descType
    
    case 'HKS'
        pdesc = hks(evecs, evals, params.alpha.^params.T);
    
    case 'SIHKS'
        pdesc = sihks( evecs, evals, params.alpha, params.T, params.Omega ); 
        
    case 'WKS'
        descdim = params;
        pdesc = compute_wks_shape( evals, evecs, descdim );
        
    case 'GPS'
        descdim = params;
        evecs_autosignflip = false;
        pdesc = gps(evecs(:,2:end), evals(2:end), descdim, evecs_autosignflip);
        
    otherwise 
        error('Unknown point descriptor type!');
end

if nargin == 5
    % Weight the descriptor by the area elements
    descdim = size(pdesc,2);
    pdesc = pdesc.*repmat(area, 1, descdim);
end



end

