% This is a modified version of the Wave Kernel Signature described
% in the paper:
% 
%    The Wave Kernel Signature: A Quantum Mechanical Approach To Shape Analysis 
%    M. Aubry, U. Schlickewei, D. Cremers
%    In IEEE International Conference on Computer Vision (ICCV) - Workshop on 
%    Dynamic Shape Capture and Analysis (4DMOD), 2011
% 
% Please refer to the publication above if you use this software. 
% In this version the WKS is computed based on already computed eigenvalues
% and eigenvectors of the Laplace-Beltrami operator.
%
% This work is licensed under a Creative Commons
% Attribution-NonCommercial 3.0 Unported License  
% ( http://creativecommons.org/licenses/by-nc/3.0/ )
% 
% The WKS is patented and violation to the license agreement would
% imply a patent infringement.
%
% THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESSED OR IMPLIED WARRANTIES
% OF ANY KIND, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THIS SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THIS SOFTWARE.


function [ WKS ] = compute_wks_shape( E, PHI, N )
%COMPUTE_SHAPE_WKS Summary of this function goes here
% compute WKS 
% Given the shape's computed eigenvalues - E
% and eigenvectors - PHI 
% the number of vertices - num_vertices
% the number of evaluations of WKS - N
% the Wave Kernel Signature for the vertices of this shape is computed

wks_variance = 6; % variance of the WKS gaussian (wih respect to the 
% difference of the two first eigenvalues). For easy or precision tasks 
% (eg. matching with only isometric deformations) you can take it smaller
% num_vertices = shape.numberOfVertices; % computed in loadshapes
num_vertices = size(PHI, 1);
% E = shape.evals; % computed in loadshapes
% PHI = shape.evecs; % computed in loadshapes



%% compute WKS 


fprintf('Computing WKS...');

WKS=zeros(num_vertices,N); 

log_E=log(max(abs(E),1e-6))';
e=linspace(log_E(2),(max(log_E))/1.02,N);  
sigma=(e(2)-e(1))*wks_variance;

C = zeros(1,N); %weights used for the normalization of f_E

for i = 1:N
    WKS(:,i) = sum(PHI.^2.*...
        repmat( exp((-(e(i) - log_E).^2) ./ (2*sigma.^2)),num_vertices,1),2);
    C(i) = sum(exp((-(e(i)-log_E).^2)/(2*sigma.^2)));
end

% normalize WKS
WKS(:,:) = WKS(:,:)./repmat(C,num_vertices,1);

fprintf('done. \n');

end


