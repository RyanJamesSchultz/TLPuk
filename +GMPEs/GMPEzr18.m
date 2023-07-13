% by George Zalachoris, 4/27/07
% University of Texas at Austin
% gzalachoris@gmail.com
%
% Adjusted GMPE for PIE - Hassani & Atkinson - NGA-East GMPE (2015)
%
% Note: all inputs and outputs are scalars (i.e., 1x1 matrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Variables
% T = Period (sec), 0 for PGA, -1 for PGV
% M = Moment magnitude
% F = Faut type: 1 for unspecified, 2 for strike-slip, 3 for
% normal, 4 for reverse
% Rjb = Joyner-Boore distance (km)
% depth = hypocentral depth (km)
% Vs30 = shear wave velocity averaged over top 30 m (m/s)
% region: 0 for no regional correction (default),
%         1 for California, New Zealand, and Taiwan
%         2 for China and Turkey
%         3 for Italy and Japan
% z1 = basin depth (default: ignored)
% -------------------------------------------------------------------------
% Output Variables
% Sa: Median spectral acceleration or PGV prediction (g or cm/s)
% sigma: logarithmic standard deviation of Sa prediction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Sa, sigma] = GMPEzr18(T, M, F, Rjb, depth, Vs30, region, z1, dE)

Rhyp = sqrt( Rjb.^ 2 + depth.^2 );
Rmin = 5.0;
Mmax = 5.8;

% Coefficients
coeffs = load('/Users/rjs10/Desktop/EF_TLP/data/ZR18_PIE_GMM/ZR18_Coeffs.txt');
period = coeffs(:,1);
alpha  = coeffs(:,2);
Rb     = coeffs(:,3);
Mb     = coeffs(:,4);
b0     = coeffs(:,5);
b1     = coeffs(:,6);
c      = coeffs(:,7);
Vc     = coeffs(:,8);
C      = coeffs(:,9);
tau    = coeffs(:,10);
phi    = coeffs(:,11);
% interpolate between periods if neccesary
if (length(find(abs((period - T)) < 0.0001)) == 0)
    T_low = max(period(find(period<T)));
    T_hi = min(period(find(period>T)));
    [sa_low, sigma_low] = GMPEs.GMPEzr18(T_low, M, F, Rjb, depth, Vs30, region, z1, dE);
    [sa_hi, sigma_hi]  = GMPEs.GMPEzr18(T_hi, M, F, Rjb, depth, Vs30, region, z1, dE);
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low(:)), log(sa_hi(:))]';
    Y_sigma = [sigma_low sigma_hi];
    Sa = exp(interp1(x,Y_sa,log(T)));
    Sa = reshape(Sa,size(sa_low));
    sigma = interp1(x,Y_sigma,log(T));
else
    i = find(abs((period - T)) < 0.0001); % Identify the period index
    % HA15 GMIMs
    [SaHA15, ~] = GMPEs.GMPEha15ngae(T, M, F, Rjb, Vs30, region, z1);
    % Adjustment Factor
    Fm = b0(i)*ones(size(M));
    I=(M >= Mb(i) & M < Mmax);
    Fm(I) = b0(i) + b1(i)*( M(I) - Mb(i) );
    I=M >= Mmax;
    Fm(I) = (b0(i) + b1(i)*( Mmax - Mb(i) ))*ones(size(M(I)));
    
    Fr = 0*zeros(size(Rhyp));
    I=Rhyp < Rb(i) & Rhyp >= Rmin;
    Fr(I) = alpha(i) * log(Rhyp(I)/Rb(i));
    I=Rhyp < Rmin;
    Fr(I) = (alpha(i) * log(Rmin/Rb(i)))*ones(size(Rhyp(I)));
    
    Fs=0*zeros(size(Vs30));
    I=Vs30 < Vc(i);
    Fs(I) = c(i) * log(Vs30(I)/Vc(i));
    
    logFadj = Fm + Fr + Fs + C(i);
    Fadj =  exp(logFadj);
    Sa = Fadj .* SaHA15;
    sigma = sqrt( tau(i)^2 + phi(i)^2 );
    
    % Add (or subtract) error, if requested to.
    Sa=Sa.*exp(sigma.*dE);
  
end