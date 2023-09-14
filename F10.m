clear;

% Define the TLP.
Mr=ML2Mw(1.7);
My=Mr-2;

% Define some dM values.
bm=1.05;
db=0.12;
N=1e6;

% Get the catalogue data.
load('/Users/rschultz/Desktop/old/Trailing/IS-bath/data/processed/PNR2.mat');
te=datetime(S.cat.time,'ConvertFrom','datenum');
Mw=S.cat.mag;
ML=Mw2ML(Mw);
ti=datetime(S.inj.time+1/24,'ConvertFrom','datenum');
Vr=S.inj.rate;

% Get the start/stop times for each stage.
T=struct('Ts',[],'Te',[], 'Rs',[]);
T(1).Ts=datetime(2019,08,15, 08,13,40); T(1).Te=datetime(2019,08,16, 08,01,46); % S1.
T(2).Ts=datetime(2019,08,16, 08,01,46); T(2).Te=datetime(2019,08,17, 08,00,06); % S2.
T(3).Ts=datetime(2019,08,17, 08,00,06); T(3).Te=datetime(2019,08,19, 08,12,18); % S3.
T(4).Ts=datetime(2019,08,19, 08,12,18); T(4).Te=datetime(2019,08,20, 07,57,25); % S4.
T(5).Ts=datetime(2019,08,20, 07,57,25); T(5).Te=datetime(2019,08,21, 08,44,28); % S5.
T(6).Ts=datetime(2019,08,21, 08,44,28); T(6).Te=datetime(2019,08,23, 10,21,42); % S6.
T(7).Ts=datetime(2019,08,23, 10,21,42); T(7).Te=datetime(2019,10,03, 01,01,01); % S7.

% Get the dM distributions.
b=normrnd(bm,db,[1 N]);
dM0a=dM_distribution(b,  -1,'red+trail',[1 N]);
dM0b=dM_distribution(b,0.86,'red+trail',[1 N]);
dM1 =dM_distribution(b,0.78,'red+trail',[1 N]);
dM2 =dM_distribution(b,0.64,'red+trail',[1 N]);
dM3 =dM_distribution(b,0.66,'red+trail',[1 N]);
dM4 =dM_distribution(b,0.58,'red+trail',[1 N]);
dM5 =dM_distribution(b,0.37,'red+trail',[1 N]);
dM6 =dM_distribution(b,0.25,'red+trail',[1 N]);
dM7 =dM_distribution(b,0.05,'red+trail',[1 N]);

dMr=median(dM0b)-[median(dM1) median(dM2) median(dM3) median(dM4) median(dM5) median(dM6) median(dM7)]+Mr;
%dMr=mean(dM0b)-[mean(dM1) mean(dM2) mean(dM3) mean(dM4) mean(dM5) mean(dM6) mean(dM7)]+Mr;

% Get the magnitude size axis.
Rs=getMscale(Mw);

% Plot the M-t timeseries.
figure(10); clf;
%plot(S.cat.time,S.cat.mag,'o'); hold on;
scatter(te,Mw, Rs*1.5,'filled'); hold on;
plot(xlim(),Mr*[1 1],'-r');
plot(xlim(),My*[1 1],'-y','LineWidth',2);
plot([T.Te],dMr,'-o');
plot(ti,Vr-2.5,'-b');
xlim([datetime(2019, 08, 15) datetime(2019, 08, 31)]); ylim([-2.5 3.0]);
xlabel('Time'); ylabel('Magntiude (M_W)');






%%%% SUBROUNTINES.

% Get the size of rupture from event magnitude.
function [Rs]=getMscale(ML)
  %Mw=0.754*ML+0.884;% ML to Mw [Yenier, 2017; Ross et al., 2016].
  Mw=ML;
  Mo=10.^(1.5*Mw+9.1); % Mw to Mo (Nm).
  Rs=nthroot((7/16)*(Mo/3e6),3); % Mo to radius (m), assuming a stress dop of 3 MPa.
end


% Get the moment magnitudes.
function [Mw]=ML2Mw(ML)
  % Computes the ML given an Mw, based on Edwards et al. (2015).
  Mw=(2/3)*ML+0.833;
  
end
