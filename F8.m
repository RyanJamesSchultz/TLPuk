clear;

% Plotting aspect ratio.
AR=1.3;

% Load in the data structures: M & S.
load('TLPmap_uk.mat','M');
load('TLP_uk.mat','S');

% Predefine some variables.
ML_c=[1.0 4.0];
nc=(6*3)+1;

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

% Plot the iso-risk-combination & controlling-factor maps.
figure(8); clf;
% Plot the combination map.
subplot(121);
contourf(M.N.N4.lon,M.N.N4.lat,M.Mcomb,linspace(ML_c(1),ML_c(2),nc),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Iso-Risk Combination Map');
h = colorbar(); ylabel(h, 'Red-Light Magnitude (M_L)');
colormap(gca,R_colormap('red-light')); clim(ML_c);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% Plot the controlling indicies.
subplot(122);
contourf(M.N.N3.lon,M.N.N3.lat,M.index,'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k','linewidth',2);
plot(S1.X,S1.Y,'-k');
plot(S2.X,S2.Y,'-k');
plot(S3.X,S3.Y,'-k');
plot(S4.X,S4.Y,'-k');
plot(S5.X,S5.Y,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Controlling Risk Factor');
h = colorbar(); ylabel(h, 'Controlling Risk Factor');
colormap(gca,R_colormap('indicies')); clim([1 3]);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);