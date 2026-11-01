%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IFPIFS-FMEA: Hesitation-aware failure mode and effects analysis via
% intuitionistic fuzzy parameterized intuitionistic fuzzy soft matrices
% (Algorithm 1 of the paper)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% S. Memiş, B. O. Ceylan. Hesitation-Aware Failure Mode and Effects
% Analysis via Intuitionistic Fuzzy Parameterized Intuitionistic Fuzzy
% Soft Matrices: Risk Prioritization of a Marine Main Engine Lubricating
% Oil System. Submitted to Ships and Offshore Structures.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo:
% L=load('LO_data.mat');
% [sv,dv,op]=IFPIFSFMEA(L.OSD,L.B);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs : OSD      m x 3n matrix of crisp ratings in {1,...,10}; columns
%                   are [O1 S1 D1 O2 S2 D2 ... On Sn Dn] for n experts
%          B        1 x n experience vector of the experts (e.g. years)
%          scaleMu  (optional) 1 x 10 membership degrees of IF1-IF10
%          scaleNu  (optional) 1 x 10 non-membership degrees of IF1-IF10
%                   Default: the ten-level extension of the
%                   intuitionistic fuzzy linguistic scale of
%                   Tooranloo and Ayatollah (2016) used in the paper
% Outputs: sv       m x 1 risk scores
%          dv       m x 1 normalized risk scores (1 = riskiest)
%          op       index (indices) of the riskiest failure mode(s)
%          F        (m+1) x 3n x 2 ifpifs-matrix; F(:,:,1) holds the
%                   membership and F(:,:,2) the non-membership degrees,
%                   and the first row holds the parameter weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sv,dv,op,F]=IFPIFSFMEA(OSD,B,scaleMu,scaleNu)
if nargin<4 || isempty(scaleMu) || isempty(scaleNu)
    scaleMu=[0.10 0.10 0.25 0.40 0.50 0.60 0.70 0.80 0.90 1.00];
    scaleNu=[0.90 0.75 0.60 0.50 0.40 0.30 0.20 0.10 0.10 0.00];
end
%% Line 1: O-S-D matrix
OSD=double(OSD);
B=double(B(:)');
[m,n3]=size(OSD);
n=n3/3;
if mod(n3,3)~=0
    error('OSD must have 3n columns (O, S and D for each expert).');
end
if numel(B)~=n
    error('B must contain one experience value for each of the %d experts.',n);
end
if any(OSD(:)<1) || any(OSD(:)>10) || any(OSD(:)~=round(OSD(:)))
    error('All ratings in OSD must be integers between 1 and 10.');
end
%% Line 2: intuitionistic fuzzy scale matrix (Definition 4)
C=zeros(m,n3,2);
C(:,:,1)=reshape(scaleMu(OSD(:)),m,n3);
C(:,:,2)=reshape(scaleNu(OSD(:)),m,n3);
%% Lines 3-5: parameter weights from expert experience (Definitions 5-6)
D=repelem(B,3);                 % one weight per O, S and D parameter
W=D/max(D);                     % membership degrees of the weights
%% Line 6: ifpifs-matrix (Definition 8)
F=zeros(m+1,n3,2);
F(1,:,1)=W;
F(1,:,2)=1-W;
F(2:end,:,:)=C;
%% Lines 7-16: soft decision-making via iPEM
[~,sv,~,dv]=iPEM(F);
%% Lines 17-18: riskiest failure mode(s)
op=find(dv==max(dv))';
end
