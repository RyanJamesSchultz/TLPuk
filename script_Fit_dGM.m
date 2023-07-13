clear;

% Predefine some values.
vs30=250;
dE=-2.0:0.01:+3.0;
%dE=+1.7;

% Predefine a structure.
R=struct('ML',[],'Mw',[],'lat',[],'lon',[],'dep',[],'dGM',[],'year',[],'name',[],'Ss',[]);
res_a=zeros(size(dE));
res_v=res_a;

% Populate the structure with relevant information on each earthquake scenario.
i=1;
%R(i).ML=2.9; R(i).lat=53.787; R(i).lon=-2.964; R(i).dep=2.5; R(i).dGM=+0.4; R(i).year=2019; R(i).name='PNR2  M 2.9 2019-08-26'; i=i+1;
%R(i).ML=2.1; R(i).lat=53.786; R(i).lon=-2.969; R(i).dep=2.1; R(i).dGM=+0.2; R(i).year=2019; R(i).name='PNR2  M 2.1 2019-08-24'; i=i+1;
%R(i).ML=1.6; R(i).lat=53.785; R(i).lon=-2.971; R(i).dep=2.1; R(i).dGM=-0.1; R(i).year=2019; R(i).name='PNR2  M 1.6 2019-08-21'; i=i+1;
R(i).ML=1.6; R(i).lat=53.787; R(i).lon=-2.965; R(i).dep=2.3; R(i).dGM=+0.1; R(i).year=2018; R(i).name='PNR1z M 1.6 2018-12-11'; i=i+1;
%R(i).ML=2.3; R(i).lat=53.xxx; R(i).lon=-2.xxx; R(i).dep=2.x; R(i).dGM=-0.x; R(i).year=2011; R(i).name='PH-1  M 2.3 2011-04-01'; i=i+1;
%R(i).ML=3.2; R(i).lat=51.159; R(i).lon=-0.240; R(i).dep=2.1; R(i).dGM=+1.9; R(i).year=2019; R(i).name='Hhill M 3.2 2019-02-27'; i=i+1;
%R(i).ML=3.0; R(i).lat=51.154; R(i).lon=-0.269; R(i).dep=2.3; R(i).dGM=+2.5; R(i).year=2018; R(i).name='Hhill M 3.0 2018-07-05'; i=i+1;
%R(i).ML=2.7; R(i).lat=51.164; R(i).lon=-0.257; R(i).dep=3.1; R(i).dGM=+2.4; R(i).year=2018; R(i).name='Hhill M 2.7 2018-04-01'; i=i+1;
%R(i).ML=2.5; R(i).lat=51.168; R(i).lon=-0.239; R(i).dep=2.4; R(i).dGM=+2.1; R(i).year=2019; R(i).name='Hhill M 2.5 2018-06-18'; i=i+1;

% Pick just one of the events to examine.
i=1;

% Get the ground motion data for that one event.
if(strcmpi(R(i).name,'PNR2  M 2.9 2019-08-26'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/PNR2_29.csv';
elseif(strcmpi(R(i).name,'PNR2  M 2.1 2019-08-24'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/PNR2_21.csv';
elseif(strcmpi(R(i).name,'PNR2  M 1.6 2019-08-21'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/PNR2_16.csv';
elseif(strcmpi(R(i).name,'PNR1z M 1.6 2018-12-11'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/PNR1z_16.csv';
elseif(strcmpi(R(i).name,'PH-1  M 2.3 2011-04-01'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/XX.csv';
elseif(strcmpi(R(i).name,'Hhill M 3.2 2019-02-27'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/HH_32.csv';
elseif(strcmpi(R(i).name,'Hhill M 3.0 2018-07-05'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/HH_30.csv';
elseif(strcmpi(R(i).name,'Hhill M 2.7 2018-04-01'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/HH_27.csv';
elseif(strcmpi(R(i).name,'Hhill M 2.5 2018-06-18'))
    file='/Users/rschultz/Desktop/TLPuk/data/GroundMotion/HH_25a.csv';
end
[r_d,pga_d,pgv_d]=parseGMbgs(file);

if(strcmpi(R(i).name,'Hhill M 3.2 2019-02-27'))
    I=r_d<10;
    r_d(I)=[];
    pga_d(I)=[];
    pgv_d(I)=[];
end

% Compute the synthetic GMPE values.
r_f=r_d;
R(i).Mw=ML2Mw(R(i).ML);
for j=1:length(dE)
    pga_f=GMPE(r_f,R(i).Mw,R(i).dep,vs30,dE(j),'inter', 0,'edw21');
    pgv_f=GMPE(r_f,R(i).Mw,R(i).dep,vs30,dE(j),'inter',-1,'edw21');

    res_a(j)=norm(log10(pga_f)-log10(pga_d));
    res_v(j)=norm(log10(pgv_f)-log10(pgv_d));
end

% Plot the fit results.
figure(1); clf;
subplot(121);
loglog(r_d,pga_d,'or'); hold on;
loglog(r_f,pga_f,'-b');
xlabel('Epicentral Distance (km)'); ylabel('PGA (cm/s^2)');
subplot(122);
loglog(r_d,pgv_d,'or'); hold on;
loglog(r_f,pgv_f,'-b');
xlabel('Epicentral Distance (km)'); ylabel('PGV (cm/s)');

% Plot the residual parabola.
figure(2);
subplot(121);
plot(dE,res_a,'o');
xlabel('Ground Motion Variance Z-score'); ylabel('PGA Fit Residual');
subplot(122);
plot(dE,res_v,'o');
xlabel('Ground Motion Variance Z-score'); ylabel('PGV Fit Residual');





%%%% SUBROUNTINES.

% Get the moment magnitudes.
function [Mw]=ML2Mw(ML)
  % Computes the Mw given an ML, based on Edwards et al. (2015).
  Mw=(2/3)*ML+0.833;
  
end
