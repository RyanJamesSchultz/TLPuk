function [R1,R2]=POPvT(Yi,Ya)
  % Simple function that gives the population ratio in the Netherlands/Groningen.
  
  % Load in the UK population dataset (https://countrymeters.info/en/United_Kingdom_(UK)).
  data=load('/Users/rschultz/Desktop/TLPuk/data/POPvT/UK1.csv');
  Y1=data(:,1);
  P1=data(:,2);
  
  % Load in the UK population dataset (https://www.worldometers.info/world-population/uk-population/).
  data=load('/Users/rschultz/Desktop/TLPuk/data/POPvT/UK2.csv');
  Y2=data(:,1);
  P2=data(:,2);
  
  % Compute ratios.
  R1=interp1(Y1,P1,Yi,'linear')./interp1(Y1,P1,Ya,'linear');
  R2=interp1(Y2,P2,Yi,'linear')./interp1(Y2,P2,Ya,'linear');
  
return