clear;

% Define the TLP.
Mr=ML2Mw(1.7);
My=Mr-2;

% Define some dM values.
bm=1.05;
db=0.12;
N=1e6;

% Get the catalogue data.
load('/Users/rschultz/Desktop/old/Trailing/IS-bath/data/processed/PNR1z.mat');
te=datetime(S.cat.time,'ConvertFrom','datenum');
Mw=S.cat.mag;
ML=Mw2ML(Mw);
ti=datetime(S.inj.time,'ConvertFrom','datenum'); ti(ti>datetime(2018,10,28))=ti(ti>datetime(2018,10,28))+1/24;
Vr=S.inj.rate;

% Get the start/stop times for each stage.
T=struct('Ts',[],'Te',[], 'Rs',[]);
T( 1).Ts=datetime(2018,10,16, 10,26,24); T( 1).Te=datetime(2018,10,17, 08,26,32); % S1.
T( 2).Ts=datetime(2018,10,17, 08,26,32); T( 2).Te=datetime(2018,10,18, 09,56,44); % S2.
T( 3).Ts=datetime(2018,10,18, 09,56,44); T( 3).Te=datetime(2018,10,19, 11,23,59); % S3.
T( 4).Ts=datetime(2018,10,19, 11,23,59); T( 4).Te=datetime(2018,10,20, 08,22,11); % S4.
T( 5).Ts=datetime(2018,10,20, 08,22,11); T( 5).Te=datetime(2018,10,22, 07,48,38); % S5.
T( 6).Ts=datetime(2018,10,22, 07,48,38); T( 6).Te=datetime(2018,10,23, 13,34,45); % S6.
T( 7).Ts=datetime(2018,10,23, 13,34,45); T( 7).Te=datetime(2018,10,24, 08,10,22); % S7.
T( 8).Ts=datetime(2018,10,24, 08,10,22); T( 8).Te=datetime(2018,10,25, 07,41,58); % S8.
T( 9).Ts=datetime(2018,10,25, 07,41,58); T( 9).Te=datetime(2018,10,25, 14,29,26); % S9.
T(10).Ts=datetime(2018,10,25, 14,29,26); T(10).Te=datetime(2018,10,26, 07,19,40); % S10.
T(11).Ts=datetime(2018,10,26, 07,19,40); T(11).Te=datetime(2018,10,27, 08,04,17); % S11.
T(12).Ts=datetime(2018,10,27, 08,04,17); T(12).Te=datetime(2018,10,29, 08,53,25); % S12.
T(13).Ts=datetime(2018,10,29, 08,53,25); T(13).Te=datetime(2018,10,30, 08,28,29); % S13.
T(14).Ts=datetime(2018,10,30, 08,28,29); T(14).Te=datetime(2018,10,31, 09,31,57); % S14.
T(15).Ts=datetime(2018,10,31, 09,31,57); T(15).Te=datetime(2018,11,02, 08,14,45); % S15.
T(16).Ts=datetime(2018,11,02, 08,14,45); T(16).Te=datetime(2018,11,03, 09,14,45); % S16.
%%%
T(17).Ts=datetime(2018,12,08, 09,25,01); T(17).Te=datetime(2018,12,10, 08,34,33); % S17.
T(18).Ts=datetime(2018,12,10, 08,34,33); T(18).Te=datetime(2018,12,11, 08,32,57); % S18.
T(19).Ts=datetime(2018,12,11, 08,32,57); T(19).Te=datetime(2018,12,13, 08,30,23); % S19.
T(20).Ts=datetime(2018,12,13, 08,30,23); T(20).Te=datetime(2018,12,14, 12,27,18); % S20.
T(21).Ts=datetime(2018,12,14, 12,27,18); T(21).Te=datetime(2018,12,15, 08,59,35); % S21.
T(22).Ts=datetime(2018,12,15, 08,59,35); T(22).Te=datetime(2018,12,17, 08,13,38); % S22.
T(23).Ts=datetime(2018,12,17, 08,13,38); T(23).Te=datetime(2018,12,18, 09,14,38); % S23.

% Get the dM distributions.
b=normrnd(bm,db,[1 N]);
dM0a=dM_distribution(b,  -1,'red+trail',[1 N]);
dM0b=dM_distribution(b,0.86,'red+trail',[1 N]);
dM01=dM_distribution(b,0.62,'red+trail',[1 N]);
dM02=dM_distribution(b,0.36,'red+trail',[1 N]);
dM03=dM_distribution(b,0.12,'red+trail',[1 N]);
dM04=dM_distribution(b,0.17,'red+trail',[1 N]);
dM05=dM_distribution(b,0.52,'red+trail',[1 N]);
dM06=dM_distribution(b,0.36,'red+trail',[1 N]);
dM07=dM_distribution(b,0.44,'red+trail',[1 N]);
dM08=dM_distribution(b,0.00,'red+trail',[1 N]);
dM09=dM_distribution(b,0.33,'red+trail',[1 N]);
dM10=dM_distribution(b,0.27,'red+trail',[1 N]);
dM11=dM_distribution(b,0.56,'red+trail',[1 N]);
dM12=dM_distribution(b,0.12,'red+trail',[1 N]);
dM13=dM_distribution(b,0.12,'red+trail',[1 N]);
dM14=dM_distribution(b,0.22,'red+trail',[1 N]);
dM15=dM_distribution(b,0.00,'red+trail',[1 N]);
dM16=dM_distribution(b,0.18,'red+trail',[1 N]);
dM17=dM_distribution(b,0.62,'red+trail',[1 N]);
dM18=dM_distribution(b,0.47,'red+trail',[1 N]);
dM19=dM_distribution(b,0.79,'red+trail',[1 N]);
dM20=dM_distribution(b,0.77,'red+trail',[1 N]);
dM21=dM_distribution(b,0.79,'red+trail',[1 N]);
dM22=dM_distribution(b,0.00,'red+trail',[1 N]);
dM23=dM_distribution(b,0.63,'red+trail',[1 N]);

dMr=median(dM0b)-[median(dM01) median(dM02) median(dM03) median(dM04) median(dM05) median(dM06) median(dM07) median(dM08) median(dM09) median(dM10) median(dM11) median(dM12) median(dM13) median(dM14) median(dM15) median(dM16) median(dM17) median(dM18) median(dM19) median(dM20) median(dM21) median(dM22) median(dM23)]+Mr;
%dMr=mean(dM0b)-[mean(dM01) mean(dM02) mean(dM03) mean(dM04) mean(dM05) mean(dM06) mean(dM07) mean(dM08) mean(dM09) mean(dM10) mean(dM11) mean(dM12) mean(dM13) mean(dM14) mean(dM15) mean(dM16) mean(dM17) mean(dM18) mean(dM19) mean(dM20) mean(dM21) mean(dM22) mean(dM23)]+Mr;

% Get the magnitude size axis.
Rs=getMscale(Mw);

% Plot the M-t timeseries.
figure(511); clf;
% First set of stages.
subplot(211);
%plot(S.cat.time,S.cat.mag,'o'); hold on;
scatter(te,Mw, Rs*1.5,'filled'); hold on;
plot(xlim(),Mr*[1 1],'-r');
plot(xlim(),My*[1 1],'-y','LineWidth',2);
plot([T.Te],dMr,'-o');
plot(ti,Vr-2.5,'-k');
xlim([datetime(2018, 10, 15) datetime(2018, 11, 7)]); ylim([-2.5 3.0]);
xlabel('Time'); ylabel('Magntiude (M_W)');
% Second set of stages.
subplot(212);
%plot(S.cat.time,S.cat.mag,'o'); hold on;
scatter(te,Mw, Rs*1.5,'filled'); hold on;
plot(xlim(),Mr*[1 1],'-r');
plot(xlim(),My*[1 1],'-y','LineWidth',2);
plot([T.Te],dMr,'-o');
plot(ti,Vr-2.5,'-k');
xlim([datetime(2018, 12, 8) datetime(2018, 12, 18)]); ylim([-2.5 3.0]);
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
