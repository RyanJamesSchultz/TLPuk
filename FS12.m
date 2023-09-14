clear;

% Define the TLP.
Mr=(1.7);
My=Mr-2;

% Get the catalogue data.
load('/Users/rschultz/Desktop/old/Trailing/IS-bath/data/processed/PH.mat');
te=datetime(S.cat.time,'ConvertFrom','datenum');
Mw=S.cat.mag;
ML=(Mw);
ti=datetime(S.inj.time,'ConvertFrom','datenum');
Vr=S.inj.rate;

% Get the magnitude size axis.
Rs=getMscale(Mw);

% Plot the M-t timeseries.
figure(512); clf;
% First set of stages.
%plot(S.cat.time,S.cat.mag,'o'); hold on;
scatter(te,Mw, Rs*1.5,'filled'); hold on;
plot(ti,Vr/3-2,'-k');
xlim([datetime(2011, 03, 25) datetime(2011, 05, 30)]); ylim([-2.0 3.0]);
plot(xlim(),Mr*[1 1],'-r');
plot(xlim(),My*[1 1],'-y','LineWidth',2);
xlabel('Time'); ylabel('Magntiude (M_L)');




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
