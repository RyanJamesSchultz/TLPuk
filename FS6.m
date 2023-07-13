clear;

% Predefine.
Y=1990:2022;
ya=2018;
[R1,R2]=POPvT(Y,ya);
Ylim=[0.8 1.2];

% Plot.
figure(56); clf;
plot(Y,mean([R1;R2]),'-o','DisplayName','Netherlands'); hold on;
xlabel('Year'); ylabel('Normalized UK Population');
h=plot(ya*[1 1],Ylim,'--k');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
ylim(Ylim); xlim([min(Y) max(Y)]);

% Load in the UK1 population dataset.
data=load('/Users/rschultz/Desktop/TLPuk/data/POPvT/UK1.csv');
Y1=data(:,1);
P1=data(:,2);

% Load in the UK2 population dataset.
data=load('/Users/rschultz/Desktop/TLPuk/data/POPvT/UK2.csv');
Y2=data(:,1);
P2=data(:,2);

% Output populations in 2018.
mean([interp1(Y1,P1,ya,'linear') interp1(Y2,P2,ya,'linear')])
