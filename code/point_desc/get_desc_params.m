function [ descParams ] = get_desc_params( descType )
%GET_DESC_PARAMS Summary of this function goes here
%   Default parameters for each descriptor



switch descType
    
    case 'HKS'
        HKS_PARAMS.T = (5:0.2:16);
        HKS_PARAMS.alpha = 2;
        descParams = HKS_PARAMS;
    case 'SIHKS'
        SIHKS_PARAMS.T = (1:0.2:20);
        SIHKS_PARAMS.alpha = 2;
        SIHKS_PARAMS.Omega = 1+(1:50); % neglect first frequency (uninformative)
        descParams = SIHKS_PARAMS;

    case 'GPS'     
        GPS_DIM = 50;
        descParams = GPS_DIM;
        
    case 'WKS'
        WKS_DIM = 100;
        descParams = WKS_DIM;

    otherwise
        error('Unknown descriptor parameters.');
end



end

