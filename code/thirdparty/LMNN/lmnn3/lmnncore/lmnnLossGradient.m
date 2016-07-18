function  [loss,df]=lmnnLossGradient(L,x,y,pars)
    global dfG;
    global NN;
    global imp;
    
    [d,n]=size(x);
    Kg=size(NN,1);
    L=reshape(L,[numel(L)/d d]);
    Lx=L*x;
    
    if pars.GPU,
        global Gx
        global Gy
        Lx=L*Gx;
        Ni=gpuArray(zeros(Kg,n));
    else
       Lx=L*x;
       Ni=zeros(Kg,n);
    end;
    if pars.Ki==0,     
        imp=lmnnFindImps(Lx,y);
    end;

    % compute distances to target neighbors
    for nnid=1:Kg
        Ni(nnid,:)=sum((Lx-Lx(:,NN(nnid,:))).^2,1)+1;
    end;

    % in case GPU was present, move Lx back to main memory
    if pars.GPU,
      Lx=gather(Lx);
      Ni=gather(Ni);
    end;
    Lx=double(Lx);
    
    % compute distances to impostors
    distImp=cdist(Lx,imp(1,:),imp(2,:));
    

    loss=0.0;
    A0=sparse([],[],[],n,n,length(imp));    
    for nnid=Kg:-1:1 
        loss1=max(Ni(nnid,imp(1,:))-distImp,0);
        nz=find(loss1~=0);
        A1=sparse(imp(1,nz),imp(2,nz),2.*loss1(nz),n,n);
        loss2=max(Ni(nnid,imp(2,:))-distImp,0);
        nz=find(loss2~=0);
        A2=sparse(imp(1,nz),imp(2,nz),2.*loss2(nz),n,n); %activec constraints        
        A0=A0-A1-A2+sparse(1:n,NN(nnid,:),sum(A2,1)+sum(A1,2)',n,n);
        loss=loss+sum(loss1.^2)+sum(loss2.^2);
    end;        
    Q=(A0)+(A0)';
    ii=find(sum(Q~=0));
    Q=Q(ii,ii);
    df=L*dfG-(Lx(:,ii)*(Q-spdiags(sum(Q)',0,length(Q),length(Q))))*x(:,ii)';    
    df=2*df;
    loss=loss+vec(dfG)'*vec(L'*L);

    df=vec(df);
