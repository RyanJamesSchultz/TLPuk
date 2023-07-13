function Y=GMPEa15(Re,M,dep,Vs30,dE,flag)
  % Computes the PGV (cm/s) & PGA (cm/s^2) as a fxn of the inputs.  Code is vectorized.
  % Based on Gail's work for IS GMPEs (Atkinson, 2015), Table 2.
  % 
  % Reference:
  % Atkinson, G. M. (2015). Ground-motion prediction equation for small-to-moderate events at short hypocentral distances, with application to induced-seismicity hazards. 
  % BSSA, 105(2A), 981-992, doi: 10.1785/0120140142.
  % 
  % Written by Ryan Schultz.
  
  % Define constants (Table 2).
  if(strcmpi(flag,'PGV'))
      c0=-4.151;
      c1=1.762;
      c2=-0.09509;
      c3=-1.669;
      c4=-0.0006;
      ea=0.27;
      ei=0.19;
      et=0.33;
      
      c=0.18;
      Vc=515.9;
      Vr=760;
  elseif(strcmpi(flag,'PGA'))
      c0=-2.376;
      c1=1.818;
      c2=-0.1153;
      c3=-1.752;
      c4=-0.002;
      ea=0.28;
      ei=0.24;
      et=0.37;
      
      c=-0.22;
      Vc=638.08;
      Vr=760;
  else
      return
  end
  
  % Compute effective hypocentre (Eqns 2 & 3).
  Rh=sqrt(dep.^2+Re.^2);
  heff=max(ones(size(M)),10.^(-1.72+0.43.*M));
  R=sqrt(Rh.^2+heff.^2);
  
  % Compute GMPE (Eqns 1 & 4).
  Y=(c0)+(c1.*M)+(c2.*M.^2)+c3.*log10(R)+c4.*R;
  
  % Add site amplificaiton effects.
  Fs=zeros(size(Vs30));
  I=Vs30 < Vc;
  Fs(I) = c * log(Vs30(I)/Vc) - c * log(Vr/Vc);
  Y=Y+Fs;
  
  % Add (or subtract) error, if requested to.
  Y=Y+et.*dE;
  
  % Convert to non-logarithmic scale.
  Y=10.^Y;
  
return;