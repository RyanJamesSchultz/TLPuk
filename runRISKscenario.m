function S=runRISKscenario(S,lat,lon,dep,M,dGM,Np,y,yn)
  % Compute the risk curves for one scenario.

  % Predefine a flag.
  rand_flag='scenario';

  % Overwrite values in risk structure to just the ones of interest.
  S.Mw=M;
  S.ML=M;
  S.RISK(1).lat=lat;
  S.RISK(1).lon=lon;
  S.MAP.DEP=dep*ones(size(S.MAP.DEP));
  S.MAP.Ir=true;
  S.RISK(2:end)=[];
  
  % Perturb data structure and compute risk curves.
  S=perturbVAR(S,Np,rand_flag,dGM);
  S=runRISK(S,rand_flag);
  
  % Normalize based on the changing population of the Groningen.
  [~,R]=POPvT(y,yn);
  S.RISK.Nn2=S.RISK.Nn2*R;
  S.RISK.Nn3=S.RISK.Nn3*R;
  S.RISK.Nn4=S.RISK.Nn4*R;
  S.RISK.Nn5=S.RISK.Nn5*R;
  S.RISK.Nn6=S.RISK.Nn6*R;
  S.RISK.Nd1=S.RISK.Nd1*R;
  S.RISK.Nd2=S.RISK.Nd2*R;
  
return
