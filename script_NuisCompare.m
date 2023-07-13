clear;

% Load in the data structures: M & S.
load('TLPmap_uk.mat','M');


dMn2=(M.N.N2.Mr-M.N.Mcomb);
dMn3=(M.N.N3.Mr-M.N.Mcomb);
dMn4=(M.N.N4.Mr-M.N.Mcomb);

dMd1=(M.D.D1.Mr-M.D.Mcomb);
dMd2=(M.D.D2.Mr-M.D.Mcomb);

max(dMn2(:))
max(dMn3(:))
max(dMn4(:))