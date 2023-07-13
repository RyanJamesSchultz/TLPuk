function PSIf=DAMAGEfxn(PGV,PSIo,N,m,dE,SFE_flag)
  % Function to compute expected damage for Groningen buildings.  
  % Outputs PSIf and a fxn of inputs.  PGV is input as mm/s. 
  % Code is vectorized.
  %
  % Reference:
  % Korswagen, Longo, Meulman, Licciardello, & Sousamli (2019). Damage Sensitivity of Groningen Masonry – Experimental and Computational Studies (Part 2)
  % 
  % Written by Ryan Schultz.
  
  % Define constants (Table 7.3; Page 211 - PDF266).
  if(strcmpi(SFE_flag,'A-A-Ne'))
      a1=0.645; a2=0.145; a3=1.553;   a4=0.339;   a5=6.242;  a6=2.8e-12; a7=5.9e-7;  a8=1.0e-12; a9=1.5e-10; a10=35.206; a11=1.078;
  elseif(strcmpi(SFE_flag,'A-A-Fa'))
      a1=0.420; a2=0.018; a3=1.703;   a4=6.4e-3;  a5=71.769; a6=1.0e-12; a7=2.779;   a8=0.727;   a9=0.989;   a10=29.051; a11=0.830;
  elseif(strcmpi(SFE_flag,'A-B-Ne'))
      a1=0.576; a2=0.112; a3=1.7e-11; a4=6.1e-4;  a5=11.256; a6=1.3e-11; a7=4.2e-2;  a8=5.1e-2;  a9=7.429;   a10=71.104; a11=0.000;
  elseif(strcmpi(SFE_flag,'A-B-Fa'))
      a1=0.310; a2=0.230; a3=1.0e-12; a4=1.0e-12; a5=1.8e-5; a6=1.0e-12; a7=1.8e-12; a8=1.494;   a9=1.0e-12; a10=26.833; a11=0.000;
  elseif(strcmpi(SFE_flag,'B-A-Ne'))
      a1=0.638; a2=0.176; a3=1.385;   a4=0.357;   a5=5.996;  a6=1.0e-12; a7=2.3e-4;  a8=2.2e-4;  a9=7.038;   a10=34.607; a11=1.093;
  elseif(strcmpi(SFE_flag,'B-A-Fa'))
      a1=0.420; a2=0.040; a3=1.548;   a4=0.046;   a5=99.999; a6=2.9e-7;  a7=0.569;   a8=0.605;   a9=2.991;   a10=28.087; a11=0.880;
  elseif(strcmpi(SFE_flag,'B-B-Ne'))
      a1=0.617; a2=0.210; a3=0.845;   a4=4.1e-5;  a5=23.333; a6=3.1e-3;  a7=1.232;   a8=3.5e-4;  a9=28.560;  a10=80.313; a11=1.301;
  elseif(strcmpi(SFE_flag,'B-B-Fa'))
      a1=0.362; a2=0.249; a3=4.3e-2;  a4=3.3e-5;  a5=22.847; a6=6.1e-4;  a7=0.058;   a8=1.515;   a9=1.747;   a10=31.734; a11=0.335;
  else
      return
  end
  
  % Compute the Model 2 predicted change in damage (Page 210 - PDF265).
  B1=a1*(N.^a2)./(1+(PSIo.^a3));
  B2=5-0.5*PGV./(1+(a4*PSIo.^a5)+(a8*m.^a9));
  B3=PGV./(1+(a6*PSIo.^a7)+(a10*m.^a11));
  dPSI=B1.*((1./(1+exp(B2)))+B3);
  
  % Perturb dPSI based on gaussian error distribution (Page 214 - PDF269).
  dPSI=dPSI+0.2*dE;
  dPSI(dPSI<0)=0;
  
  % Output the final change in PSI (Page 210 - PDF265).
  PSIf=PSIo+dPSI;

return