function Y=GMPEbg21(Re,M,dep,Vs30,dE,flag)
  % Computes the PGV (cm/s) as a fxn of the inputs.  Code is vectorized.
  % Based on Julian Bommer's work for Groningen IS GMPEs (Bommer et al., 2021), Section 3.
  % Specfically, this is using the PGVlarger metric.
  %
  % Reference:
  % Bommer, J. J., Stafford, P. J., & Ntinalexis, M. (2021). Empirical equations for the prediction of Peak Ground Velocity due to induced earthquakes in the Groningen Gas Field – October 2021.
  % NAM Report, p. 44.
  %
  % Written by Ryan Schultz.
  
  % Define constants (Table 3.1).
  if(strcmpi(flag,'PGV'))
      c1=-3.3996;
      c2=+2.3258;
      c3=-2.8522;
      c4=-1.0151;
      c5=-2.1002;
      c6=-3.4407;
      c7=+1.1513;
      c8=-0.3295;
      ea=0.4569;
      ei=0.2448;
      et=0.5715;
      
      Vr=200;
  
  else
      return
  end
  
  % Compute effective hypocentre (Eqns 3.2 & 3.3).
  Rh=sqrt(dep.^2+Re.^2);
  heff=exp(c6+c7*M);
  R=sqrt(Rh.^2+heff.^2);
  
  % Compute geometric spreading term (Eqns 3.4a-3.4c).
  gR=c3*log(R);
  I=(R>7);
  gR(I)=c3*log(7)+c4*log(R(I)/7);
  I=(R>12);
  gR(I)=c3*log(7)+c4*log(12/7)+c5*log(R(I)/12);
  
  % Compute GMPE (Eqn 3.1).
  Y=(c1)+(c2*M)+(gR)+(c8*log(Vs30/Vr));
  
  % Add (or subtract) error, if requested to.
  Y=Y+et.*dE;
  
  % Convert to non-logarithmic scale.
  Y=exp(Y);
  
return;