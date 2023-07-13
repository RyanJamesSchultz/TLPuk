function P=VULNfxn_pager(mmi,dE)
  % Computes the chance of loss of life for UK, based on PAGER.  Code is vecotrized.
  %
  % References:
  % Jaiswal, K.S., Wald, D.J., and Hearne, M., 2009, Estimating casualties for large earthquakes worldwide using an empirical approach: U.S Geological Survey Open-File Report, OF 2009-1136, 78 p.
  %
  % Written by Ryan Schultz.
  
  % Set vulnerabilty function parameters (Jaiswal et al., 2009; Apendix II-v1).
  %theta=log(18.63);
  %beta=0.24;
  %zeta=1.41;

  % Set vulnerabilty function parameters (Jaiswal et al., 2009; Apendix II-v2).
  %theta=log(20.062);
  %beta=0.257;
  %zeta=1.271;

  % Set vulnerabilty function parameters (Email w/ Kishor Jaiswal).
  theta=log(20.1);
  beta=0.26;
  zeta=1.43;

  % Compute the probabiltiies.
  P=logncdf(mmi,theta,beta);
  
  % Perturb the probabiltiies.
  P=log(P)+dE*zeta;
  P=exp(P);
  
return