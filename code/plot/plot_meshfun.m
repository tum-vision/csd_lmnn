function [  ] = plot_meshfun( V, F, fun, varargin )
%PLOT_MESHFUN Summary of this function goes here
%   Detailed explanation goes here

colormap(jet)
trisurf(F, V(:,1), V(:,2), V(:,3), fun,'FaceColor','flat','EdgeColor','none')
axis equal
light; 
lighting phong; 
camlight head; 
axis off
view([0 90])
if nargin > 3, title(sprintf('%s', varargin{1})); end

end

