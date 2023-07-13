clear;

% The PGA/MMI scale.
PGA=10.^(1.0:0.05:3.0); %cm/s^2.
MMI=pgm2mmi(PGA,'pga');

% Convert to PGA and then to avgSA (g).
%mPSA=exp(interp1([2 3 4 5 5.5 6 7 8 9],[-0.367 0.156 0.903 1.176 1.629 2.066 2.218 2.556 2.414],MMI,'linear'))*0.65/980.665; % Atkinson & Kaka, 2007; Table 3.
%mPSA=exp(interp1([2 3 4 5 5.5 6 7 8 9],[-0.367 0.156 0.903 1.176 1.629 2.066 2.218 2.556 2.414],MMI,'linear'))*0.65/980.665; % Atkinson & Kaka, 2007; Table 3.

% PAGER vulnerability coefficients from and updated version of Jaiswal et al., 2009.
Tjap=log(11.93);  Bjap=0.10;
Tira=log( 9.58);  Bira=0.10;
Tind=log(11.53);  Bind=0.14;
Tgre=log(21.48);  Bgre=0.28;
Tita=log(13.23);  Bita=0.18;
Tino=log(14.05);  Bino=0.17;
Tusa=log(38.53);  Busa=0.36;
Tuk=log(20.062);  Buk=0.257;

% Compute the PAGER vulnerabilty functions.
FRjap=logncdf(MMI,Tjap,Bjap);
FRira=logncdf(MMI,Tira,Bira);
FRind=logncdf(MMI,Tind,Bind);
FRgre=logncdf(MMI,Tgre,Bgre);
FRita=logncdf(MMI,Tita,Bita);
FRino=logncdf(MMI,Tino,Bino);
FRusa=logncdf(MMI,Tusa,Busa);
FRuk =logncdf(MMI,Tuk ,Buk );

% Compute the Groningen vulnerability fnction.
FRgrn=VULNfxn_groningen(PGA*0.65/980.665,0);

% Plotting similarily to Figure 3 in Jaiswal & Wald, 2010.
figure(55); clf;
semilogy(MMI,FRgrn,'-k','LineWidth',3,'DisplayName','Groningen'); hold on;
semilogy(MMI,FRuk ,':r','LineWidth',3,'DisplayName','UK');
semilogy(MMI,FRjap,':b','LineWidth',2,'DisplayName','Japan');
semilogy(MMI,FRira,':m','LineWidth',2,'DisplayName','Iran');
semilogy(MMI,FRind,':k','LineWidth',2,'DisplayName','India');
semilogy(MMI,FRgre,':c','LineWidth',2,'DisplayName','Greece');
semilogy(MMI,FRita,':y','LineWidth',2,'DisplayName','Italy');
semilogy(MMI,FRino,':g','LineWidth',2,'DisplayName','Indonesia');
ylim([1e-6 1e0]); xlim([6 9]);
xlabel('Ground Shaking Intensity'); ylabel('Fatality Rate');
legend('Location','northwest');


