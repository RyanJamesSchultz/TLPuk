function [ gm ] = GMspatial_corr(lat,lon,gm,dEa,T)
  % Computes the spatially correlated ground motion for a single event.
  % Code is vectorized.  
  % 
  % References:
  % Edwards, Crowley, Pinho, & Bommer (2021). Seismic hazard and risk due to induced earthquakes at a shale gas site. BSSA, 111(2), 875-897, doi: 10.1785/0120200234.
  % Esposito, & Iervolino (2011). PGA and PGV spatial correlation models based on European multievent datasets. BSSA, 101(5), 2532-2541, doi: 10.1785/0120110117.
  % Esposito, & Iervolino (2012). Spatial correlation of spectral acceleration in European data. BSSA, 102(6), 2781-2788, doi: 10.1785/0120120068.
  % Jayaram, & Baker (2010). Considering spatial correlation in mixed-effects regression and the impact on ground-motion models. BSSA, 100(6), 3295-3303, doi: 10.1785/0120090366.
  %  
  % Written by Ryan Schultz.
  
  % Make everything a column vector.
  lat=lat(:);
  lon=lon(:);
  gm=gm(:);
  dEa=dEa(:);
  n=length(lat);
  
  % Define the range coefficients (Esposito & Iervolino, 2012; Table 1 & Eqn 9).
  if(T==-1)
      b=13.7;
  else
      b=11.7+12.7*T; % ESD dataset.
      %b= 8.6+11.7*T; % ITACA dataset.
  end
  
  % Define the site-to-site intraevent error term (Edwards et al., 2021).
  S_table=[0.21775 0.25691 0.28609 0.20792 0.2234 0.2058 0.2207 0.20486 0.20473 0.23163];
  T_table=[-1 0 0.03 0.05 0.1 0.2 0.3 0.5 1.0 2.0];
  Sintra=interp1(T_table,S_table,T,'linear');
  
  % Move to a logarithmic scale.
  gm=log(gm);
  
  % Compute the site-to-site distance matrix.
  h=zeros([n n]);
  for i=1:n
      ht=Geoid_Distance(lat(i:end),lon(i:end),lat(i),lon(i),'spherical')*6371*pi()/180;
      h(i:end,i)=ht;
      h(i,i:end)=ht';
  end
  
  % Compute the site-to-site correlation matrix and covariance matrix (Esposito & Iervolino, 2012; Eqn 2 & near 9).
  %p=c0+ce*(1-exp(-3*h/b)); % Eqn 6.
  p=exp(-3*h/b); % near Eqn 9.
  SIGMA=p; % Eqn 2.
  SIGMA(1:(n+1):end)=1; 
  %SIGMA=eye(size(SIGMA));
  
  % Do Cholesky Decomposition, such that SIGMA=L*L'.
  L=chol(SIGMA,'lower');
  
  % Compute the spatially-correlated ground motion.
  gm=gm+(Sintra*L*dEa);
  
  % Convert to a non-logarithmic scale.
  gm=exp(gm);
  
return