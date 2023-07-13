function [S]=scaleRISK(S,y,yn)
  % Scale the impact risks.
  
  % Normalize based on the changing population of the Netherlands.
  [R,~]=POPvT(y,yn);
  for i=1:length(S.RISK)
      S.RISK(i).Nn2=S.RISK(i).Nn2*R;
      S.RISK(i).Nn3=S.RISK(i).Nn3*R;
      S.RISK(i).Nn4=S.RISK(i).Nn4*R;
      S.RISK(i).Nn5=S.RISK(i).Nn5*R;
      S.RISK(i).Nn6=S.RISK(i).Nn6*R;
      S.RISK(i).Nd1=S.RISK(i).Nd1*R;
      S.RISK(i).Nd2=S.RISK(i).Nd2*R;
  end
  
return