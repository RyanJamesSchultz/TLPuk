function [R,PGA,PGV]=parseGMbgs(filename)
  % Simple routine to parse csv files for BGS ground motions (by Ryan).
  
  % Load in the GM data.
  % R, PGA, PGV
  command=['cat ', filename, ' | ', ...       % Load in all the EQ data files.
           'tail +4 | ', ...                  % Remove the header.
           'awk ''! /(HHZ|BHZ|ENZ)/'' |', ... % Remove Z components.
           'awk  -F, ''{print$2, $3, $4}'' > temp.gmParse']; % Output just the necessary fields.
  system(command);
  data=load('temp.gmParse');
  system('rm -f temp.gmParse');
  R=data(:,1); % km.
  PGA=data(:,2)*100; % cm/s².
  PGV=data(:,3)*100; % cm/s.

  % Sort by distance.
  [~,I]=sort(R);
  R=R(I);
  PGA=PGA(I);
  PGV=PGV(I);
  
return


