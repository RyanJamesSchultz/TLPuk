function [lat,lon]=loadBOUND()
  % Simple function that loads in the play-bounded area.
  
%   %%% Country borders: UK & Ireland.
%   % Load in the shapefiles.
%   ShapeFilename1='/Users/rjs10/Desktop/TLPuk/data/Outlines/GBR_adm/GBR_adm0.shp';
%   ShapeFilename2='/Users/rjs10/Desktop/TLPuk/data/Outlines/IRL_adm/IRL_adm0.shp';
%   S1 = shaperead(ShapeFilename1);
%   S2 = shaperead(ShapeFilename2);
%   
%   % Seperate the data.
%   lon=[S1.X,S2.X];
%   lat=[S1.Y,S2.Y];

  %%% Shale play outlines.
  % Load in the shale play boundary.
  HFfile='/Users/rschultz/Desktop/TLPuk/data/Outlines/UKShaleArea.gmt';
  data=readmatrix(HFfile,'NumHeaderLines',11,'FileType','text');
  
  % Seperate the data.
  lon=data(:,1);
  lat=data(:,2);
  
return