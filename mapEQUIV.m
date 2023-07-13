function [En2,En3,En4,Ed1,Ed2,Er1]=mapEQUIV(M,S)
  % Make equivalent risk maps.
  
  % Set the interpolation type.
  interp_type='linear';
  
  % Predefine variables.
  En2=NaN*zeros(size(S.MAP.DEP));
  En3=En2; En4=En2; Ed1=En2; Ed2=En2; Er1=En2; 
  
  % Predefine some important varaibles.
  [LON,LAT]=meshgrid(S.MAP.lonE,S.MAP.latE);
  J=find(S.MAP.Ir);
  Mw=S.Mw;
  
  % Loop over all of the (in-bounds) EQ grid.
  for j=1:length(S.RISK)
      
      % Get the risk curves.
      N_n2=S.RISK(j).Nn2; N_n2(isnan(N_n2))=0;
      N_n3=S.RISK(j).Nn3; N_n3(isnan(N_n3))=0;
      N_n4=S.RISK(j).Nn4; N_n4(isnan(N_n4))=0;
      N_d1=S.RISK(j).Nd1; N_d1(isnan(N_d1))=0;
      N_d2=S.RISK(j).Nd2; N_d2(isnan(N_d2))=0;
      N_r1=S.RISK(j).Pf1; N_r1(isnan(N_r1))=0;

      % Get the median risk curves.
      N_n2=median(N_n2);
      N_n3=median(N_n3);
      N_n4=median(N_n4);
      N_d1=median(N_d1);
      N_d2=median(N_d2);
      N_r1=median(N_r1);
      
      % Dealing with non-monotonic and non-unique inputs.
      dx=cumsum(ones(size(Mw)));
      N_n2=N_n2+dx.*N_n2/(100*length(Mw))+dx*eps;
      N_n3=N_n3+dx.*N_n3/(100*length(Mw))+dx*eps;
      N_n4=N_n4+dx.*N_n4/(100*length(Mw))+dx*eps;
      N_d1=N_d1+dx.*N_d1/(100*length(Mw))+dx*eps;
      N_d2=N_d2+dx.*N_d2/(100*length(Mw))+dx*eps;
      N_r1=N_r1+dx.*N_r1/(100*length(Mw))+dx*eps;
      
      % Get the red-light magnitude.
      Mj=interp2(M.N.N2.lon,M.N.N2.lat,M.Mcomb,LON(J(j)),LAT(J(j)),interp_type);

      % Find intersecting values.
      En2(J(j))=interp1(Mw,N_n2,Mj,interp_type,'extrap');
      En3(J(j))=interp1(Mw,N_n3,Mj,interp_type,'extrap');
      En4(J(j))=interp1(Mw,N_n4,Mj,interp_type,'extrap');
      Ed1(J(j))=interp1(Mw,N_d1,Mj,interp_type,'extrap');
      Ed2(J(j))=interp1(Mw,N_d2,Mj,interp_type,'extrap');
      Er1(J(j))=interp1(Mw,N_r1,Mj,interp_type,'extrap');
      
  end

  % Scale up the resolution.
  [LONh,LATh]=meshgrid(M.N.N2.lon,M.N.N2.lat);
  En2=scatteredInterpolant(LON(J),LAT(J),En2(J),'natural','linear'); En2=En2(LONh,LATh);
  En3=scatteredInterpolant(LON(J),LAT(J),En3(J),'natural','linear'); En3=En3(LONh,LATh);
  En4=scatteredInterpolant(LON(J),LAT(J),En4(J),'natural','linear'); En4=En4(LONh,LATh);
  Ed1=scatteredInterpolant(LON(J),LAT(J),Ed1(J),'natural','linear'); Ed1=Ed1(LONh,LATh);
  Ed2=scatteredInterpolant(LON(J),LAT(J),Ed2(J),'natural','linear'); Ed2=Ed2(LONh,LATh);
  Er1=scatteredInterpolant(LON(J),LAT(J),Er1(J),'natural','linear'); Er1=Er1(LONh,LATh);
  %En2=interp2(LON,LAT,En2,LONh,LATh,interp_type);
  %En3=interp2(LON,LAT,En3,LONh,LATh,interp_type);
  %En4=interp2(LON,LAT,En4,LONh,LATh,interp_type);
  %Ed1=interp2(LON,LAT,Ed1,LONh,LATh,interp_type);
  %Ed2=interp2(LON,LAT,Ed2,LONh,LATh,interp_type);
  %Er1=interp2(LON,LAT,Er1,LONh,LATh,interp_type);
  I=inpolygon(LONh,LATh,S.MAP.lonB,S.MAP.latB);
  En2(~I)=NaN;
  En3(~I)=NaN;
  En4(~I)=NaN;
  Ed1(~I)=NaN;
  Ed2(~I)=NaN;
  Er1(~I)=NaN;
  
return