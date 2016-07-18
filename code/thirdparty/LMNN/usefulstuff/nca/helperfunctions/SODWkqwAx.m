function C=SODWkqwAx(AX,X,W)
% function C=SODWkqw(X,W)
%
% 
% Returns the sum of all weighted outer products
%
% C=A*\sum_{i,j} (X(:,i)-X(:,j))(X(:,i)-X(:,j))'*W(i,j)

[~,n]=size(X);
Q=W+W';
C=(bsxfun(@times,AX,sum(Q)))*X'-(AX)*(Q*X');



