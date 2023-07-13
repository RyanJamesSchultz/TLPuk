clear;

% Plotting aspect ratio.
AR=1.3;

% Load in the blank dataset.
load('blanks/TLP_uk-highres.mat','S');
%load('blanks/Rmap_temp.mat','S');

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
YL=[min(S.MAP.latB)-1.5 max(S.MAP.latB)+1.5];
XL=[min(S.MAP.lonB)-1.5 max(S.MAP.lonB)+1.5];

% Get lengths of map edges.
Nxg=length(S.MAP.lonG);
Nyg=length(S.MAP.latG);
latG=repmat(S.MAP.latG',1,Nxg); latG=latG(:);
lonG=repmat(S.MAP.lonG,Nyg,1); lonG=lonG(:);
I1=(latG>=min(YL))&(latG<=max(YL))&(lonG>=min(XL))&(lonG<=max(XL));

% Find map points inside of boundaries.
Nxe=length(S.MAP.lonE);
Nye=length(S.MAP.latE);
latE=repmat(S.MAP.latE',1,Nxe); latE=latE(:);
lonE=repmat(S.MAP.lonE,Nye,1); lonE=lonE(:);
I2=inpolygon(lonE,latE,S.MAP.lonB,S.MAP.latB); I2=reshape(I2,size(S.MAP.DEP));
DEPp=S.MAP.DEP; DEPp(~I2)=NaN;

% Plot Figure S1, the isothermal depth map.
figure(51); clf;
contourf(S.MAP.lonE,S.MAP.latE,DEPp,'LineColor','none'); hold on;
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

% Plot Figure S2, the Vs30 map.
figure(52); clf;
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

% Plot Figure S4, the population density map.
figure(53); clf;
contourf(S.MAP.lonG,S.MAP.latG,log10(S.MAP.POP),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-w','linewidth',2);
plot(S1.X,S1.Y,'-w');
plot(S2.X,S2.Y,'-w');
plot(S3.X,S3.Y,'-w');
plot(S4.X,S4.Y,'-w');
plot(S5.X,S5.Y,'-w');
set(gca,'Color','k');
xlabel('Longitude'); ylabel('Latitude'); title(['Population (',sprintf('%0.3g',sum(sum(S.MAP.POP(I1)))),')']);
h = colorbar(); colormap(gca,R_colormap('population')); ylabel(h, 'Population (log_{10}[people])'); hold off;
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);


