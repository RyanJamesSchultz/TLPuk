function SAavg=AvgSA(T,PSA,T1,flag)
  % Computes the geometric mean of PSA over a given period interval.
  % 
  % References:
  % Eads, L., Miranda, E., & Lignos, D. G. (2015). Average spectral acceleration as an intensity measure for collapse risk assessment. Earthquake Engineering & Structural Dynamics, 44(12), 2057-2073, doi: 10.1002/eqe.2575.
  % Crowley, H., & Pinho, R. (2020). Report on the Fragility and Consequence Models for the Groningen Field (Version 7). NAM Report, p. 83.
  % 
  % Written by Ryan Schultz.
  
  % Get the interval of interest.
  if(strcmpi(flag,'Eads'))
      Ti=0.2*T1:0.01:3*T1; % Eads et al., 2015 (Page 2059, PDF3).
  elseif(strcmpi(flag,'NL'))
      Ti=[0.01,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.85,1.0]; % Crowley & Pinho, 2020 (Figure 4.1; Page 26, PDF38).
  end
  
  % Get the PSA over the interval of interest.
  PSAi=interp1(T,PSA,Ti,'linear');
  
  % Get the geometric mean over the PSA interval (Eads et al., 2015; Equation 3).
  SAavg=geomean(PSAi);
  
return