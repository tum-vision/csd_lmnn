function [ pooledDesc ] = get_pooled_desc( descType, normPoint, normPooled, cellOpt )


global DIRS;
tic;
SHAPES = get_files(DIRS.EVECS);
DESCS = get_files(fullfile(DIRS.DESC, descType));
N = length(DESCS);

if nargin < 2
    normPoint = 'L2';
    normPooled = 'L2';
end
if nargin < 4
    cellOpt = 0;
end


X_desc = cell(N,1);
parfor i=1:N
    fprintf('Pooling descriptor %d/%d\n', i, N);
    
    % Load shape's area elements
    Area = load(SHAPES{i}, 'S');
    [m,n] = size(Area.S);
    if m~=1 && n~=1
        Area = full(diag(Area.S));
    else
        Area = Area.S;
    end    
    % Make area elements sum up to 1
    pArea = Area / sum(Area);
    
    % Load shape's point descriptors
    Desc = load(DESCS{i}, 'desc');
    Desc = Desc.desc; % n x k 
    
    % Normalize point descriptors
    Desc = normalize(Desc, normPoint, 2); % definitely for WKS
    
    % Pooling weighted by the area elements
    descPooled = pArea'*Desc; % 1xn x nxk = 1xk    
        
    % Normalize the pooled descriptor
    descPooled = normalize(descPooled, normPooled, 2);
    
    X_desc{i} = descPooled;  
end

if ~cellOpt
    pooledDesc = cell2mat(X_desc);
end
toc;



