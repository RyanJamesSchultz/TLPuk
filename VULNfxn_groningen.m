function P=VULNfxn_groningen(SAavg,dE)
  % Computes the chance of loss of life (SAavg: g) for Groningen.  Code is vecotrized.
  %
  % References:
  % Crowley, H., & Pinho, R. (2020). Report on the Fragility and Consequence Models for the Groningen Field (Version 7). NAM Report, p. 83.
  %
  % Written by Ryan Schultz.
  
  % Set coefficients (Crowley & Pinho, 2020; Figure 7.4, Page 52, PDF64).
  u=[1.4232, 0.63995];
  if(dE>0)
      du1=0.4863/2;
      du2=0.0159/2;
  else
      du1=0.4966/2;
      du2=0.0720/2;
  end
  SAavg=SAavg/0.65;
  
  % Perturb the coeffcients.
  u(1)=u(1)+dE*du1;
  u(2)=u(2)+dE*du2;
  
  % Compute the probabiltiies.
  P=normcdf(log(SAavg), log(u(1)), u(2));
  
  % Truncate?
  %P(SAavg<0.05)=0;
  
return