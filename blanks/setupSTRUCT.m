function S=setupSTRUCT(PLAYflag,latMAP,lonMAP,latEQ,lonEQ,latBOUN,lonBOUN,Mw,ReMAXn,ReMAXd,NpeopleHome,PSAf)
  % Simple function that defines the TLP risk-map data structure.
  
  % Top level structure defintion.
  S=struct('play_flag',[],'MAP',[],'dVAR',[],'RISK',[],'ML',[],'Mw',[],'PSAf',[]);
  
  % Convert from Mw to ML.
  ML=Mw2ML(Mw);
  
  % Spectral periods of interest for the loss of life prediction.
  T=[0.01,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.85,1.0];

  % Put information in the main structure, S.
  S.Mw=Mw;
  S.ML=ML;
  S.T=T;
  S.PSAf=PSAf;
  S.play_flag=PLAYflag;
  S.Nph=NpeopleHome;
  
  % Second level structure definitions.
  MAP=struct('latG',[],'lonG',[],'Vs30',[],'dVs30',[],'POP',[],'DEP',[],'latE',[],'lonE',[],'latB',[],'lonB',[],'Ir',[]);
  dVAR=struct('dM',[],'b',[],'dGMr',[],'dGMa',[],'dN1',[],'dN2',[],'Po',[],'dLPR',[],'dSA',[],'dPOP',[],'dZ',[],'UPDATEflag',[]);
  RISK=struct('lat',[],'lon',[],'Nn2',[],'Nn3',[],'Nn4',[],'Nn5',[],'Nn6',[],'Nd1',[],'Nd2',[],'LPR',[]);
  
  % Put information in the MAP structure.
  MAP.latG=latMAP;
  MAP.lonG=lonMAP;
  MAP.latE=latEQ;
  MAP.lonE=lonEQ;
  MAP.latB=latBOUN;
  MAP.lonB=lonBOUN;
  MAP.ReN_max=ReMAXn;
  MAP.ReD_max=ReMAXd;
  
  % Find the map lats/longs that are within the play boundary.
  LAT=repmat(latEQ',1,length(lonEQ));
  LON=repmat(lonEQ,length(latEQ),1);
  MAP.Ir=inpolygon(LON,LAT,lonBOUN,latBOUN);
  
  % Make a list of those lat/longs
  lat=LAT(MAP.Ir); lat=lat(:);
  lon=LON(MAP.Ir); lon=lon(:);
  
  % Loop over all in-play coords, and stuff into risk structure.
  for i=1:length(lat)
      RISK(i).lat=lat(i);
      RISK(i).lon=lon(i);
  end
  
  % Stuff second level structures into S.
  S.MAP=MAP;
  S.dVAR=dVAR;
  S.RISK=RISK;
  
return