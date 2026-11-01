%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% score2rank: converts a score vector into ranking orders
% r(i) is the rank of alternative i (1 = highest score); ties receive the
% average of the positions they occupy.
% NOTE: [~,idx]=sort(x,'descend') returns the INDEX of the alternative in
% each position (idx(1) = best alternative), not the rank of each
% alternative. The rank vector is the inverse permutation of idx.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r=score2rank(x)
x=x(:);
m=numel(x);
[xs,idx]=sort(x,'descend');
r=zeros(m,1);
i=1;
while i<=m
    j=i;
    while j<m && xs(j+1)==xs(i)
        j=j+1;
    end
    r(idx(i:j))=(i+j)/2;
    i=j+1;
end
end
