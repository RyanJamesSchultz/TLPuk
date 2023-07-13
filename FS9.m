clear;

% Load in the data structures: M & S.
load('TLPmap_uk.mat');
load('TLP_uk.mat');

% Predefine some variables.
ML_c=[1.0 4.0];
nc=(6*3)+1;
AR=1.3;

% Get boundaries of play area.
YL=[min(S.MAP.latB)-0.1 max(S.MAP.latB)+0.1];
XL=[min(S.MAP.lonB)-0.1 max(S.MAP.lonB)+0.1];

% Plot the iso-damage maps (P10).
figure(59); clf;
% Plot DS 1.
subplot(2,2,1);
contourf(M.D.D1.lon,M.D.D1.lat,M.D.D1.Mr,linspace(ML_c(1),ML_c(2),nc),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); title(['DS 1 Iso-Damage Map']);
h = colorbar(); ylabel(h, 'Red-Light Magnitude (M_L)');
colormap(gca,R_colormap('red-light')); caxis(ML_c);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% Plot DS 2.
subplot(2,2,2);
contourf(M.D.D2.lon,M.D.D2.lat,M.D.D2.Mr,linspace(ML_c(1),ML_c(2),nc),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); title(['DS 2 Iso-Damage Map']);
h = colorbar(); ylabel(h, 'Red-Light Magnitude (M_L)');
colormap(gca,R_colormap('red-light')); caxis(ML_c);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% Plot the combination map.
subplot(2,2,3);
contourf(M.D.D1.lon,M.D.D1.lat,M.D.Mcomb,linspace(ML_c(1),ML_c(2),nc),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Iso-Damage Combination Map');
h = colorbar(); ylabel(h, 'Red-Light Magnitude (M_L)');
colormap(gca,R_colormap('red-light')); caxis(ML_c);
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);
% Plot the controlling indicies.
subplot(2,2,4);
contourf(M.D.D1.lon,M.D.D1.lat,M.D.index+abs(normrnd(0,0.01,size(M.D.index))),'LineColor','none'); hold on;
plot(S.MAP.lonB,S.MAP.latB,'-k');
xlabel('Longitude'); ylabel('Latitude'); title('Controlling Damage State');
h = colorbar(); ylabel(h, 'Controlling Damage Index (DS)'); caxis([1 2]);
colormap(gca,R_colormap('damage'));
xlim(XL); ylim(YL);
pbaspect([1 AR 1]);

