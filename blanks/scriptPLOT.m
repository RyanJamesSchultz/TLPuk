clear;

% Load in the blank dataset.
load('TLP_uk.mat','S');
%load('Rmap_temp.mat','S');

% Plot the input datasets.
figure(1); clf;

subplot(411);
contourf(S.MAP.lonG,S.MAP.latG,S.MAP.Vs30,'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Site Amplification');
h = colorbar(); colormap(gca,R_colormap('Vs30')); ylabel(h, 'Site Amplififcation, Vs30 (m/s)'); hold off;

subplot(412);
contourf(S.MAP.lonE,S.MAP.latE,S.MAP.DEP,'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Isotherm Depth');
h = colorbar(); colormap(gca,R_colormap('Depth')); ylabel(h, 'True Vertical Depth (km)'); hold off;

subplot(413);
contourf(S.MAP.lonG,S.MAP.latG,log10(S.MAP.POP),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-w');
set(gca,'Color','k');
xlabel('Longitude'); ylabel('Latitude'); title(['Population (',sprintf('%0.3g',sum(sum(S.MAP.POP))),')']);
h = colorbar(); colormap(gca,R_colormap('population')); ylabel(h, 'Population (log_{10}[people])'); hold off;

subplot(414);
contourf(S.MAP.lonE,S.MAP.latE,S.MAP.Ir,'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); colorbar(); colormap(gca,'default'); title('In Bounds'); hold off;


figure(2); clf;
contourf(S.MAP.lonG,S.MAP.latG,log10(S.MAP.POP),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-w');
set(gca,'Color','k');
xlabel('Longitude'); ylabel('Latitude'); title(['Population (',sprintf('%0.3g',sum(sum(S.MAP.POP))),')']);
h = colorbar(); colormap(gca,R_colormap('population')); ylabel(h, 'Population (log_{10}[people])'); hold off;
