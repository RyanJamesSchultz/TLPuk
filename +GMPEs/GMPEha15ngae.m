% by George Zalachoris, 4/27/07
% University of Texas at Austin
% gzalachoris@gmail.com
%
% Hassani & Atkinson - NGA-East GMPE (2015)
%
% Application of adjustment factor on BSSA14 NGA-West2 GMPE
%
% Note: all inputs and outputs are scalars (i.e., 1x1 matrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Variables
% T = Period (sec), 0 for PGA, -1 for PGV
% M = Moment magnitude
% F = Faut type: 1 for unspecified, 2 for strike-slip, 3 for
% normal, 4 for reverse
% Rjb = Joyner-Boore distance (km)
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
function [Sa, sigma] = GMPEha15ngae(T, M, F, Rjb, Vs30, region, z1)
% Coefficients
coeffs = load('/Users/rjs10/Desktop/EF_TLP/data/ZR18_PIE_GMM/HA15_NGAE_Coeffs.txt');
period = coeffs(:,1);
c1     = coeffs(:,2);
c2     = coeffs(:,3);
c3     = coeffs(:,4);
% Aleatory Uncertainty Coefficients
sig_total  = coeffs(:,5);
tau        = coeffs(:,6);
phi        = coeffs(:,7);

% interpolate between periods if neccesary
if (length(find(abs((period - T)) < 0.0001)) == 0)
    T_low = max(period(find(period<T)));
    T_hi = min(period(find(period>T)));
    [sa_low, sigma_low] = GMPEs.GMPEha15ngae(T_low, M, F, Rjb, Vs30, region, z1);
    [sa_hi, sigma_hi] = GMPEs.GMPEha15ngae(T_hi, M, F, Rjb, Vs30, region, z1);
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low(:)), log(sa_hi(:))]';
    Y_sigma = [sigma_low sigma_hi];
    Sa = exp(interp1(x,Y_sa,log(T)));
    Sa = reshape(Sa,size(sa_low));
    sigma = interp1(x,Y_sigma,log(T));
else
    i = find(abs((period - T)) < 0.0001); % Identify the period index
    % BSSA14 GMIMs
    [SaBSSA, ~] = GMPEs.GMPEbssa14(T, M, F, Rjb, Vs30, region, z1);
    % Adjustment Factor
    logF_ENA = c1(i) + c2(i)*Rjb + c3(i)*max(0,log10(min(Rjb,150)/50));
    F_ENA = 10.^logF_ENA; % cm/s2
    % Median Sa for Hassani & Atkinson GMPE
    Sa = F_ENA .* SaBSSA;
    %[ Sa3000 ] = SiteConv760to3000( T, Rjb, Sa );
    % Standard Deviation
    sigma = sig_total(i);
end