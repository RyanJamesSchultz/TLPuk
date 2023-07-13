function P=FRAGfxn_cosmetic(pgv,PSIo,level_flag)
  % Computes the chance of observation for nuisance (pgv: mm/s).
  %
  % References:
  % Korswagen, Longo, Meulman, Licciardello, & Sousamli (2019). Damage Sensitivity of Groningen Masonry – Experimental and Computational Studies (Part 2)
  %
  % Written by Ryan Schultz.
  
  % Load in the fragility function's numerical values.
  load('Dfxn.mat','Dfxn');
  
  % Find the indice that's closest to the user input initial damage state.
  PSIo_f=[Dfxn.Po];
  I=interp1(PSIo_f,1:length(PSIo_f),PSIo,'nearest');
  if(PSIo<min(PSIo_f))
      I=1;
  end
  
  % Korswagen et al., 2019 (Table 7.4; Page 217, PDF272).
  if(level_flag==1) % Visible light damage.
      gm_f=Dfxn(I).gm;
      ds_f=Dfxn(I).DS1;
  elseif(level_flag==2) % Easily observable light damage.
      gm_f=Dfxn(I).gm;
      ds_f=Dfxn(I).DS2;
  end
  
  % Interpolate the probabilities.
  P=interp1(gm_f,ds_f,pgv,'linear');

  % Handle extrapolations.
  P(pgv>=1000)=1;
  P(pgv<0.5)=0;
    
return