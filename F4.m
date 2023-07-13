clear;

% Load in the data structure: S.
load('blanks/TLP_uk-highres.mat','S'); Sh=S;
load('TLP_uk.mat','S');

% Predefine some variables.
GREY=[0.85,0.85,0.85];
lat=[53.50 53.50 54.15 54.35];
lon=[-2.25 -1.40 -0.85 -0.68];
[~,m]=min(Geoid_Distance(lat(1),lon(1),[S.RISK.lat],[S.RISK.lon],'spherical'));
[~,i]=min(Geoid_Distance(lat(2),lon(2),[S.RISK.lat],[S.RISK.lon],'spherical'));
[~,j]=min(Geoid_Distance(lat(3),lon(3),[S.RISK.lat],[S.RISK.lon],'spherical'));
[~,k]=min(Geoid_Distance(lat(4),lon(4),[S.RISK.lat],[S.RISK.lon],'spherical'));
Nv=length(S.dVAR.b);
yld=[7e-2 7e+5];
yln=[7e+2 7e+6];
ylf=[1e-7 1e0];
ML_c=[1.0 4.0];
ML_f=2.5;
AR=1.3;

% Risk tolerances.
Nn2_f=1.7555e+04;
Nn3_f=9.1051e+03;
Nn4_f=4.4162e+03;
Nd1_f=1;
Nd2_f=1e-4;
lpr_f=1e-6;

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

% Plot some of the count curves.
figure(4); clf;
% Pop map & locaitons.
subplot(2,5,[1 2 6 7]);
contourf(Sh.MAP.lonG,Sh.MAP.latG,log10(Sh.MAP.POP),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-w','linewidth',2);
plot(S1.X,S1.Y,'-w');
plot(S2.X,S2.Y,'-w');
plot(S3.X,S3.Y,'-w');
plot(S4.X,S4.Y,'-w');
plot(S5.X,S5.Y,'-w');
plot(S.RISK(m).lon,S.RISK(m).lat,'wo','MarkerFaceColor','k');
plot(S.RISK(i).lon,S.RISK(i).lat,'wo','MarkerFaceColor','k');
plot(S.RISK(j).lon,S.RISK(j).lat,'wo','MarkerFaceColor','k');
plot(S.RISK(k).lon,S.RISK(k).lat,'wo','MarkerFaceColor','k');
set(gca,'Color','k');
xlabel('Longitude'); ylabel('Latitude'); title(['Population (',sprintf('%0.3g',sum(sum(S.MAP.POP))),')']);
h = colorbar(); colormap(gca,R_colormap('population')); ylabel(h, 'Population (log_{10}[people])'); hold off;
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% CDI 2.
subplot(2,5,3);
%semilogy(S.Mw,S.RISK(i).Nn2,'-','color',GREY); hold on;
%semilogy(S.Mw,mean(S.RISK(i).Nn2,1),'-r');
semilogy(S.Mw,median(S.RISK(m).Nn2,1),'-'); hold on;
semilogy(S.Mw,median(S.RISK(i).Nn2,1),'-');
semilogy(S.Mw,median(S.RISK(j).Nn2,1),'-');
semilogy(S.Mw,median(S.RISK(k).Nn2,1),'-');
line(ML_c,Nn2_f*[1 1],'Color','k','LineStyle','--');
line(ML_f*[1 1],ylim(), 'Color','k','LineStyle','--');
xlabel('Red-Light Magnitdue (M_L)'); ylabel('Impacted Household Count'); title('Nuisance: CDI 2');
ylim(yln); xlim(ML_c);
% CDI 3.
subplot(2,5,4);
%semilogy(S.Mw,S.RISK(i).Nn3,'-','color',GREY); hold on;
%semilogy(S.Mw,mean(S.RISK(i).Nn3,1),'-r');
semilogy(S.Mw,median(S.RISK(m).Nn3,1),'-'); hold on;
semilogy(S.Mw,median(S.RISK(i).Nn3,1),'-');
semilogy(S.Mw,median(S.RISK(j).Nn3,1),'-');
semilogy(S.Mw,median(S.RISK(k).Nn3,1),'-');
line(ML_c,Nn3_f*[1 1],'Color','k','LineStyle','--');
line(ML_f*[1 1],ylim(), 'Color','k','LineStyle','--');
xlabel('Red-Light Magnitdue (M_L)'); ylabel('Impacted Household Count'); title('Nuisance: CDI 3');
ylim(yln); xlim(ML_c);
% CDI 4.
subplot(2,5,5);
%semilogy(S.Mw,S.RISK(i).Nn4,'-','color',GREY); hold on;
%semilogy(S.Mw,mean(S.RISK(i).Nn4,1),'-r');
semilogy(S.Mw,median(S.RISK(m).Nn4,1),'-'); hold on;
semilogy(S.Mw,median(S.RISK(i).Nn4,1),'-');
semilogy(S.Mw,median(S.RISK(j).Nn4,1),'-');
semilogy(S.Mw,median(S.RISK(k).Nn4,1),'-');
line(ML_c,Nn4_f*[1 1],'Color','k','LineStyle','--');
line(ML_f*[1 1],ylim(), 'Color','k','LineStyle','--');
xlabel('Red-Light Magnitdue (M_L)'); ylabel('Impacted Household Count'); title('Nuisance: CDI 4');
ylim(yln); xlim(ML_c);
% DS 1.
subplot(2,5,8);
%semilogy(S.Mw,S.RISK(i).Nd1,'-','color',GREY); hold on;
%semilogy(S.Mw,mean(S.RISK(i).Nd1,1),'-r');
semilogy(S.Mw,median(S.RISK(m).Nd1,1),'-'); hold on;
semilogy(S.Mw,median(S.RISK(i).Nd1,1),'-');
semilogy(S.Mw,median(S.RISK(j).Nd1,1),'-');
semilogy(S.Mw,median(S.RISK(k).Nd1,1),'-');
line(ML_c,Nd1_f*[1 1],'Color','k','LineStyle','--');
line(ML_f*[1 1],ylim(), 'Color','k','LineStyle','--');
xlabel('Red-Light Magnitdue (M_L)'); ylabel('Damaged Household Count'); title('Damage: DS 1');
ylim(yld); xlim(ML_c);
% DS 2.
subplot(2,5,9);
%semilogy(S.Mw,S.RISK(i).Nd2,'-','color',GREY); hold on;
%semilogy(S.Mw,mean(S.RISK(i).Nd2,1),'-r');
semilogy(S.Mw,median(S.RISK(m).Nd2,1),'-'); hold on;
semilogy(S.Mw,median(S.RISK(i).Nd2,1),'-');
semilogy(S.Mw,median(S.RISK(j).Nd2,1),'-');
semilogy(S.Mw,median(S.RISK(k).Nd2,1),'-');
line(ML_c,Nd2_f*[1 1],'Color','k','LineStyle','--');
line(ML_f*[1 1],ylim(), 'Color','k','LineStyle','--');
xlabel('Red-Light Magnitdue (M_L)'); ylabel('Damaged Household Count'); title('Damage: DS 2');
ylim(yld); xlim(ML_c);
% LPR.
subplot(2,5,10);
%semilogy(S.Mw,S.RISK(i).Pf1,'-','color',GREY); hold on;
%semilogy(S.Mw,mean(S.RISK(i).Pf1,1),'-r');
semilogy(S.Mw,median(S.RISK(m).LPR,1),'-'); hold on;
semilogy(S.Mw,median(S.RISK(i).LPR,1),'-');
semilogy(S.Mw,median(S.RISK(j).LPR,1),'-');
semilogy(S.Mw,median(S.RISK(k).LPR,1),'-');
line(ML_c,lpr_f*[1 1],'Color','k','LineStyle','--');
line(ML_f*[1 1],ylim(), 'Color','k','LineStyle','--');
xlabel('Red-Light Magnitdue (M_L)'); ylabel('Probability of Fatality'); title('LPR: Fatality');
ylim(ylf); xlim(ML_c);


% subplot(4,5,[7 10]);
% semilogy(S.Mw,median(S.RISK(i).Nn2,1),'DisplayName','CDI 2'); hold on;
% semilogy(S.Mw,median(S.RISK(i).Nn3,1),'DisplayName','CDI 3');
% semilogy(S.Mw,median(S.RISK(i).Nn4,1),'DisplayName','CDI 4');
% semilogy(S.Mw,median(S.RISK(i).Nn5,1),'DisplayName','CDI 5');
% semilogy(S.Mw,median(S.RISK(i).Nn6,1),'DisplayName','CDI 6');
% h=line(xlim(),Nn3_f*[1 1],'Color',GREY,'LineStyle','--'); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h=line(ML_f*[1 1],ylim(), 'Color',GREY,'LineStyle','--'); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xlabel('Red-Light Magnitdue (M_L)'); ylabel('Number of Households Impacted'); title('Nuisance'); legend('Location','southeast');
% xlim(ML_c); %ylim(yl);
% subplot(4,5,[8 11]);
% semilogy(S.Mw,median(S.RISK(i).Nd1,1),'DisplayName','DS 1'); hold on;
% semilogy(S.Mw,median(S.RISK(i).Nd2,1),'DisplayName','DS 2');
% h=line(xlim(),Nd1_f*[1 1],'Color',GREY,'LineStyle','--'); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h=line(ML_f*[1 1],ylim(), 'Color',GREY,'LineStyle','--'); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xlabel('Red-Light Magnitdue (M_L)'); ylabel('Number of Households Impacted'); title('Damage'); legend('Location','southeast');
% xlim(ML_c); %ylim(yl);
% subplot(4,5,[9 12]);
% semilogy(S.Mw,median(S.RISK(i).Pf1,1),'DisplayName','LPR'); hold on;
% h=line(xlim(),Pf1_f*[1 1],'Color',GREY,'LineStyle','--'); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h=line(ML_f*[1 1],ylim(), 'Color',GREY,'LineStyle','--'); h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xlabel('Red-Light Magnitdue (M_L)'); ylabel('Probability of Loss of Life'); title('LPR');
% ylim([1e-7 1e0]); xlim(ML_c);
