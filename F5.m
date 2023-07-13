clear;

% Plotting aspect ratio.
AR=1.3;

% Load in the data structures: M & S.
load('TLPmap_uk.mat','M');
load('TLP_uk.mat','S');

% Get boundaries of play area.
YL=[min(S.MAP.latB)-0.1 max(S.MAP.latB)+0.1];
XL=[min(S.MAP.lonB)-0.1 max(S.MAP.lonB)+0.1];

% Load in the country boundary shapefiles.
ShapeFilename1='/Users/rschultz/Desktop/TLPuk/data/Outlines/GBR_adm/GBR_adm0.shp';
ShapeFilename2='/Users/rschultz/Desktop/TLPuk/data/Outlines/IRL_adm/IRL_adm0.shp';
ShapeFilename3='/Users/rschultz/Desktop/TLPuk/data/Outlines/FRA_adm/FRA_adm0.shp';
ShapeFilename4='/Users/rschultz/Desktop/TLPuk/data/Outlines/BEL_adm/BEL_adm0.shp';
ShapeFilename5='/Users/rschultz/Desktop/TLPuk/data/Outlines/NLD_adm/NLD_adm0.shp';
S1=shaperead(ShapeFilename1);
S2=shaperead(ShapeFilename2);
S3=shaperead(ShapeFilename3);
S4=shaperead(ShapeFilename4);
S5=shaperead(ShapeFilename5);

% Plot iso-magnitude maps.
figure(5); clf;
% Nuisance impacts.
subplot(131);
contourf(M.N.N3.lon,M.N.N3.lat,log10(M.N.N3.Nn),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title(['Iso-Magnitude Nuisance Map (M_L=',num2str(M.N.Tm),')']);
h = colorbar(); ylabel(h, 'log_{10} [Impacted Household Count]');
colormap(gca,R_colormap('nuisance')); %caxis([4 6]);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% Damage impacts.
subplot(132);
contourf(M.D.D1.lon,M.D.D1.lat,log10(M.D.D1.Nd),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title(['Iso Magnitude Damage Map (M_L=',num2str(M.N.Tm),')']);
h = colorbar(); ylabel(h, 'log_{10} [Damaged Household Count]');
colormap(gca,R_colormap('damage')); caxis([-1 3]);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% LPR.
subplot(133);
contourf(M.R.R1.lon,M.R.R1.lat,log10(M.R.R1.Nr),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title(['Iso Magnitude LPR Map (M_L=',num2str(M.N.Tm),')']);
h = colorbar(); ylabel(h, 'log_{10} [LPR, Probability of Fatality]');
colormap(gca,R_colormap('LPR')); caxis([-10 -6]);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
