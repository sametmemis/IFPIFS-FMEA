%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iPEM: soft decision-making method based on the prevalence effects of
% alternatives and parameters in the ifpifs-matrices space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% B. Arslan, T. Aydın, S. Memiş, S. Enginoğlu, 2021. Generalisations of SDM
% methods in fpfs-matrices space to render them operable in ifpifs-matrices
% space and their application to performance ranking of the noise-removal
% filters. Journal of New Theory, 36, 88-116.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs : a   (m+1) x n x 2 ifpifs-matrix; a(:,:,1) membership and
%              a(:,:,2) non-membership degrees; the first row holds the
%              parameter weights
% Outputs: s   m x 1 x 2 intuitionistic fuzzy score matrix
%          sv  m x 1 score values (membership minus non-membership)
%          av  m x 1 accuracy values (membership plus non-membership)
%          dv  m x 1 min-max normalized score values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [s,sv,av,dv]=iPEM(a)
%% Step 1
[m,n,~]=size(a);
%% Step 2: prevalence-weighted membership (b) and non-membership (c) sums
b=zeros(m-1,1);
c=zeros(m-1,1);
for i=2:m
    for j=1:n
        b(i-1,1)=b(i-1,1)+((1/(m-1))*sum(a(2:m,j,1)))*((1/n)*sum(a(i,:,1)))*a(1,j,1)*a(i,j,1);
        c(i-1,1)=c(i-1,1)+((1/(m-1))*sum(a(2:m,j,2)))*((1/n)*sum(a(i,:,2)))*a(1,j,2)*a(i,j,2);
    end
end
%% Step 3: intuitionistic fuzzy scores
s=zeros(m-1,1,2);
D=max(b+abs(c))+abs(min(b));
for i=2:m
    if D~=0
        s(i-1,1,1)=(b(i-1,1)+abs(min(b)))/D;
        s(i-1,1,2)=1-((b(i-1,1)+abs(c(i-1,1))+abs(min(b)))/D);
    else
        s(i-1,1,1)=1;
        s(i-1,1,2)=0;
    end
end
%% Step 4: score, accuracy and normalized score values
sv=s(:,1,1)-s(:,1,2);
av=s(:,1,1)+s(:,1,2);
if max(sv)~=min(sv)
    dv=(sv-min(sv))/(max(sv)-min(sv));
else
    dv=ones(m-1,1);
end
end
