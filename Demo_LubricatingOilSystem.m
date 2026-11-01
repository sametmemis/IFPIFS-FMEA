%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo_LubricatingOilSystem
% Reproduces the results of the paper for the main engine lubricating oil
% system (18 failure modes, 5 experts):
%   1) IFPIFS-FMEA risk scores and ranks (experience-based weights B^2)
%   2) IFPIFS-FMEA with equal weights B^1 (reference case)
%   3) Comparison with RPN-, VIKOR-, TOPSIS-, COPRAS-FMEA, WE-RANK and
%      FPFS-FMEA (Spearman rank correlations and Kendall's W)
%   4) One-way sensitivity analysis on the intuitionistic fuzzy weight of
%      each expert
% All results are written to Results_LubricatingOilSystem.xlsx.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
outFile='Results_LubricatingOilSystem.xlsx';

%% Data
L=load('LO_data.mat');
OSD=double(L.OSD);                 % 18 x 15 crisp O-S-D ratings
B=double(L.B(:)');                 % experience vector [9 10 12 8 14]
[m,n3]=size(OSD); n=n3/3;
codes=arrayfun(@(i) sprintf('LO-%02d',i),(1:m)','UniformOutput',false);

%% 1) IFPIFS-FMEA with experience-based weights
[svB2,dvB2,opB2,F]=IFPIFSFMEA(OSD,B);
rkB2=score2rank(dvB2);
T1=table(codes,svB2,dvB2,rkB2,'VariableNames', ...
    {'FailureCode','RiskScore','NormalizedRiskScore','Rank'});
disp('IFPIFS-FMEA (A, B^2)'); disp(T1);
fprintf('Riskiest failure mode: %s\n\n',codes{opB2(1)});

%% 2) IFPIFS-FMEA with equal weights
[svB1,dvB1]=IFPIFSFMEA(OSD,ones(1,n));
rkB1=score2rank(dvB1);

%% 3) Comparison with other FMEA approaches
iO=1:3:n3; iS=2:3:n3; iD=3:3:n3;
% RPN-FMEA: geometric mean of the expert ratings
gO=exp(mean(log(OSD(:,iO)),2));
gS=exp(mean(log(OSD(:,iS)),2));
gD=exp(mean(log(OSD(:,iD)),2));
RPN=gO.*gS.*gD;
% VIKOR-, TOPSIS- and COPRAS-FMEA: arithmetic means, equal weights
mOSD=[mean(OSD(:,iO),2) mean(OSD(:,iS),2) mean(OSD(:,iD),2)];
w=[1 1 1]; cb=[1 1 1];
[~,dmV]=VIKOR(mOSD,cb,0.5,w);
[~,dmT]=TOPSIS(mOSD,cb,w);
[~,dmC]=COPRAS(mOSD,cb,w);
% WE-RANK: entropy weights and Borda count
[~,dmW]=WERANK(OSD);
% FPFS-FMEA: fpfs-matrix and CCE10 (experience weights)
D=repelem(B,3);
[~,dmF]=CCE10([D/max(D); OSD./max(OSD,[],1)]);

methods={'RPN_FMEA','VIKOR_FMEA','TOPSIS_FMEA','COPRAS_FMEA','WE_RANK','FPFS_FMEA','IFPIFS_FMEA'};
S=[RPN dmV dmT dmC dmW dmF dvB2];
R=zeros(size(S));
for q=1:size(S,2)
    R(:,q)=score2rank(S(:,q));
end
T2=array2table(R,'VariableNames',methods); T2=[table(codes,'VariableNames',{'FailureCode'}) T2];
disp('Ranking orders of the compared methods'); disp(T2);

% Spearman rank correlations (Pearson correlation of the rank vectors)
q=numel(methods); rho=zeros(q);
for p1=1:q
    for p2=1:q
        x=R(:,p1)-mean(R(:,p1)); y=R(:,p2)-mean(R(:,p2));
        rho(p1,p2)=sum(x.*y)/sqrt(sum(x.^2)*sum(y.^2));
    end
end
T3=array2table(rho,'VariableNames',methods,'RowNames',methods);
disp('Spearman rank correlations'); disp(T3);
% Kendall's coefficient of concordance over the seven rankings
Ssq=sum((sum(R,2)-mean(sum(R,2))).^2);
KendallW=12*Ssq/(q^2*(m^3-m));
fprintf('Kendall''s W (%d rankings) = %.3f\n\n',q,KendallW);

%% 4) One-way sensitivity analysis on expert weights
pairs=[0 1; 0.2 0.8; 0.4 0.6; 0.6 0.4; 0.8 0.2; 1 0];   % (mu, nu)
labels=arrayfun(@(s) sprintf('mu%03d_nu%03d',round(100*pairs(s,1)),round(100*pairs(s,2))), ...
    1:size(pairs,1),'UniformOutput',false);
Sens=cell(1,n);
for h=1:n
    cols=3*h-2:3*h;
    Rh=zeros(m,size(pairs,1));
    for s=1:size(pairs,1)
        G=F;
        G(1,cols,1)=pairs(s,1);
        G(1,cols,2)=pairs(s,2);
        [~,~,~,dv]=iPEM(G);
        Rh(:,s)=score2rank(dv);
    end
    Sens{h}=Rh;
end

%% Write results
if exist(outFile,'file'), delete(outFile); end
writetable(T1,outFile,'Sheet','IFPIFS_FMEA_B2');
writetable(table(codes,svB1,dvB1,rkB1,'VariableNames', ...
    {'FailureCode','RiskScore','NormalizedRiskScore','Rank'}),outFile,'Sheet','IFPIFS_FMEA_B1');
writetable([table(codes,'VariableNames',{'FailureCode'}) array2table(S,'VariableNames',methods)],outFile,'Sheet','Scores');
writetable(T2,outFile,'Sheet','Ranks');
writetable(T3,outFile,'Sheet','Spearman','WriteRowNames',true);
writetable(table(KendallW),outFile,'Sheet','KendallW');
for h=1:n
    writetable([table(codes,'VariableNames',{'FailureCode'}) array2table(Sens{h},'VariableNames',labels)], ...
        outFile,'Sheet',sprintf('Sensitivity_E%d',h));
end
fprintf('Results written to %s\n',outFile);
