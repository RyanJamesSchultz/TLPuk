clear;

% Load in the data structures: M & S.
load('TLPmap_uk.mat','M');
load('TLP_uk.mat','S');

% Get lengths of map edges.
Nx=length(M.N.N4.lon);
Ny=length(M.N.N4.lat);

% Get lists of all of the lat/long coords of interest.
latM=repmat(M.N.N4.lat',1,Nx);
lonM=repmat(M.N.N4.lon,Ny,1);
m=M.Mcomb;

% Seperate the red-light maps out into the three basins.
Mw=m(latM<52);
Mb=m((latM<55)&(latM>52));
Mm=m(latM>55);

%%

% Report some stats.
[min(Mm) nanmedian(Mm) nanmean(Mm) max(Mm)]
[min(Mb) nanmedian(Mb) nanmean(Mb) max(Mb)]
[min(Mw) nanmedian(Mw) nanmean(Mw) max(Mw)]

figure(1); clf;
histogram(Mm,'Normalization','pdf'); hold on;
histogram(Mb,'Normalization','pdf');
histogram(Mw,'Normalization','pdf');
%histogram(m,'Normalization','pdf');