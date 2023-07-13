clear;

% Plotting aspect ratio.
AR=1.3;

% Load in the blank dataset.
load('blanks/TLP_uk-highres.mat','S');

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

% Get boundaries of play area.
YL=[min(S.MAP.latB)-0.1 max(S.MAP.latB)+0.1];
XL=[min(S.MAP.lonB)-0.1 max(S.MAP.lonB)+0.1];

% Get lengths of map edges.
Nx=length(S.MAP.lonG);
Ny=length(S.MAP.latG);
latG=repmat(S.MAP.latG',1,Nx); latG=latG(:);
lonG=repmat(S.MAP.lonG,Ny,1); lonG=lonG(:);
I=(latG>=min(YL))&(latG<=max(YL))&(lonG>=min(XL))&(lonG<=max(XL));

% Plot.
figure(2); clf;
% The formation depth map.
subplot(131);
contourf(S.MAP.lonE,S.MAP.latE,S.MAP.DEP,'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Formation Depth');
h = colorbar(); colormap(gca,R_colormap('Depth')); ylabel(h, 'True Vertical Depth (km)'); hold off;
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% The Vs30 map.
subplot(132);
contourf(S.MAP.lonG,S.MAP.latG,S.MAP.Vs30,'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Site Amplification');
h = colorbar(); colormap(gca,R_colormap('Vs30')); ylabel(h, 'Site Amplififcation, Vs30 (m/s)'); hold off;
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% The population density map.
subplot(133);
contourf(S.MAP.lonG,S.MAP.latG,log10(S.MAP.POP),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-w','linewidth',2);
plot(S1.X,S1.Y,'-w');
plot(S2.X,S2.Y,'-w');
plot(S3.X,S3.Y,'-w');
plot(S4.X,S4.Y,'-w');
plot(S5.X,S5.Y,'-w');
set(gca,'Color','k');
xlabel('Longitude'); ylabel('Latitude'); title(['Population (',sprintf('%0.3g',sum(sum(S.MAP.POP(I)))),')']);
h = colorbar(); colormap(gca,R_colormap('population')); ylabel(h, 'Population (log_{10}[people])'); hold off;
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);


