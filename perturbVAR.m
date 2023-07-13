function S=perturbVAR(S,N,rand_flag,varargin)
  % Simple function that creates a list of perturbed variables.
  
  % Define the b-value statistics.
  if(strcmpi(S.play_flag,'UK'))
      bm=1.05;
      db=0.12;
      %Rs=0.9;
  end
  
  % Reduce the data that needs to be examined.
  POP=S.MAP.POP(:);
  POP=POP(POP~=0);
  Ng=length(POP);
  
  % Flag for random or average behaviour.
  if(strcmpi(rand_flag,'random'))
      % Create a vector of perturbation values.
      b=normrnd(bm,db,[1 N]);
      dM=dM_distribution(b,-1,'red+trail',[1 N]);
      dGMr=normrnd(0.0,1.0,[1 N]);
      %dGMa=normrnd(0.0,1.0,[1 Ng]);
      dN1=normrnd(0.0,1.0,[1 N]);
      dN2=normrnd(0.0,1.0,[1 N]);
      Po=abs(normrnd(0.0,0.15,[1 N]));
      dLPR=normrnd(0.0,1.0,[1 N]);
      dSA=lognrnd(0.0,0.05,[1 N]);
      dPOP=abs(normrnd(mean(S.MAP.POP(:)), sqrt(mean(S.MAP.POP(:))), [1 N])/mean(S.MAP.POP(:)));
      dZ=pearsrnd(0+0.15,0.25,1.05,4,[1 N]);
  elseif(strcmpi(rand_flag,'none'))
      % Create a vector of perturbation values.
      b=bm*ones([1 N]);
      dM=zeros([1 N]);
      dGMr=zeros([1 N]);
      %dGMa=zeros([1 Ng]);
      dN1=zeros([1 N]);
      dN2=zeros([1 N]);
      Po=zeros([1 N]);
      dLPR=zeros([1 N]);
      dSA=ones([1 N]);
      dPOP=ones([1 N]);
      dZ=zeros([1 N]);
  elseif(strcmpi(rand_flag,'scenario'))
      % Create a vector of perturbation values.
      gm=varargin{1};
      
      b=bm*ones([1 N]);
      dM=normrnd(0.0,0.2,[1 N]);
      dGMr=normrnd(gm,0.1,[1 N]);
      %dGMa=normrnd(0.0,1.0,[1 Ng]);
      dN1=normrnd(0.0,1.0,[1 N]);
      dN2=normrnd(0.0,1.0,[1 N]);
      Po=abs(normrnd(0.0,0.15,[1 N]));
      dLPR=normrnd(0.0,1.0,[1 N]);
      dSA=lognrnd(0,0.01,[1 N]);
      dPOP=ones([1 N]);
      dZ=normrnd(0.0,0.25,[1 N]);
  end
  
  % Append new values to the structure.
  S.dVAR.b=[S.dVAR.b,b];
  S.dVAR.dM=[S.dVAR.dM,dM];
  S.dVAR.dGMr=[S.dVAR.dGMr,dGMr];
  %S.dVAR.dGMa=[S.dVAR.dGMa;dGMa];
  S.dVAR.dN1=[S.dVAR.dN1,dN1];
  S.dVAR.dN2=[S.dVAR.dN2,dN2];
  S.dVAR.Po=[S.dVAR.Po,Po];
  S.dVAR.dLPR=[S.dVAR.dLPR,dLPR];
  S.dVAR.dSA=[S.dVAR.dSA,dSA];
  S.dVAR.dPOP=[S.dVAR.dPOP,dPOP];
  S.dVAR.dZ=[S.dVAR.dZ,dZ];
  
  % Flag that the risk routine needs to be (re)run now.
  S.dVAR.UPDATEflag='yes';
  
return