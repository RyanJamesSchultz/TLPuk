function Y=GMSC(lat,lon,Y,dEa,T,GMSCflag)
  % Control function to manage GMSCs.  Returns PGV (cm/s) or 
  % PGA/PSA (cm/s²) as a function of the inputs.
  % All GMSCs are vectorized.
  % 
  % Written by Ryan Schultz.
  
  if(strcmpi(GMSCflag,'edw21'))
      Y=GMPEs.GMspatial_corr(lat,lon,Y,dEa,T);
  end
  
return