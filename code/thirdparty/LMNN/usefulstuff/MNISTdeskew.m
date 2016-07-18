function [images,labels] = NIST_LoadImages(imageFile,labelFile,id)
% function [images,labels] = NIST_LoadImages(imageFile,labelFile,id)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LABELS
tic;
fid = fopen(labelFile,'r');
labelHeaderSize = 8;
header = fread(fid,labelHeaderSize,'uchar');
labels = fread(fid,inf,'uchar');
fclose(fid);

% SUBSET?
if (nargin==3)
  idx = find(labels==id);
  labels = labels(idx);
  fprintf(1,'Loading %d handwritten %ds\n',length(labels),id);
else
  idx = [1:length(labels)]';
  fprintf(1,'Loading %d handwritten digits\n',length(labels));
end;

% IMAGES
crop = 0;
side = 28;
nPixel = side^2;
nPixelCropped = (side-2*crop)^2;
nImage = length(labels);
images = zeros(nPixelCropped,nImage);

% SLURP
colormap hot;
fid = fopen(imageFile,'r','b');
imageHeaderSize = 16;
header = fread(fid,imageHeaderSize,'uchar');
diffIdx = [idx(1)-1; diff(idx)-1];
for ii=1:length(labels)
  slurp = fread(fid,nPixel*diffIdx(ii),'uchar');
  raw = fread(fid,nPixel,'uchar');
  raw = reshape(raw,side,side)'/255;
    deslant = Deslant(raw);
  cropped = deslant(1+crop:side-crop,1+crop:side-crop);
  % imagesc(cropped); drawnow;
  if mod(ii,100)==0,
  disp(sprintf('Loading %d of %d...',ii,length(labels)));
  end;
  images(:,ii) = cropped(:);
end;
fclose(fid);
labels = labels';
toc;
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESLANT

function out = Deslant(in)

% GRID
[nrow ncol] = size(in);
[x,y] = meshgrid(1:ncol,nrow:-1:1);
x = x(:); y = y(:); m = in(:)/sum(in(:));

% TRANSLATE TO ORIGIN
ux = m'*x;
uy = m'*y;
x = x-ux;
y = y-uy;

% MOMENTS OF INERTIA
ixx = m'*(x.*x);
iyy = m'*(y.*y);
ixy = m'*(x.*y);

% DESLANT
dx = ux+(x+ixy*y/iyy);
dy = uy+y;
y = uy+y;
x = ux+x;

% ROUND
dx = round(dx);
dy = round(dy);

% REIMAGE
out = zeros(size(in));
ii = find(dx>=1 & dx<=ncol);
jj = sub2ind(size(out),dy(ii),dx(ii));
kk = sub2ind(size(in),y(ii),x(ii));
out(jj) = in(kk);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%