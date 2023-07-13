function [Pm]=dM_probability(dM,b,Rs,flag,N)
  % Samples the magnitude-difference distribution of trailing seismicity.
  % 
  %  b       -- Gutenberg-Richter magnitude-frequency b-value.
  %  Rs      -- Population count ratio between number of stimulation earthquakes and the total.
  %  flag    -- Flag to determine a raw magnitude difference or for a red-light trailing scenario.
  %  SizeVec -- Size vector to contrain the dimensions of the dM sample.
  %  dM      -- Output magnitude difference (Mtrail-Mstim) vector.
  % 
  % References:
  % Schultz, R., Ellsworth, W.L., Beroza, G.C. (2022). Statistical bounds on how induced seismicity stops. Scientific Reports, 12(1), 1-11, doi: 10.1038/s41598-022-05216-9.
  % 
  % Written by Ryan Schultz.
  
  % Input flag to sample Rs from the emprically fitted beta distribution (Schultz et al., 2022).
  dM_sample=dM_distribution(b,Rs,flag,[1 N]);
  m=sort(dM_sample);
  p=(length(dM_sample):-1:1)/length(dM_sample);
  if(strcmpi(flag,'red+trail'))
      m=[0;m(:)];
      p=[1;p(:)];
  end
  
  % d.
  Pm=10.^interp1(m,log10(p),dM,'linear' );
  
return