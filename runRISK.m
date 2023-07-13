function S=runRISK(S,rand_flag)
  % Compute the risk curves.
  
  % Check that we're not already up to date.
  if(strcmpi(S.dVAR.UPDATEflag,'no'))
      return;
  end
  
  % Get lengths of map edges.
  Nx=length(S.MAP.lonG);
  Ny=length(S.MAP.latG);
  
  % Get lists of all of the lat/long coords of interest.
  latG=repmat(S.MAP.latG',1,Nx); latG=latG(:);
  lonG=repmat(S.MAP.lonG,Ny,1);  lonG=lonG(:);
  latE=[S.RISK.lat];
  lonE=[S.RISK.lon];
  
  % Get the map properties of interest.
  DEP=interp2(S.MAP.lonE,S.MAP.latE,S.MAP.DEP, lonE,latE,'linear');
  VS30=S.MAP.Vs30(:);
  DVS30=S.MAP.dVs30(:);
  POP=S.MAP.POP(:);
  
  % Omit shake-grid pixels that are completely unpopulated (e.g., ocean).
  Ip=(POP~=0);
  latG=latG(Ip);
  lonG=lonG(Ip);
  VS30=VS30(Ip);
  DVS30=DVS30(Ip);
  POP=POP(Ip);
  
  % Find the number of iterations needed.
  Ne=length(latE);
  Ng=length(latG);
  Nv=length(S.dVAR.dM);
  Nm=length(S.ML);
  
  % Get the flag for the GMPE to use.
  if(strcmpi(S.play_flag,'UK'))
      GMPEflag='edw21';
  end
  
  % Loop over all of the (new) perturbed values.
  ns=size(S.RISK(1).Nn2,1)+1;
  for i=ns:Nv
      
      % Get this iteration's perturbation values, depending on user flag.
      if(strcmpi(rand_flag,'random'))
          % Get all information and perturb it.
          M=S.Mw+S.dVAR.dM(i);                             % [1 Nm]
          dGMr=S.dVAR.dGMr(i);                             % [1 1]
          %dGMa=S.dVAR.dGMa(i,:); dGMa=dGMa(:);            % [Ng 1]
          dGMa=normrnd(0.0,1.0,[1 Ng]);                    % [Ng 1]
          dSA=S.dVAR.dSA(i);                               % [1 1]
          dep=abs(DEP+S.dVAR.dZ(i));                       % [Ne 1]
          vs30=VS30.*lognrnd(0.0,log10(exp(DVS30)));       % [Ng 1]
          pop=abs(normrnd(POP,sqrt(POP)))*S.dVAR.dPOP(i);  % [Ng 1]
          dN=[S.dVAR.dN1(i) S.dVAR.dN2(i)];
          Po=S.dVAR.Po(i);
          dLPR=S.dVAR.dLPR(i);
      elseif(strcmpi(rand_flag,'none'))
          % Get all information and perturb it.
          M=S.Mw;                                % [1 Nm]
          dGMr=S.dVAR.dGMr(i);                   % [1 1]
          %dGMa=S.dVAR.dGMa(i,:); dGMa=dGMa(:);  % [Ng 1]
          dGMa=zeros([1 Ng]);                    % [Ng 1]
          dSA=S.dVAR.dSA(i);                     % [1 1]
          dep=DEP;                               % [Ne 1]
          vs30=VS30;                             % [Ng 1]
          pop=POP;                               % [Ng 1]
          dN=[S.dVAR.dN1(i) S.dVAR.dN2(i)];
          Po=S.dVAR.Po(i);
          dLPR=S.dVAR.dLPR(i);
      elseif(strcmpi(rand_flag,'scenario'))
          % Get all information and perturb it.
          M=S.Mw+S.dVAR.dM(i);                             % [1 Nm]
          dGMr=S.dVAR.dGMr(i);                             % [1 1]
          %dGMa=S.dVAR.dGMa(i,:); dGMa=dGMa(:);            % [Ng 1]
          dGMa=normrnd(0.0,1.0,[1 Ng]);                    % [Ng 1]
          dSA=S.dVAR.dSA(i);                               % [1 1]
          dep=abs(DEP+S.dVAR.dZ(i));                       % [Ne 1]
          vs30=VS30.*lognrnd(0.0,log10(exp(DVS30)));       % [Ng 1]
          pop=abs(normrnd(POP,sqrt(POP)))*S.dVAR.dPOP(i);  % [Ng 1]
          dN=[S.dVAR.dN1(i) S.dVAR.dN2(i)];
          Po=S.dVAR.Po(i);
          dLPR=S.dVAR.dLPR(i);
      end
      
      % Reshape information into matrices [Ng Nm].
      M=repmat(M,Ng,1);
      vs30=repmat(vs30,1,Nm);
      pop=repmat(pop,1,Nm);
      
      % Compute the spatially-correlated ground motion variance.
      if(strcmpi(rand_flag,'random'))
          GMsc=GMSC(latG,lonG,1,dGMa,-1,GMPEflag);  % [Ng  1]
      else
          GMsc=ones([Ng 1]);
      end
      
      % Loop over all of the earthquake-grid pixels.
      for j=1:Ne
          
          % Get distances and reshape into matrix (km).
          Re=Geoid_Distance(latE(j),lonE(j),latG,lonG,'elliptical')*6371*pi()/180; % [Ng 1]
          Re=repmat(Re,1,Nm); % [Ng Nm]
          
          % Truncate based on maximum distance.
          In=(Re(:,1)<=S.MAP.ReN_max);
          Id=(Re(:,1)<=S.MAP.ReD_max);
          
          % Truncate to the closest grid point that's populated.
          Ii=find((pop(:,1)>0));
          [~,Im]=min(Re(Ii,1));
          Ii=Ii(Im);
          
          % Compute the ground motion matrices (PGVn:m/s & PGVd:mm/s).
          pgv_n=GMPE(Re(In,:),M(In,:),dep(j),vs30(In,:),dGMr,'inter', -1,GMPEflag)*dSA*0.01;     % [Ng(In) Nm]
          pgv_d=GMPE(Re(Id,:),M(Id,:),dep(j),vs30(Id,:),dGMr,'inter', -1,GMPEflag)*dSA*10;       % [Ng(Id) Nm]
          
          % Compute and apply the spatially-correlated PGV variance.
          pgv_n=pgv_n.*repmat(GMsc(In),[1 Nm]);     % [Ng(In) Nm]
          pgv_d=pgv_d.*repmat(GMsc(Id),[1 Nm]);     % [Ng(In) Nm]
          
          % Compute the average spectral acceleration (PSAi:g).
          psa_i=GMPE(Re(Ii,:),M(Ii,:),dep(j),vs30(Ii,:),dGMr,'total',  0,GMPEflag)*dSA/980.665;  % [Ng(Ii) Nm] i.e., [1 Nm]
          for k=1:length(M(Ii,:))
              psa_temp=zeros(size(S.T));
              for l=1:length(S.T)
                  psa_temp(l)=GMPE(Re(Ii,k),M(Ii,k),dep(j),vs30(Ii,k),dGMr,'total',  S.T(l),GMPEflag)*dSA/980.665;
              end
              psa_i(k)=AvgSA(S.T,real(psa_temp),0.2,'NL');
          end
          
          % Compute chance of nuisance observation [Ng(In) Nm].
          On2=NUISfxn(pgv_n,dN,2);
          On3=NUISfxn(pgv_n,dN,3);
          On4=NUISfxn(pgv_n,dN,4);
          On5=NUISfxn(pgv_n,dN,5);
          On6=NUISfxn(pgv_n,dN,6);
          
          % Compute chance of damage observation [Ng(Id) Nm].
          Od1=FRAGfxn_cosmetic(pgv_d,Po,1);
          Od2=FRAGfxn_cosmetic(pgv_d,Po,2);
          
          % Compute expected number of impacted households (X people/house) [1 Nm].
          Nn2=sum(On2.*pop(In,:),1)/S.Nph; Nn3=sum(On3.*pop(In,:),1)/S.Nph; Nn4=sum(On4.*pop(In,:),1)/S.Nph; Nn5=sum(On5.*pop(In,:),1)/S.Nph; Nn6=sum(On6.*pop(In,:),1)/S.Nph;
          Nd1=sum(Od1.*pop(Id,:),1)/S.Nph; Nd2=sum(Od2.*pop(Id,:),1)/S.Nph;
          
          % Compute the Local Personal Risk (probability of loss of life).
          lpr=VULNfxn_groningen(psa_i,dLPR)*0.95;
          
          % Stash results into the output data structure.
          S.RISK(j).Nn2=[S.RISK(j).Nn2;Nn2]; S.RISK(j).Nn3=[S.RISK(j).Nn3;Nn3]; S.RISK(j).Nn4=[S.RISK(j).Nn4;Nn4]; S.RISK(j).Nn5=[S.RISK(j).Nn5;Nn5]; S.RISK(j).Nn6=[S.RISK(j).Nn6;Nn6];
          S.RISK(j).Nd1=[S.RISK(j).Nd1;Nd1]; S.RISK(j).Nd2=[S.RISK(j).Nd2;Nd2]; 
          S.RISK(j).LPR=[S.RISK(j).LPR;lpr];
          
      end
  end
  
  % Flip the risk routine run flag.
  S.dVAR.UPDATEflag='no';
  
return
