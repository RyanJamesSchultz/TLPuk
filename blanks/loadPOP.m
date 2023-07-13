function [latG,lonG,POP]=loadPOP(latE,lonE,Nd,filename)
  % Simple function that loads in LandScan population data for the map-bounded area.
  % Returns the grid edges too, (integer) truncated to the desired resolution.
  
  % Load in the grid file for population (interger counts).
  [lonG,latG,POP]=grdread2(filename);
  
  % Truncate the data to just the coords we're interested in.
  Iy=(latG<=max(latE))&(latG>=min(latE));
  Ix=(lonG<=max(lonE))&(lonG>=min(lonE));
  POP=POP(Iy,Ix);
  lonG=lonG(Ix);
  latG=latG(Iy);
  
  % Precondition the population data.
  POP(POP<0)=0;
  POP=double(POP);
  
  % Check if decimation is requested.
  Nd=round(Nd);
  if(Nd<=1)
      return;
  end
  
  % Decimate the grid edges.
  Iy=Nd:Nd:length(latG)-Nd+1;
  Ix=Nd:Nd:length(lonG)-Nd+1;
  latG=latG(Iy);
  lonG=lonG(Ix);
  
  % Prep for decimation.
  pop=zeros([length(latG) length(lonG)]);
  Ndh=ceil(Nd/2);
  Ndi=-Ndh+1:1:Ndh-1;
  
  % Decimate the population matrix.
  for iy=1:length(latG)
      for ix=1:length(lonG)
          
          % Sum over all neighbouring grid points.
          pop(iy,ix)=sum(POP(Iy(iy)+Ndi,Ix(ix)+Ndi),'all');
          if(mod(Nd,2)==0) % and share the odd numbered edges.
              edges=sum(POP(Iy(iy)+Ndi,Ix(ix)+Ndh),'all') + sum(POP(Iy(iy)+Ndh,Ix(ix)+Ndi),'all') + sum(POP(Iy(iy)-Ndi,Ix(ix)-Ndh),'all') + sum(POP(Iy(iy)-Ndh,Ix(ix)-Ndi),'all');
              corners=sum(POP(Iy(iy)+Ndh,Ix(ix)+Ndh),'all') + sum(POP(Iy(iy)-Ndh,Ix(ix)+Ndh),'all') + sum(POP(Iy(iy)-Ndh,Ix(ix)-Ndh),'all') + sum(POP(Iy(iy)+Ndh,Ix(ix)-Ndh),'all');
              pop(iy,ix)=pop(iy,ix)+0.5*edges+0.25*corners;
          end
      end
  end
  POP=pop;
  
return