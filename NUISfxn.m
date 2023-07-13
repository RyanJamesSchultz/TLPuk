function P=NUISfxn(GM,dN,level_flag)
  % Computes the chance of observation for nuisance (PGV: m/s).
  %
  % References:
  % Schultz, Quitoriano, Wald, & Beroza (2020). Quantifying nuisance ground motion thresholds for induced earthquakes, Earthquake Spectra, doi: xx.
  %
  % Written by Ryan Schultz.
  
  % Schultz et al., 2020 (Table 1).
  if(level_flag==2) % Just felt.
      B=[11.2336 3.8771];
      dB=[+6.05e-1 +4.47e-2 +1.63e-1];
  elseif(level_flag==3) % Excitement.
      B=[ 5.9376 2.5875];
      dB=[+2.48e-1 +1.84e-2 +6.68e-2];
  elseif(level_flag==4) % Somewhat frightened.
      B=[ 3.4387 2.1331];
      dB=[+8.10e-2 +4.23e-3 +1.78e-2];
  elseif(level_flag==5) % Very frigthened.
      B=[ 2.3712 2.0828];
      dB=[+2.37e-2 +6.63e-4 +3.16e-3];
  elseif(level_flag==6) % Extremely frightened.
      B=[ 2.1427 2.1260];
      dB=[+2.12e-2 +5.18e-4 +2.42e-3];
  end
  
  % Perturb the coeffcients.
  B(1)=B(1)+dN(1)*sqrt(dB(1));
  B(2)=B(2)+dN(2)*sqrt(dB(2));
  B(2)=B(2)+dN(1)*(dB(3)/sqrt(dB(1)));
  
  % Compute the probabiltiies.
  P=1./(1+exp(-(B(1)+log10(GM)*B(2))));
    
return