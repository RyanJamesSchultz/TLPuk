clear;

% Predefine a structure.
R=struct('ML',[],'Mw',[],'lat',[],'lon',[],'dep',[],'dGM',[],'year',[],'name',[],'Ss',[]);

% Populate the structure with relevant information on each earthquake scenario.
i=1;
R(i).ML=2.9; R(i).lat=53.787; R(i).lon=-2.964; R(i).dep=2.5; R(i).dGM=-0.5; R(i).year=2019; R(i).name='PNR2  M 2.9 2019-08-26'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=2.1; R(i).lat=53.786; R(i).lon=-2.969; R(i).dep=2.1; R(i).dGM=-0.6; R(i).year=2019; R(i).name='PNR2  M 2.1 2019-08-24'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
R(i).ML=1.6; R(i).lat=53.785; R(i).lon=-2.971; R(i).dep=2.1; R(i).dGM=-0.7; R(i).year=2019; R(i).name='PNR2  M 1.6 2019-08-21'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=1.6; R(i).lat=53.787; R(i).lon=-2.965; R(i).dep=2.3; R(i).dGM=-0.5; R(i).year=2018; R(i).name='PNR1z M 1.6 2018-12-11'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=2.3; R(i).lat=53.xxx; R(i).lon=-2.xxx; R(i).dep=2.x; R(i).dGM=-0.x; R(i).year=2011; R(i).name='PH-1  M 2.3 2011-04-01'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;
%R(i).ML=3.2; R(i).lat=51.159; R(i).lon=-0.240; R(i).dep=2.1; R(i).dGM=-0.0; R(i).year=2019; R(i).name='Hhill M 3.2 2019-02-27'; R(i).Mw=ML2Mw(R(i).ML); i=i+1;

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
n3=[R(1).Ss.RISK.Nn3(R(1).Ss.RISK.Nn3<=Nn3_f); R(2).Ss.RISK.Nn3(R(2).Ss.RISK.Nn3>=Nn3_f)];
n3t=prctile(n3,p);


%%

% Plot.
figure(9); clf;
% Nuisance tolerance.
boxplot(n3*S.Nph); hold on;
plot(1:10,10.^[linspace(0,6,10)]);
plot(1:10,4*10.^[linspace(0,6,10)]);
set(gca, 'YScale', 'log');
ylim(10.^[0 6]); xlim([0 6]);
plot(xlim,n3t*[1 1]*S.Nph,':k');
ylabel('Number of Households Impacted by Nuisance');
xlabel('Location');
camroll(-90);





%%%% SUBROUNTINES.

% Get the moment magnitudes.
function [Mw]=ML2Mw(ML)
  % Computes the Mw given an ML, based on Edwards et al. (2015).
  Mw=(2/3)*ML+0.833;
  
end