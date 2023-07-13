clear;

% Define the TLP.
Mr=ML2Mw(1.7);
My=Mr-2;

% Get the catalogue data.
load('/Users/rschultz/Desktop/old/Trailing/IS-bath/data/processed/PNR2.mat');
te=datetime(S.cat.time,'ConvertFrom','datenum');
Mw=S.cat.mag;
ML=Mw2ML(Mw);
ti=datetime(S.inj.time,'ConvertFrom','datenum');
Vr=S.inj.rate;

% Get the magnitude size axis.
Rs=getMscale(Mw);

% Plot the M-t timeseries.
figure(10); clf;
%plot(S.cat.time,S.cat.mag,'o'); hold on;
scatter(te,Mw, Rs*1.5,'filled'); hold on;
plot(xlim(),Mr*[1 1],'-k');
plot(xlim(),My*[1 1],'--k');
plot(ti,Vr-2.5,'-b');
xlim([datetime(2019, 08, 15) datetime(2019, 08, 31)]); ylim([-2.5 3.0]);
xlabel('Time'); ylabel('Magntiude');






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
