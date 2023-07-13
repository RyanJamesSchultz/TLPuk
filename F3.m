clear;

% Load in the data structure: S.
load('TLP_uk.mat');

% Predefine some variables.
Nv=length(S.dVAR.b);
Nb=round(sqrt(Nv));

% Plot all perturbation data.
figure(3); clf;
subplot(2,5,1); histogram(S.dVAR.dZ, Nb );
xlabel('Depth Perturbation, dZ (km)'); ylabel('Count');
subplot(2,5,2); histogram(S.dVAR.b, Nb );
xlabel('b-value distribution, b (-)'); ylabel('Count');
subplot(2,5,3); histogram(S.dVAR.dM, Nb );
xlabel('Magnitude Perturbation, dM (M_W)'); ylabel('Count');
set(gca, 'YScale', 'log');
subplot(2,5,4); histogram(S.dVAR.dGMr, Nb );
xlabel('GMPE Perturbation, dGMr (-)'); ylabel('Count');
subplot(2,5,6); histogram(S.dVAR.dN1, Nb );
xlabel('Nuisance Fxn Perturbation, dN1 (-)'); ylabel('Count');
subplot(2,5,7); histogram(S.dVAR.dN2, Nb );
xlabel('Nuisance Fxn Perturbation, dN2 (-)'); ylabel('Count');
subplot(2,5,8); histogram(S.dVAR.Po, Nb );
xlabel('Damage Fxn Initial Damage State, \Psi_o (-)'); ylabel('Count');
subplot(2,5,9); histogram(S.dVAR.dLPR, Nb );
xlabel('LPR Vulnerability Fxn Perturbation, dLPRP (-)'); ylabel('Count');
subplot(2,5,5); histogram(S.dVAR.dSA, Nb );
xlabel('Site Amp Perturbation, dSA (-)'); ylabel('Count');
subplot(2,5,10); histogram(S.dVAR.dPOP, Nb );
xlabel('Population Perturbation Factor, dPOP (-)'); ylabel('Count');
