function Y=GMPEdg13(Re,M,dep,Vs30,dE,flag)
  % Computes the PGV (cm/s) & PGA (cm/s^2) as a fxn of the inputs.  Code is vectorized.
  % Based on Douglas et al (2013) for geothermal areas, Table 2 (Model 1).
  %
  % Reference:
  % Douglas et al., (2013). Predicting ground motion from induced earthquakes in geothermal areas. 
  % BSSA, 103(3), 1875-1897, doi: 10.1785/0120120197.
  %
  % Written by Ryan Schultz.
  
  % Define constants (Table 2).
  if(strcmpi(flag,'PGV'))
      a=-9.999;
      b=1.964;
      c=-1.405;
      h=2.933;
      d=-0.035;
      ei=1.029;
      ea=1.553;
      et=1.863;
  elseif(strcmpi(flag,'PGA'))
      a=-12.736;
      b=3.056;
      c=-0.675;
      h=1.218;
      d=-0.050;
      ei=0.572;
      ea=0.698;
      et=0.903;
  else
      return
  end
  
  % Compute effective hypocentre.
  Rh=sqrt(dep.^2+Re.^2);
  Reff=sqrt(Rh.^2+h.^2);
  
  % Compute GMPE (Eqn 1).
  Y=a+b.*M+c.*log(Reff)+d.*Rh;
  
  % Add site amplificaiton effects.
  Fs=zeros(size(Vs30));
  I=Vs30 < Vc;
  Fs(I) = c * log(Vs30(I)/Vc);
  Y=Y+Fs;
  
  % Add (or subtract) error, if requested to.
  Y=Y+et.*dE;
  
  % Convert to non-logarithmic scale (and scale m to cm).
  Y=exp(Y)*100;
  
return;