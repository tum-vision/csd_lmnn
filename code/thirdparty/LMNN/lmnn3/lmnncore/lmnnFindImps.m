function imp=lmnnFindImps(Lx,y)

global NN
global pars

Ni=sum((Lx-Lx(:,NN(end,:))).^2,1)+2;
un=unique(y);
imp=[];

for c=un(1:end-1)
 i=find(y==c);
 index=find(y>c);
 %% experimental
 ir=randperm(length(i));ir=ir(1:ceil(length(ir)*pars.subsample));
 ir2=randperm(length(index));ir2=ir2(1:ceil(length(ir2)*pars.subsample));
 index=index(ir2);
 i=i(ir);
 %% experimental
 limps=LSImps2(Lx(:,index),Lx(:,i),Ni(index),Ni(i),pars);
 if(size(limps,2)>pars.maximp)
  ip=randperm(size(limps,2));
  ip=ip(1:pars.maximp);
  limps=limps(:,ip);
 end;
 imp=[imp [i(limps(2,:));index(limps(1,:))]];
end;
%imp=unique(sort(imp)','rows')';

 


function limps=LSImps2(X1,X2,Thresh1,Thresh2,pars);
B=5000;
N2=size(X2,2);
limps=[];
for i=1:B:N2
  BB=min(B,N2-i);
  newlimps=findimps3Dm(X1,X2(:,i:i+BB), Thresh1,Thresh2(i:i+BB));
  if(~isempty(newlimps) & newlimps(end)==0)    
    [~,endpoint]=min(min(newlimps));
    newlimps=newlimps(:,1:endpoint-1);
  end;
  newlimps=unique(newlimps','rows')';
  newlimps(2,:)=newlimps(2,:)+i-1;
  limps=[limps newlimps];
end;


