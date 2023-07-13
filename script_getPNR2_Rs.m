clear;

% Define the Mc.
Mc=-1.0;

% Get the catalogue data.
load('/Users/rschultz/Desktop/old/Trailing/IS-bath/data/processed/PNR2.mat');
te=datetime(S.cat.time,'ConvertFrom','datenum');
Mw=S.cat.mag;
ti=datetime(S.inj.time,'ConvertFrom','datenum')+1/24;
Vr=S.inj.rate;

% Get the start/stop times for each stage.
T=struct('Ts',[],'Te',[], 'Rs',[]);
T(1).Ts=datetime(2019,08,15, 08,13,40); T(1).Te=datetime(2019,08,16, 08,01,46);
T(2).Ts=datetime(2019,08,16, 08,01,46); T(2).Te=datetime(2019,08,17, 08,00,06);
T(3).Ts=datetime(2019,08,17, 08,00,06); T(3).Te=datetime(2019,08,19, 08,12,18);
T(4).Ts=datetime(2019,08,19, 08,12,18); T(4).Te=datetime(2019,08,20, 07,57,25);
T(5).Ts=datetime(2019,08,20, 07,57,25); T(5).Te=datetime(2019,08,21, 08,44,28);
T(6).Ts=datetime(2019,08,21, 08,44,28); T(6).Te=datetime(2019,08,23, 10,21,42);
T(7).Ts=datetime(2019,08,23, 10,21,42); T(7).Te=datetime(2019,10,03, 01,01,01);

for i=1:length(T)
    tx=te((te>=T(i).Ts)&(te<T(i).Te)&(Mw>=Mc));
    Vx=interp1(ti,Vr,tx,'nearest');
    T(i).Rs=length(tx(Vx>0))/length(tx);
end

% Get the magnitude size axis.
r=getMscale(Mw);

% Plot the M-t timeseries.
figure(10); clf;
%plot(S.cat.time,S.cat.mag,'o'); hold on;
scatter(te,Mw, r*1.5,'filled'); hold on;
plot(xlim(),Mc*[1 1],'--k');
plot(ti,Vr-2.5,'-b');
for i=1:length(T)
    plot([T(i).Ts T(i).Ts], ylim(), ':k');
end
xlim([datetime(2019, 08, 15) datetime(2019, 08, 31)]); ylim([-2.5 3.0]);
xlabel('Time'); ylabel('Magntiude');

[T.Rs]
mean([T.Rs])




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
