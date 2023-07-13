clear;

% Load in the data structure: S.
load('TLP_uk.mat');

% Predefine some variables.
ML_f=2.5;
Pd=50;
Pn=50;
Pr=50;
Ni=12;

% Get the play-specific thresholds to use.
if(strcmpi(S.play_flag,'UK'))
    %Nn2_f=1.7555e+04;
    %Nn3_f=9.1051e+03;
    %Nn4_f=4.4162e+03;
    Nn2_f=9.5715e+03;
    Nn3_f=5.4755e+03;
    Nn4_f=2.7190e+03;
    Nd1_f=1e-1;
    Nd2_f=1e-4;
    LPR_f=1e-6;
end

% Scale the risk based on time-dependent population.
S=scaleRISK(S,2023,2018);

% Make iso-nuisance maps.
Rn2=mapRISK(S,'nuisance',2,1,Nn2_f,ML_f,Pn,Pd,Pr,Ni);
Rn3=mapRISK(S,'nuisance',3,1,Nn3_f,ML_f,Pn,Pd,Pr,Ni);
Rn4=mapRISK(S,'nuisance',4,1,Nn4_f,ML_f,Pn,Pd,Pr,Ni);

% Make iso-damage maps.
Rd1=mapRISK(S,'damage',3,1,Nd1_f,ML_f,Pn,Pd,Pr,Ni);
Rd2=mapRISK(S,'damage',3,2,Nd2_f,ML_f,Pn,Pd,Pr,Ni);

% Make iso-LPR map.
Rr=mapRISK(S,'LPR',3,1,LPR_f,ML_f,Pr,Pd,Pr,Ni);

% Combine the nuisance maps.
[Mn_comb,Nindex]=mapCOMBINE(Rn2.Mr,Rn3.Mr,Rn4.Mr);
Nindex=Nindex+1;

% Combine the damage maps
[Md_comb,Dindex]=mapCOMBINE(Rd1.Mr,Rd2.Mr,Rd2.Mr);
Dindex(Dindex==3)=2;

% Make the combination map.
[Mcomb,index]=mapCOMBINE(Mn_comb,Md_comb,Rr.Mr);

% Stuff everything into a structure.
% Nuisance maps.
M.N.T2=Nn2_f; M.N.T3=Nn3_f; M.N.T4=Nn4_f;
M.N.N2=Rn2; M.N.N3=Rn3; M.N.N4=Rn4;
M.N.Tm=ML_f;
M.N.Mcomb=Mn_comb;
M.N.index=Nindex;
% Damage maps.
M.D.T1=Nd1_f; M.D.T2=Nd2_f;
M.D.D1=Rd1; M.D.D2=Rd2;
M.D.Tm=ML_f;
M.D.Mcomb=Md_comb;
M.D.index=Dindex;
% LPR maps.
M.R.R1=Rr;
M.R.T1=LPR_f;
M.R.Tm=ML_f;
% Combination map.
M.Mcomb=Mcomb;
M.index=index;

% Save the structure.
save('TLPmap_temp.mat','M', '-v7.3');





