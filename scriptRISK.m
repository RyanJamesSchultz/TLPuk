clear;

% Define input parameters.
Nv=1;
Nt=3000;
rand_flag='random';

% Load in data to start (or continue) doing iterations.
%load('blanks/TLP_uk.mat','S');
load('TLP_uktemp.mat','S');

% Iteratively add impact curves.
while(length(S.dVAR.dM)<Nt)
    
    % Prompt for percent done.
    100*length(S.dVAR.dM)/Nt
    
    % Create a perturbed data structure.
    S=perturbVAR(S,Nv,rand_flag);
    
    % Compute risk curves for each earthquake-grid pixel and perturbed value.
    tic; S=runRISK(S,rand_flag); toc;

    % Save data structure.
    save('TLP_uktemp.mat','S');
end






