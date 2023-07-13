clear;

% Input variables.
Re=5;
dep=3;
vs30=300;
dE=0;
T=10.^(-2:0.1:1)';
gm_v=10.^(-4.0:0.2:2.0);
gm_a=0.00:0.01:1.00;
N=100;
GMPEflag='edw21';
GREY=[0.85,0.85,0.85];

% Load in the data structure: S.
load('TLP_uk.mat');
ML=S.ML;
Mw=S.Mw;

% Compute GM vs M.
pgv=GMPE(Re,ML,dep,vs30,dE,'total',-1,GMPEflag); % cm/s.

% Compute the average spectral acceleration (PSAi:g).
SAavg=zeros(size(Mw));
for i=1:length(Mw)
    psa_temp=zeros(size(T));
    for k=1:length(T)
        psa_temp(k)=GMPE(Re,Mw(i),dep,vs30,dE,'total',  T(k),GMPEflag)/980.665;
    end
    SAavg(i)=AvgSA(T,real(psa_temp),0.2,'NL');
end
Pm=VULNfxn_groningen(SAavg,0)*0.95;
Pu=VULNfxn_groningen(SAavg,+2)*0.95;
Pd=VULNfxn_groningen(SAavg,-2)*0.95;

% Plot.
figure(54); clf;

% Nuisance vs PGV.
subplot(231);
semilogx(gm_v,NUISfxn(gm_v,[0 0],2),'-b'); hold on;
for i=1:N
    semilogx(gm_v,NUISfxn(gm_v,normrnd(0,1,[1 2]),2),'-','Color',GREY);
end
semilogx(gm_v,NUISfxn(gm_v,[0 0],3),'-r');
for i=1:N
    semilogx(gm_v,NUISfxn(gm_v,normrnd(0,1,[1 2]),3),'-','Color',GREY);
end
semilogx(gm_v,NUISfxn(gm_v,[0 0],4),'-y');
for i=1:N
    semilogx(gm_v,NUISfxn(gm_v,normrnd(0,1,[1 2]),4),'-','Color',GREY);
end
xlabel('PGV (m/s)'); ylabel('Nuisance Risk, Probability of Felt Ground Motion');
ylim([0 1]); xlim(10.^[-4 1]);

% Damage vs PGV.
subplot(232);
loglog(gm_v,FRAGfxn_cosmetic(gm_v*1000,0,1),'-k'); hold on;
for i=1:N
    loglog(gm_v,FRAGfxn_cosmetic(gm_v*1000,abs(normrnd(0.0,0.15,[1 1])),1),'-','Color',GREY);
end
loglog(gm_v,FRAGfxn_cosmetic(gm_v*1000,0,2),'-k'); hold on;
for i=1:N
    semilogx(gm_v,FRAGfxn_cosmetic(gm_v*1000,abs(normrnd(0.0,0.15,[1 1])),2),'-','Color',GREY);
end
xlabel('PGV (m/s)'); ylabel('Damage Risk, Probability of Cosmetic Damage');
xlim(10.^[-3 0]);
ylim([0 1]);

% LPR vs avPSA.
subplot(233);
plot(gm_a,VULNfxn_groningen(gm_a,0)*0.95,'-k'); hold on;
for i=1:N
    plot(gm_a,VULNfxn_groningen(gm_a,normrnd(0,1,[1 1]))*0.95,'-','Color',GREY);
end
xlabel('Average Spectral Acceleration (g)'); ylabel('Personal Risk, Probability of Loss of Life');
ylim([0 1]);

% Nuisance vs ML.
subplot(234);
semilogy(ML,NUISfxn(pgv/100,[0 0],2),'-b'); hold on;
for i=1:N
    semilogy(ML,NUISfxn(pgv/100,normrnd(0,1,[1 2]),2),'-','Color',GREY);
end
semilogy(ML,NUISfxn(pgv/100,[0 0],3),'-r');
for i=1:N
    semilogy(ML,NUISfxn(pgv/100,normrnd(0,1,[1 2]),3),'-','Color',GREY);
end
semilogy(ML,NUISfxn(pgv/100,[0 0],4),'-y');
for i=1:N
    semilogy(ML,NUISfxn(pgv/100,normrnd(0,1,[1 2]),4),'-','Color',GREY);
end
xlabel('Magnitude (M_L)'); ylabel('Nuisance Risk, Probability of Felt Ground Motion');
ylim([1e-2 1e0]); xlim([2.0 5.0]);

% Damage vs ML.
subplot(235);
semilogy(ML,FRAGfxn_cosmetic(pgv*10,0,1),'-k'); hold on;
for i=1:N
    semilogx(ML,FRAGfxn_cosmetic(pgv*10,abs(normrnd(0.0,0.15,[1 1])),1),'-','Color',GREY);
end
semilogy(ML,FRAGfxn_cosmetic(pgv*10,0,2),'-k');
for i=1:N
    semilogx(ML,FRAGfxn_cosmetic(pgv*10,abs(normrnd(0.0,0.15,[1 1])),2),'-','Color',GREY);
end
xlabel('Magnitude (M_L)'); ylabel('Damage Risk, Probability of Cosmetic Damage');
ylim([1e-4 1e0]); xlim([2.0 5.0]);

% LPR vs ML.
subplot(236);
semilogy(ML,VULNfxn_groningen(SAavg,0)*0.95,'-k'); hold on;
for i=1:N
    plot(ML,VULNfxn_groningen(SAavg,normrnd(0,1,[1 1]))*0.95,'-','Color',GREY);
end
xlabel('Magnitude (M_L)'); ylabel('Personal Risk, Probability of Loss of Life');
ylim([1e-7 1e0]); xlim([2.0 5.0]);




