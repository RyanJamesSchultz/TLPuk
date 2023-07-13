function [ ML ] = Mw2ML(Mw)
  % Computes the ML given an Mw, based on Edwards et al. (2015).
  %
  % Reference:
  % Edwards, Crowley, Pinho, & Bommer, (2021). Seismic hazard and risk due to induced earthquakes at a shale gas site. BSSA, 111(2), 875-897, doi: 10.1785/0120200234.
  % 
  % Written by Ryan Schultz.
  
  % Predfine the translation.
  MLt=[-4.0:0.01:1.5,2.5:0.01:10.0];
  I=(MLt<=1.5); Mwt(I)=MLt(I)*2/3+0.833;
  I=(MLt>=2.5); Mwt(I)=0.0376*MLt(I).^2+0.646*MLt(I)+0.53;
  
  % Interpolate to the user-specified Mw values.
  ML=interp1(Mwt,MLt,Mw,'linear');
  
return