function Y=GMPEmk17(Re,M,dep,Vs30,dE,flag)
  % Computes the PGV (cm/s) & PGA (cm/s^2) as a fxn of the inputs.  Code is vectorized.
  % Uses the coeficients from Mahani & Kao 2017, from Table 2.
  %
  % Reference:
  % Mahani & Kao (2017). Ground motion from M 1.5 to 3.8 induced earthquakes at hypocentral distance< 45 km in the Montney play of northeast British Columbia, Canada. 
  % SRL, 89(1), 22-34, doi: 10.1785/0220170119.
  %
  % Written by Ryan Schultz.
  
  % Define constants (Table 2).
  if(strcmpi(flag,'PGV'))
      c0=-2.94;
      c1=1.03;
      b=-2.07;
      ea=0.30;
      ei=0.21;
      et=0.37;
      
      c=0.18;
      Vc=515.9;
      Vr=760;
  elseif(strcmpi(flag,'PGA'))
      c0=-0.78;
      c1=0.88;
      b=-2.12;
      ea=0.31;
      ei=0.27;
      et=0.41;
      
      c=-0.22;
      Vc=638.08;
      Vr=760;
  else
      return
  end
  
  % Compute the hypocentre.
  R=sqrt(dep.^2+Re.^2);
  
  % Compute the GMPE values (Eqn 4).
  Y=(c0)+(c1.*M)+b.*log10(R);
  
  % Add site amplificaiton effects.
  Fs=zeros(size(Vs30));
  I=Vs30 < Vc;
  Fs(I) = c * log(Vs30(I)/Vc) - c * log(Vr/Vc);
  Y=Y+Fs;
  
  % Add (or subtract) error, if requested to (Eqn 3).
  Y=Y+et.*dE;
  
  % Convert to non-logarithmic scale.
  Y=10.^Y;
  
return;