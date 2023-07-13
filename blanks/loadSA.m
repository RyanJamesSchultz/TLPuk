function S=loadSA(S,filenameD,filenameE)
  % Simple function that loads in site amplification data for the entire map area.
  
  % Load in the grid file for Vs30 (m/s).
  [lonD,latD,vs30 ]=grdread2(filenameD);
  [lonE,latE,dvs30]=grdread2(filenameE);
  
  % Make matrices of map grids.
  [LON,LAT]=meshgrid(S.MAP.lonG,S.MAP.latG);
  
  % Interpolate Vs30 to the datagrid.
  vs30= interp2(lonD,latD,vs30, LON,LAT,'linear');
  dvs30=interp2(lonE,latE,dvs30,LON,LAT,'linear');
  
  % Stuff SA into output structure.
  S.MAP.Vs30 = vs30;
  S.MAP.dVs30=dvs30;
  
return