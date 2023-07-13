function mmi=pgm2mmi(pgm,flag)
  % Computes the MMI given an input PGA (cm/s2) or PGV (cm/s).  Code is vecotrized.
  %
  % References:
  % Caprio, M., Tarigan, B., Worden, C. B., Wiemer, S., & Wald, D. J. (2015). Ground motion to intensity conversion equations (GMICEs): A global relationship and evaluation of regional dependency. Bulletin of the Seismological Society of America, 105(3), 1476-1490.
  %
  % Written by Ryan Schultz.
  
  % Set the parameters (Caprio et al., 2015; Eqn 1 & Table 2).
  if(strcmpi(flag,'PGA'))
      a1=2.270; b1=1.647; a2=-1.361; b2=3.822; tPGM=1.6;
  else
      a1=4.424; b1=1.589; a2=4.018;  b2=2.671; tPGM=0.3;
  end
  
  % Convert from ground shaking (PGM) to intensity (MMI).
  mmi=a1+b1*log10(pgm);
  I=log10(pgm)>tPGM;
  mmi(I)=a2+b2*log10(pgm(I));
  
return