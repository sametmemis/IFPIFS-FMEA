%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WE-RANK: Entropy-based Borda extended weighted expert FMEA
% Citation:
% Akdamar, E., Elidolu, G., Gogebakan, M., Ceylan, B. O. (2026).
% Entropy-based Borda extended weighted expert FMEA approach: Comparison
% with classical and fuzzy FMEA on a ship system. Applied Soft Computing,
% 188, 114424. https://doi.org/10.1016/j.asoc.2025.114424
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo:
% load('OSD.mat');                 % m x 3k (O,S,D blocks of k experts)
% [s,dm,op,W,R]=WERANK(OSD);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs : OSD  m x 3k matrix, columns [O1 S1 D1 O2 S2 D2 ... Ok Sk Dk]
% Outputs: s    m x 1 Borda scores  B_i = sum_h (m - r_ih)
%          dm   m x 1 min-max normalised Borda scores (1 = most risky)
%          op   index/indices of the most risky failure mode(s)
%          W    k x 3 entropy weights (wO, wS, wD) of each expert
%          R    m x k expert-based rankings (1 = most risky, ties averaged)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [s,dm,op,W,R]=WERANK(OSD)
%% Step 1: checks
OSD=double(OSD);
[m,n]=size(OSD);
if mod(n,3)~=0
    error('OSD must have 3k columns (O,S,D for each expert).');
end
k=n/3;
W=zeros(k,3);
R=zeros(m,k);
%% Steps 2-4: entropy weights, weighted RPN and ranking for each expert
for h=1:k
    X=OSD(:,3*h-2:3*h);
    P=X./sum(X,1);                         % normalised decision matrix
    PL=P.*log(P);
    PL(P==0)=0;                            % 0*log(0) := 0
    e=-sum(PL,1)/log(m);                   % entropy values
    d=1-e;                                 % degree of divergence
    if sum(d)~=0
        W(h,:)=d/sum(d);                   % entropy weights (wO,wS,wD)
    else
        W(h,:)=ones(1,3)/3;
    end
    wRPN=prod(X.*W(h,:),2);                % entropy-weighted RPN
    R(:,h)=score2rank(round(wRPN,12));     % expert-based ranking
end
%% Step 5: Borda count aggregation
s=sum(m-R,2);
if max(s)~=min(s)
    dm=(s-min(s))/(max(s)-min(s));
else
    dm=ones(m,1);
end
op=find(dm==max(dm))';
end
