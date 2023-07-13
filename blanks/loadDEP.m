function S=loadDEP(S)
  % Simple function that loads in formation depth data for the map-bounded area.
  
  % Get the correct file names, depending on formation flagged for.
  filenameBS='/Users/rschultz/Desktop/TLPuk/data/Depths/BS/topbhu_meters1.nc';
  filenameWB='/Users/rschultz/Desktop/TLPuk/data/Depths/WB/TopKimClayMeters1.nc';
  filenameMV='/Users/rschultz/Desktop/TLPuk/data/Depths/MVB/BaseLimestoneCoalM.nc';
  filenameTOPO='/Users/rschultz/Desktop/old/TLP/nuisance/GMT/ETOPO1_Ice_g_gmt4.grd';
  
  % Elevation of the Bowland Shale (km).
  lonFbs=ncread(filenameBS,'x');
  latFbs=ncread(filenameBS,'y');
  Faslbs=-ncread(filenameBS,'z')'/1000;
  
  % Elevation of the Weald Basin (km).
  lonFwb=ncread(filenameWB,'lon');
  latFwb=ncread(filenameWB,'lat');
  Faslwb=-ncread(filenameWB,'z')'/1000;
  
  % Elevation of the Midland Valley Basin (km).
  lonFmv=ncread(filenameMV,'lon');
  latFmv=ncread(filenameMV,'lat');
  Faslmv=-ncread(filenameMV,'z')'/1000;
  
  % Collapse to list of non-NaN values.
  [LONFbs,LATFbs]=meshgrid(lonFbs,latFbs);
  [LONFwb,LATFwb]=meshgrid(lonFwb,latFwb);
  [LONFmv,LATFmv]=meshgrid(lonFmv,latFmv);
  LONFbs=LONFbs(~isnan(Faslbs)); LONFwb=LONFwb(~isnan(Faslwb)); LONFmv=LONFmv(~isnan(Faslmv)); LONF=[LONFbs(:); LONFwb(:); LONFmv(:)];
  LATFbs=LATFbs(~isnan(Faslbs)); LATFwb=LATFwb(~isnan(Faslwb)); LATFmv=LATFmv(~isnan(Faslmv)); LATF=[LATFbs(:); LATFwb(:); LATFmv(:)];
  FASLbs=Faslbs(~isnan(Faslbs)); FASLwb=Faslwb(~isnan(Faslwb)); FASLmv=Faslmv(~isnan(Faslmv)); FASL=[FASLbs(:); FASLwb(:); FASLmv(:)];
  
  % Add some BS datapoints.
  LATF=[LATF; 54.1;  54.0; 53.4; 52.8; 54.0; 54.15; 54.2; 54.45; 54.5; 54.5 ];
  LONF=[LONF; -2.9;  -3.2; -3.3; -2.8;  0.0;   0.0; -0.1; -0.20; -0.4; -0.9 ];
  FASL=[FASL; -0.8;  -1.5; -1.8; -2.6; -3.5;  -3.1; -2.4; -2.40; -2.7; -1.15 ];
  % Add some WB datapoints.
  LATF=[LATF; 50.70; 50.70; 50.90; 50.95; 51.05; 51.10 ];
  LONF=[LONF; +0.60; +0.70; +1.00; +1.00; +1.00; +1.00 ];
  FASL=[FASL; -0.28; -0.29; -0.52; -0.52; -0.52; -0.44 ];
  % Add some MVB datapoints.
  LATF=[LATF; 55.70; 56.00; 56.20; 56.40; 56.40; 56.00; 55.70 ];
  LONF=[LONF; -4.40; -4.40; -4.00; -3.20; -2.60; -2.00; -3.00 ];
  FASL=[FASL; +0.00; +0.00; -0.20; +0.10; +0.00; +0.00; +0.00 ];
  
  % Read in topography data (km).
  [lonT,latT,Tasl]=grdread2(filenameTOPO);
  Tasl=double(Tasl)/1000;
  
  % Inpterpolate depths to a regular grid.
  [LON,LAT]=meshgrid(S.MAP.lonE,S.MAP.latE);
  F_ASL=griddata(LONF,LATF,FASL,LON,LAT,'linear');
  T_ASL=interp2( lonT,latT,Tasl,LON,LAT,'linear');
  
  % Compute TVD of the Formation.
  F_TVD=T_ASL-F_ASL;
  F_TVD(F_TVD<0)=0;
  
  % Stuff data into output structure.
  S.MAP.DEP=F_TVD;
  
return