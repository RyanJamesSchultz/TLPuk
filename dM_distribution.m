function [dM,Rs]=dM_distribution(b,Rs,flag,SizeVec)
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
  if(Rs<0)
      Rs=betarnd(0.940,0.238,SizeVec);
  end
  
  % Sample differently based on user-flagged choice.
  if(strcmpi(flag,'full'))
      
      % Sample the magnitude-differences (Schultz et al., 2022).
      Rts=(1./Rs)-1;
      q1=rand(SizeVec);
      q2=rand(SizeVec);
      dM=log10(Rts)./b+log10(log(q2)./log(q1))./b; % Eqn. 5.
  elseif(strcmpi(flag,'red+trail'))
      
      % Sample the magnitudes causing a red-light and trailing shut-in (Schultz et al., 2022).
      Rts=(1./Rs)-1;
      Ns=1;
      Nt=Rts*Ns;
      qs=rand(SizeVec).*(1-exp(-1))+exp(-1);
      qt=rand(SizeVec);
      Ms=log10(Ns)./b-log10(-log(qs))./b; % Eqn. 4.
      Mt=log10(Nt)./b-log10(-log(qt))./b; % Eqn. 4.
      dM=max(Ms,Mt);
  end
  
return