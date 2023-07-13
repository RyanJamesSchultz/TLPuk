function Y=GMPE(Re,M,dep,vs30,dE,VARflag,T,GMPEflag)
  % Control function to manage GMPEs.  Returns PGV (cm/s) or 
  % PGA/PSA (cm/s²) as a function of the inputs.
  % All GMPEs are vectorized.
  % 
  % Written by Ryan Schultz.
  
  % Find out the type of ground motion the user specified.
  if(T==-1)
      GMtype='PGV';
  elseif(T==0)
      GMtype='PGA';
  else
      GMtype='PSA';
  end
  
  % Get the ground motion, from the user specified GMPE.  Also convert to appropriate units.
  if(strcmpi(GMPEflag,'zr18'))
      Y=GMPEs.GMPEzr18(T,M,1,Re,dep,vs30,0,0,dE);
      if(~strcmpi(GMtype,'PGV'))
          Y=Y*980.665;
      end
  elseif(strcmpi(GMPEflag,'a15_fc'))
      Y=GMPEs.GMPEa15_fc(Re,M,dep,vs30,dE,GMtype);
  elseif(strcmpi(GMPEflag,'a15'))
      Y=GMPEs.GMPEa15(Re,M,dep,vs30,dE,GMtype);
  elseif(strcmpi(GMPEflag,'mk17'))
      Y=GMPEs.GMPEmk17(Re,M,dep,vs30,dE,GMtype);
  elseif(strcmpi(GMPEflag,'dg13'))
      Y=GMPEs.GMPEdg13(Re,M,dep,vs30,dE,GMtype);
  elseif(strcmpi(GMPEflag,'bg21'))
      Y=GMPEs.GMPEbg21(Re,M,dep,vs30,dE,GMtype);
  elseif(strcmpi(GMPEflag,'b14'))
      Y=GMPEs.GMPEbg21(Re,M,dep,vs30,dE,GMtype);
  elseif(strcmpi(GMPEflag,'edw21'))
      Y=GMPEs.GMPEedw21(Re,M,dep,vs30,'alt-h',dE,VARflag,T);
  elseif(strcmpi(GMPEflag,'cwb19'))
      Y=GMPEs.GMPEcwb19(Re,M,dep,vs30,dE,VARflag,T);
  end
  
return