clear;

% Predefine a structure.
R=struct('ML',[],'Mw',[],'lat',[],'lon',[],'dep',[],'dGM',[],'year',[],'name',[],'Ss',[]);

% Populate the structure with relevant information on each earthquake scenario.
i=1;
%R(i).ML=2.9; R(i).lat=53.787; R(i).lon=-2.964; R(i).dep=2.5; R(i).dGM=+0.4; R(i).year=2019; R(i).name='PNR2  M 2.9 2019-08-26'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=2.1; R(i).lat=53.786; R(i).lon=-2.969; R(i).dep=2.1; R(i).dGM=+0.2; R(i).year=2019; R(i).name='PNR2  M 2.1 2019-08-24'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=1.6; R(i).lat=53.785; R(i).lon=-2.971; R(i).dep=2.1; R(i).dGM=-0.1; R(i).year=2019; R(i).name='PNR2  M 1.6 2019-08-21'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=1.6; R(i).lat=53.787; R(i).lon=-2.965; R(i).dep=2.3; R(i).dGM=+0.1; R(i).year=2018; R(i).name='PNR1z M 1.6 2018-12-11'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
R(i).ML=2.3; R(i).lat=53.818; R(i).lon=-2.950; R(i).dep=2.3; R(i).dGM=+2.1; R(i).year=2011; R(i).name='PH-1  M 2.3 2011-04-01'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
R(i).ML=1.4; R(i).lat=53.818; R(i).lon=-2.950; R(i).dep=2.3; R(i).dGM=+1.9; R(i).year=2011; R(i).name='PH-1  M 1.4 2011-05-27'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
R(i).ML=1.2; R(i).lat=53.818; R(i).lon=-2.950; R(i).dep=2.3; R(i).dGM=+1.8; R(i).year=2011; R(i).name='PH-1  M 1.2 2011-05-26'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=3.0; R(i).lat=51.154; R(i).lon=-0.269; R(i).dep=2.3; R(i).dGM=+2.5; R(i).year=2018; R(i).name='Hhill M 3.0 2018-07-05'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=3.2; R(i).lat=51.159; R(i).lon=-0.240; R(i).dep=2.1; R(i).dGM=+1.9; R(i).year=2019; R(i).name='Hhill M 3.2 2019-02-27'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=2.7; R(i).lat=51.164; R(i).lon=-0.257; R(i).dep=3.1; R(i).dGM=+2.4; R(i).year=2018; R(i).name='Hhill M 2.7 2018-04-01'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=2.5; R(i).lat=51.168; R(i).lon=-0.239; R(i).dep=2.4; R(i).dGM=+2.1; R(i).year=2019; R(i).name='Hhill M 2.5 2018-06-18'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;

% Predefine some values.
Yls=2018;
Np=3000;
Nn2_f=10.^4.00;
Nn3_f=10.^3.75;
Nn4_f=10.^3.40;
p=50;

% Load in the data structure: S.
load('blanks/TLP_uk.mat');

% Perturb data structure and compute risk curves for a scenario.
for i=1:length(R)
    tic; Ss=runRISKscenario(S,R(i).lat,R(i).lon,R(i).dep,R(i).Mw,R(i).dGM,Np,R(i).year,Yls); toc;
    R(i).Ss=Ss;
end

% Make the nuisance tolerance distributions.
n2=[R(1).Ss.RISK.Nn2(R(1).Ss.RISK.Nn2<=Nn2_f); R(3).Ss.RISK.Nn2(R(3).Ss.RISK.Nn2>=Nn2_f)];
n3=[R(1).Ss.RISK.Nn3(R(1).Ss.RISK.Nn3<=Nn3_f); R(3).Ss.RISK.Nn3(R(3).Ss.RISK.Nn3>=Nn3_f)];
n4=[R(1).Ss.RISK.Nn4(R(1).Ss.RISK.Nn4<=Nn4_f); R(3).Ss.RISK.Nn4(R(3).Ss.RISK.Nn4>=Nn4_f)];

n2t=prctile(n2,p);
n3t=prctile(n3,p);
n4t=prctile(n4,p);

d1t=mean([prctile(R(1).Ss.RISK.Nd1,p) prctile(R(3).Ss.RISK.Nd1,p)]);
d2t=mean([prctile(R(1).Ss.RISK.Nd2,p) prctile(R(3).Ss.RISK.Nd2,p)]);

%%
px=10;

n2tx=prctile(n2,px);
n3tx=prctile(n3,px);
n4tx=prctile(n4,px);

d1tx=mean([prctile(R(1).Ss.RISK.Nd1,px) prctile(R(3).Ss.RISK.Nd1,px)]);
d2tx=mean([prctile(R(1).Ss.RISK.Nd2,px) prctile(R(3).Ss.RISK.Nd2,px)]);

% Plot the risk impacts for the EQ scenarios.
figure(57); clf;
% CDI 2.
subplot(141);
for i=1:length(R)
    histogram(log10(R(i).Ss.RISK.Nn2),round(2*sqrt(Np)),'DisplayName',R(i).name); hold on;
end
h=plot(log10(n2t)*[1 1],ylim,'--k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h=plot(log10(n2tx)*[1 1],ylim,':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('log_{10} Nuisance Impacts (CDI 2)'); ylabel('Counts');
xlim([1 6]);
legend();
% CDI 3.
subplot(142);
for i=1:length(R)
    histogram(log10(R(i).Ss.RISK.Nn3),round(2*sqrt(Np)),'DisplayName',R(i).name); hold on;
end
h=plot(log10(n3t)*[1 1],ylim,'--k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h=plot(log10(n3tx)*[1 1],ylim,':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('log_{10} Nuisance Impacts (CDI 3)'); ylabel('Counts');
xlim([1 6]);
legend();
% CDI 4.
subplot(143);
for i=1:length(R)
    histogram(log10(R(i).Ss.RISK.Nn4),round(2*sqrt(Np)),'DisplayName',R(i).name); hold on;
end
h=plot(log10(n4t)*[1 1],ylim,'--k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h=plot(log10(n4tx)*[1 1],ylim,':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('log_{10} Nuisance Impacts (CDI 4)'); ylabel('Counts');
xlim([1 6]);
legend();
% DS 1.
subplot(144);
for i=1:length(R)
    histogram(log10(R(i).Ss.RISK.Nd1),round(2*sqrt(Np)),'DisplayName',R(i).name); hold on;
end
h=plot(log10(d1t)*[1 1],ylim,'--k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h=plot(log10(d1tx)*[1 1],ylim,':k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
xlabel('log_{10} Damage Impacts (DS 1)'); ylabel('Counts');
xlim([-3 3]);
legend();

% % DS 2.
% subplot(235);
% for i=1:length(R)
%     histogram(log10(R(i).Ss.RISK.Nd2),round(2*sqrt(Np)),'DisplayName',R(i).name); hold on;
% end
% h=plot(log10(d2t)*[1 1],ylim,'--k');
% h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h=plot(log10(d2tx)*[1 1],ylim,':k');
% h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xlabel('log_{10} Damage Impacts (DS 2)'); ylabel('Counts');
% legend();
% % LPR.
% subplot(236);
% for i=1:length(R)
%     histogram(log10(R(i).Ss.RISK.LPR),round(2*sqrt(Np)),'DisplayName',R(i).name); hold on;
% end
% xlabel('log_{10} LPR (Probability)'); ylabel('Counts');
% legend();





%%%% SUBROUNTINES.

% Get the moment magnitudes.
function [Mw]=ML2Mw(ML)
  % Computes the Mw given an ML, based on Edwards et al. (2015).
  Mw=(2/3)*ML+0.833;
  
end
