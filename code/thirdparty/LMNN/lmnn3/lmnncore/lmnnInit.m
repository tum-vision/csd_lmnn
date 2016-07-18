function lmnnInit(x,y,Kg,varargin)

pars.quiet=0;
pars.Ki=50;
pars=extractpars(varargin,pars);

global dfG % gradient component of target neighbors
global NN
global imp
global Gx
global Gy

Ki=pars.Ki;

    
if(~pars.quiet);fprintf('Computing nearest neighbors ...\n');end; 
[~,N]=size(x);

un=unique(y);
NN=zeros(Kg,N);
imp=zeros(2,N*Ki);
i0=1;
for c=un
 i=find(y==c);
 nn=LSKnn(x(:,i),x(:,i),2:Kg+1,pars.GPU); 
 if pars.GPU,
     NN(:,i)=gather(i(nn));
 else
     NN(:,i)=i(nn);
 end;
    

 j=find(y~=c);
 %nn=LSKnn(x(:,j),x(:,i),2:Ki); 
 %Inn(:,i)=j(nn); 
 if pars.Ki>0,
  [i1,i2]=TopKImps(Gx(:,j),Gx(:,i),Ki*length(i)); 
  imp(:,i0:i0+length(i1)-1)=[j(i1);i(i2)];
  i0=i0+length(i1);
 end;
end;
gen1=vec(NN(1:Kg,:)')';
gen2=vec(repmat(1:N,Kg,1)')';
dfG=SODWsp(x,sparse(gen1,gen2,1,N,N));
clear('gen1','gen2')



function NN=LSKnn(X1,X2,ks,gpu)
B=750;
[~,N]=size(X2);
NN=zeros(length(ks),N);
DD=zeros(length(ks),N);
for i=1:B:N
  BB=min(B,N-i);
  Dist=distance(X1,X2(:,i:i+BB));
  %[~,nn]=mink(Dist,max(ks));
  [~,nn]=sort(Dist);
  if gpu,
      nn=gather(nn);
  end;
  NN(:,i:i+BB)=nn(ks,:);
end;

function [i1,i2]=TopKImps(X1,X2,M)
  [~,N1]=size(X1);
  [~,N2]=size(X2);
  M=min(M,N1*N2);
  Dist=distance(X1,X2);
  [~,ii]=sort(Dist(:));
  [i1,i2]=ind2sub(size(Dist),ii(1:M));


