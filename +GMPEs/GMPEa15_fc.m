function Y=GMPEa15_fc(Re,M,dep,Vs30,dE,flag)
  % Computes the PGV (cm/s) & PGA (cm/s^2) as a fxn of the inputs.  Code 
  % is vectorized.  Based on the ShakeMap GMPE in SPE104, calibrating A15 
  % for Fox Creek (Schultz & Nanometrics, 2019).
  %
  % References:
  % 
  % Schultz, & Nanometrics (2019). Initial seismic hazard assessment for the 2016 induced earthquakes near Fox Creek, Alberta (between January 2013 and January 2016). AER/AGS Special Report 104, 115 p.
  %
  % Written by Ryan Schultz.
  
  % Define constants (ShakeMap, Table 2).
  if(strcmpi(flag,'PGV'))
      c0=-4.151;
      dc0=0.00;
      c1=1.762;
      c2=-0.09509;
      c3=-1.669;
      dc3=1.582;
      ea=0.27;
      ei=0.19;
      et=0.33;
      
      c=0.18;
      Vc=515.9;
      Vr=760;
  elseif(strcmpi(flag,'PGA'))
      c0=-2.376;
      dc0=-0.212;
      c1=1.818;
      c2=-0.1153;
      c3=-1.752;
      dc3=1.992;
      ea=0.28;
      ei=0.24;
      et=0.37;
      
      c=-0.22;
      Vc=638.08;
      Vr=760;
  else
      return
  end
  
  % Compute effective hypocentre.
  Rh=sqrt(dep.^2+Re.^2);
  heff=max(ones(size(M)),10.^(-1.72+0.43.*M));
  R=sqrt(Rh.^2+heff.^2);
  
  % Compute GMPE for close distances.
  Y=(c0+dc0)+(c1.*M)+(c2.*M.^2)+c3.*log10(R);
  
  % Modify GMPE values for mid range distances.
  I=(R>=70)&(R<140);
  Y(I)=Y(I)+dc3.*log10(R(I)./70);
  
  % Modify GMPE values for long range distances.
  I=(R>=140);
  Y(I)=Y(I)+dc3.*log10(140./70);
  
  % Add site amplificaiton effects.
  Fs=zeros(size(Vs30));
  I=Vs30 < Vc;
  Fs(I) = c * log(Vs30(I)/Vc) - c * log(Vr/Vc);
  Y=Y+Fs;
  
  % Add (or subtract) error, if requested to.
  Y=Y+ea.*dE;
  
  % Convert to non-logarithmic scale.
  Y=10.^Y;
  
return;