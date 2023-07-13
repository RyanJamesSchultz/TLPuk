function [ Y ] = GMPEcwb19(Re,M,dep,Vs30,dE,sigmatype, T)
  % Computes the PGV (cm/s) & PGA/PSA (cm/s²) as a fxn of the inputs.
  % Based on Gemma's work for HF-IS GMPEs in the UK (Cremen et al., 2019).
  % Code is vectorized.  Allows linear interpolation between coefficients.
  % 
  % References:
  % Douglas, Edwards, Convertito, Sharma, Tramelli, Kraaijpoel, ... & Troise (2013). Predicting ground motion from induced earthquakes in geothermal areas. BSSA, 103(3), 1875-1897, doi: 10.1785/0120120197.
  % Boore, Stewart, Seyhan, & Atkinson (2014). NGA-West2 equations for predicting PGA, PGV, and 5% damped PSA for shallow crustal earthquakes. Earthquake Spectra, 30(3), 1057-1085, doi: 10.1193/070113EQS184M.
  % Cremen, Werner, & Baptie (2020). A new procedure for evaluating ground‐motion models, with application to hydraulic‐fracture‐induced seismicity in the United Kingdom. BSSA, 110(5), 2380-2397, doi: 10.1785/0120190238.
  % 
  % Written by Ryan Schultz.
  
  % Get the hypocentral distance.
  Rhyp=sqrt(Re.^2+dep.^2);
  
  % Define Gemmas's C19 coefficients (Table 3).
  %         a     b      c h      d   phi   tau sigma
  cE=[-10.213 2.913 -2.719 0 -0.046 0.553 0.158 0.575;...
       -5.096 2.146 -2.611 0 -0.023 0.563 0.437 0.712;...
       -5.027 2.717 -2.890 0 -0.008 0.696 0.378 0.792;...
       -4.988 2.814 -2.723 0 -0.039 0.632 0.227 0.672;...
       -7.704 3.639 -2.276 0 -0.057 0.549 0.430 0.698];
  Tc=[-1 0 0.05 0.1 0.2];
  if(T==-1)
      index=1; % PGV.
      a=cE(index,1);
      b=cE(index,2);
      c=cE(index,3);
      d=cE(index,5);
      phi=cE(index,6);
      tau=cE(index,7);
      sig=cE(index,8);
  elseif(T==0)
      index=2; % PGA.
      a=cE(index,1);
      b=cE(index,2);
      c=cE(index,3);
      d=cE(index,5);
      phi=cE(index,6);
      tau=cE(index,7);
      sig=cE(index,8);
  else
      % PSA.
      a=interp1(Tc,cE(:,1),T,'linear');
      b=interp1(Tc,cE(:,2),T,'linear');
      c=interp1(Tc,cE(:,3),T,'linear');
      d=interp1(Tc,cE(:,5),T,'linear');
      phi=interp1(Tc,cE(:,6),T,'linear');
      tau=interp1(Tc,cE(:,7),T,'linear');
      sig=interp1(Tc,cE(:,8),T,'linear');
  end
  h=0;
  
  % Compute the ground motions (Eqn 11).
  Y=a+b*M+c*log(sqrt(Rhyp.^2+h.^2))+d*Rhyp+log(100);
  if(T==0)
      Y2=Y;
  else
      index=2;
      a=cE(index,1);
      b=cE(index,2);
      c=cE(index,3);
      d=cE(index,5);
      phi=cE(index,6);
      tau=cE(index,7);
      sig=cE(index,8);
      Y2=a+b*M+c*log(sqrt(Rhyp.^2+h.^2))+d*Rhyp+log(100);
  end
  
  % Compute the site amplification term (Boore et al., 2014).
  site=GMPEs.SAbo14(Vs30,exp(Y2)/980.665,T);
  
  % Add (or subtract) error, if requested to.
  if(strcmp(sigmatype,'total'))
      Y=site+Y+sig*dE;
  elseif(strcmp(sigmatype,'inter'))   
      Y=site+Y+tau*dE;
  elseif(strcmp(sigmatype,'intra'))   
      Y=site+Y+phi*dE;
  end
  
  % Convert to non-logarithmic scale.
  Y=exp(Y);
  
return