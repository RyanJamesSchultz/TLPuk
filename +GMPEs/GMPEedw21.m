function [ psa ] = GMPEedw21(Re,M,dep,Vs30,Rh,dE,sigmatype, T)
  % Computes the PGV (cm/s) & PGA/PSA (cm/s²) as a fxn of the inputs.
  % Based on Benjamin's work for HF-IS GMPEs in the UK (Edwards et al., 2021).
  % Code is vectorized.  Allows linear interpolation between coefficients.
  % 
  % References:
  % Atkinson, (2015). Ground-motion prediction equation for small-to-moderate events at short hypocentral distances, with application to induced-seismicity hazards. BSSA, 105(2A), 981-992, doi: 10.1785/0120140142.
  % Boore, Stewart, Seyhan, & Atkinson, (2014). NGA-West2 equations for predicting PGA, PGV, and 5% damped PSA for shallow crustal earthquakes. Earthquake Spectra, 30(3), 1057-1085, doi: 10.1193/070113EQS184M.
  % Edwards, Crowley, Pinho, & Bommer, (2021). Seismic hazard and risk due to induced earthquakes at a shale gas site. BSSA, 111(2), 875-897, doi: 10.1785/0120200234.
  % 
  % Written by Benjamin Edwards, modified by Ryan Schultz.
  
  % Predfine some ceofficients.
  Mlim1=3.0;
  Mlim2=4.5;
  
  % Get the hypocentral distance.
  Rhyp=sqrt(Re.^2+dep.^2);
  
  % Define Ben's E21 coefficients.
  cE=[0.5491      0.76037     1.1531      1.1446      0.045688    -0.829      -0.86813      0.13383     -0.18791     -0.34234;...  % dc0
     -0.08294    -0.057531   -0.08642    -0.13884     0.27247      0.47339     0.40366     -0.057892     0.14859      0.42676;...  % dc1
      0.02353     0.0083292   0.014357    0.021397   -0.044161    -0.064206   -0.055583     0.021385     0.0084897   -0.034681;... % dc2
     -0.49613    -0.51186    -0.8086     -0.73207    -0.285        0.0044899   0.14077     -0.23199     -0.49959     -0.6755;...   % dc3
      0.13897     0.14516     0.17209     0.12947     0.11575      0.12505     0.14569      0.15148      0.12596      0.12738;...  % dc0_SE
      0.091672    0.091128    0.11345     0.086665    0.064939     0.082179    0.10441      0.11167      0.073187     0.065588;... % dc1_SE
      0.017502    0.017792    0.021739    0.016502    0.013265     0.015703    0.019343     0.01999      0.013745     0.01346;...  % dc2_SE
      0.10853     0.11495     0.13126     0.097955    0.099028     0.097553    0.10341      0.093401     0.091416     0.095169;... % dc3_SE
      0.05848     0.064       0.082792    0.062399    0.035851     0.055877    0.080273     0.08537      0.036686     0.075986;... % tau
      0.30152     0.31919     0.37893     0.26193     0.26843      0.23665     0.23179      0.20337      0.20464      0.21331;...  % phi
      0.21775     0.25691     0.28609     0.20792     0.2234       0.2058      0.2207       0.20486      0.20473      0.23163;...  % phiS2S
      0.30714     0.32554     0.38787     0.26926     0.27082      0.24315     0.2453       0.22056      0.20791      0.22644;...  % sigma
      23          23          23          23          23           23          23           19           12           4;...        % Nevt
      299         301         301         301         299          246         199          144          58           12 ];        % Nobs
  Tc=[-1 0 0.03 0.05 0.1 0.2 0.3 0.5 1.0 2.0];
  if(T==-1)
      index=1; % PGV.
      dc0=cE(1,index);
      dc1=cE(2,index);
      dc2=cE(3,index);
      dc3=cE(4,index);
  elseif(T==0)
      index=2; % PGA.
      dc0=cE(1,index);
      dc1=cE(2,index);
      dc2=cE(3,index);
      dc3=cE(4,index);
  else
      % PSA.
      dc0=interp1(Tc,cE(1,:),T,'linear');
      dc1=interp1(Tc,cE(2,:),T,'linear');
      dc2=interp1(Tc,cE(3,:),T,'linear');
      dc3=interp1(Tc,cE(4,:),T,'linear');
  end
  
  % Define an array of Gail's A15 coefficients: 
  %   T (s)    c0        c1        c2       c3        sintra   sinter   stotal
  cA=[5.000000 -4.321000 1.080000  0.009376 -1.378000 0.250000 0.180000 0.310000;...
      3.030303 -3.827000 1.060000  0.009086 -1.398000 0.240000 0.220000 0.320000;...
      2.000000 -4.462000 1.485000 -0.038150 -1.361000 0.240000 0.230000 0.330000;...
      1.000000 -4.081000 1.742000 -0.073810 -1.481000 0.260000 0.220000 0.340000;...
      0.500000 -3.873000 2.060000 -0.121200 -1.544000 0.290000 0.200000 0.350000;...
      0.300300 -2.794000 1.852000 -0.107800 -1.608000 0.300000 0.190000 0.360000;...
      0.200000 -2.266000 1.785000 -0.106100 -1.657000 0.300000 0.210000 0.370000;...
      0.100000 -1.954000 1.830000 -0.118500 -1.774000 0.290000 0.250000 0.390000;...
      0.050000 -2.018000 1.826000 -0.119200 -1.831000 0.280000 0.300000 0.410000;...
      0.030303 -2.283000 1.842000 -0.118900 -1.785000 0.280000 0.270000 0.390000;...
      0.010000 -2.376000 1.818000 -0.115300 -1.752000 0.280000 0.240000 0.370000;...
      0        -2.376000 1.818000 -0.115300 -1.752000 0.280000 0.240000 0.370000;...
     -1        -4.151000 1.762000 -0.095090 -1.669000 0.270000 0.190000 0.330000];
  
  % Get Gail's coefficients for PGA.
  c0_pga = cA(12,2);
  c1_pga = cA(12,3);
  c2_pga = cA(12,4);
  c3_pga = cA(12,5);
  
  % Get Gail's coefficients for PSA.
  if(T==-1)
      index=13; % PGV.
      c0 = cA(index,2).*ones(size(M));
      c1 = cA(index,3).*ones(size(M));
      c2 = cA(index,4).*ones(size(M));
      c3 = cA(index,5).*ones(size(M));
      sintra = cA(index,6).*ones(size(M));
      sinter = cA(index,7).*ones(size(M));
      stotal = cA(index,8).*ones(size(M));
  elseif(T==0)
      index=12; % PGA.
      c0 = cA(index,2).*ones(size(M));
      c1 = cA(index,3).*ones(size(M));
      c2 = cA(index,4).*ones(size(M));
      c3 = cA(index,5).*ones(size(M));
      sintra = cA(index,6).*ones(size(M));
      sinter = cA(index,7).*ones(size(M));
      stotal = cA(index,8).*ones(size(M));
  else
      % PSA.
      c0 = interp1(cA(:,1),cA(:,2),T,'linear').*ones(size(M));
      c1 = interp1(cA(:,1),cA(:,3),T,'linear').*ones(size(M));
      c2 = interp1(cA(:,1),cA(:,4),T,'linear').*ones(size(M));
      c3 = interp1(cA(:,1),cA(:,5),T,'linear').*ones(size(M));
      sintra = interp1(cA(:,1),cA(:,6),T,'linear');
      sinter = interp1(cA(:,1),cA(:,7),T,'linear');
      stotal = interp1(cA(:,1),cA(:,8),T,'linear');
  end
  
  % Modify coefficients, based on magnitude.
  c0(M<=Mlim1)=c0(M<=Mlim1)+dc0;
  c1(M<=Mlim1)=c1(M<=Mlim1)+dc1;
  c2(M<=Mlim1)=c2(M<=Mlim1)+dc2;
  c3(M<=Mlim1)=c3(M<=Mlim1)+dc3;
  if(sum(M>Mlim1&M<=Mlim2)>0)
      c0(M>Mlim1&M<=Mlim2)=c0(M>Mlim1&M<=Mlim2)+(M(M>Mlim1&M<=Mlim2)-Mlim2).*(dc0/(Mlim1-Mlim2));
      c1(M>Mlim1&M<=Mlim2)=c1(M>Mlim1&M<=Mlim2)+(M(M>Mlim1&M<=Mlim2)-Mlim2).*(dc1/(Mlim1-Mlim2));
      c2(M>Mlim1&M<=Mlim2)=c2(M>Mlim1&M<=Mlim2)+(M(M>Mlim1&M<=Mlim2)-Mlim2).*(dc2/(Mlim1-Mlim2));
      c3(M>Mlim1&M<=Mlim2)=c3(M>Mlim1&M<=Mlim2)+(M(M>Mlim1&M<=Mlim2)-Mlim2).*(dc3/(Mlim1-Mlim2));
  end
  
  % Compute the ground motions.
  if(strcmp(Rh,'orig')) % the original A15 M-R saturation type.
      psa_Vsref=c0+c1.*M+c2.*M.^2+c3.*log(sqrt(Rhyp.^2+(max(1,10.^(-1.72+0.43.*M))).^2))./log(10);
      pga_Vsref_g=0.01*(1./9.81)*10.^(c0_pga+c1_pga.*M+c2_pga.*M.^2+c3_pga.*log(sqrt(Rhyp.^2+(max(1,10.^(-1.72+0.43.*M))).^2))./log(10));
  elseif(strcmp(Rh,'alt-h')) % the alternative A15 M-R saturation type.
      psa_Vsref=c0+c1.*M+c2.*M.^2+c3.*log(sqrt(Rhyp.^2+(max(1,10.^(-0.28+0.19.*M))).^2))./log(10);
      pga_Vsref_g=0.01*(1./9.81)*10.^(c0_pga+c1_pga.*M+c2_pga.*M.^2+c3_pga.*log(sqrt(Rhyp.^2+(max(1,10.^(-0.28+0.19.*M))).^2))./log(10));
  else
      disp("Rh model must be either 'orig' or 'alt-h'")
  end
  
  % Compute the site amplification term (Boore et al., 2014).
  site=GMPEs.SAbo14(Vs30,pga_Vsref_g,T)/log(10); % convert to base-10 log.
  
  % Add (or subtract) error, if requested to.
  if(strcmp(sigmatype,'total'))
      psa=site+psa_Vsref+stotal*dE;
  elseif(strcmp(sigmatype,'inter'))   
      psa=site+psa_Vsref+sinter*dE;
  elseif(strcmp(sigmatype,'intra'))   
      psa=site+psa_Vsref+sintra*dE;
  elseif(strcmp(sigmatype,'both'))   
      psa=site+psa_Vsref+sqrt(sintra.^2*dE(1)+sinter.^2*dE(2));
  end
  
  % Convert to non-logarithmic scale.
  psa=10.^psa;
  
return