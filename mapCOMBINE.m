function [Mc,I]=mapCOMBINE(Mn,Md,Mr)
  % Combine the risk maps.
  
  % Make a combined map.
  [Mc,I]=min(cat(3,Mn,Md,Mr),[],3,'omitnan');
  
  % Trim to just the points that are within the play boundary.
  I(isnan(Mc))=NaN;
  
return