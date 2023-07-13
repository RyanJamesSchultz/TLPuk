% by George Zalachoris, 4/27/07
% University of Texas at Austin
% gzalachoris@gmail.com
%
% Boore et al. (2014)
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
% z1   = basin depth (default: ignored)
% -------------------------------------------------------------------------
% Output Variables
% Sa: Median spectral acceleration or PGV prediction (g or cm/s)
% sigma: logarithmic standard deviation of Sa prediction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Sa, sigma] = GMPEbssa14(T, M, F, Rjb, Vs30, region, z1)
% Coefficients
v1 = 225;
v2 = 300;
vref = 760;
mref = 4.5;
rref = 1;

coeffs = load('/Users/rjs10/Desktop/EF_TLP/data/ZR18_PIE_GMM/BSS14_Coeffs.txt');
period = coeffs(:,1);
% Magnitude Scaling Coefficients
e00    = coeffs(:,2);
e01    = coeffs(:,3);
e02    = coeffs(:,4);
e03    = coeffs(:,5);
e04    = coeffs(:,6);
e05    = coeffs(:,7);
e06    = coeffs(:,8);
mh     = coeffs(:,9);
% Distance Scaling Coefficients
c1     = coeffs(:,10);
c2     = coeffs(:,11);
c3     = coeffs(:,12);
h      = coeffs(:,15);
Dc3    = coeffs(:,16);
% Site Amplification Coefficients
c      = coeffs(:,19);
Vc     = coeffs(:,20);
f1     = coeffs(:,22);
f3     = coeffs(:,23);
f4     = coeffs(:,24);
f5     = coeffs(:,25);
f6     = coeffs(:,26);
f7     = coeffs(:,27);
% Aleatory Uncertainty Coefficients
R1     = coeffs(:,28);
R2     = coeffs(:,29);
DfR    = coeffs(:,30);
DfV    = coeffs(:,31);
phi1   = coeffs(:,34);
phi2   = coeffs(:,35);
t1     = coeffs(:,36);
t2     = coeffs(:,37);

% interpolate between periods if neccesary
if (length(find(abs((period - T)) < 0.0001)) == 0)
    T_low = max(period(find(period<T)));
    T_hi = min(period(find(period>T)));
    [sa_low, sigma_low] = GMPEs.GMPEbssa14(T_low, M, F, Rjb, Vs30, region, z1);
    [sa_hi, sigma_hi] = GMPEs.GMPEbssa14(T_hi, M, F, Rjb, Vs30, region, z1);
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low(:)), log(sa_hi(:))]';
    Y_sigma = [sigma_low sigma_hi];
    Sa = exp(interp1(x,Y_sa,log(T)));
    Sa = reshape(Sa,size(sa_low));
    sigma = interp1(x,Y_sigma,log(T));
else
    i = find(abs((period - T)) < 0.0001); % Identify the period index
    inl = find(abs((period - 0)) < 0.0001); % Identify location of pga
    % Magnitude Scaling
    U = (F == 1);
    S = (F == 2);
    N = (F == 3);
    R = (F == 4);
    Fm = e00(i)*U + e01(i)*S + e02(i)*N + e03(i)*R + e06(i)*(M - mh(i));
    I=(M<=mh(i));
    Fm(I) = e00(i)*U + e01(i)*S + e02(i)*N + e03(i)*R + e04(i)*(M(I)-mh(i)) + e05(i)*(M(I)-mh(i)).^2;
    
    % Distance Scaling
    r = sqrt(Rjb.^2 + h(i)^2);
    Fd = (c1(i) + c2(i) * (M - mref)) .* log(r/rref) + (c3(i) + Dc3(i)) * (r - rref);
    
    % Site Amplification
    lnFlin = c(i)*log(Vc(i)/vref)*ones(size(Vs30));
    I=(Vs30 <= Vc(i));
    lnFlin(I) = c(i)*log(Vs30(I)/vref);
    
    f2 = f4(i)*(exp(f5(i)*(min(Vs30,760) - 360)) - exp(f5(i)*(760 - 360)));
    Fmnl = e00(inl)*U + e01(inl)*S + e02(inl)*N + e03(inl)*R + e06(inl)*(M - mh(inl));
    I=(M <= mh(inl));
    Fmnl(I) = e00(inl)*U + e01(inl)*S + e02(inl)*N + e03(inl)*R + e04(inl)*(M(I)-mh(inl)) + e05(inl)*(M(I)-mh(inl)).^2;
    rnl = sqrt (Rjb.^2 + h(inl)^2);
    Fdnl = (c1(inl) + c2(inl)*(M - mref)).*log(rnl/rref) + (c3(inl) + Dc3(inl))*(rnl - rref);
    PGArock = exp(Fmnl + Fdnl);
    lnFnl = f1(i) + f2.*log((PGArock + f3(i))/f3(i));
    if region == 0
        delta_z1 = 0.;
    elseif region == 1
        mu_z1 = (-7.15/4)*log((Vs30^4 + 570.94^4)/(1360^4 + 570.94^4)) - log(1000);
        delta_z1 = z1 - mu_z1;
    elseif region == 2 || region == 3
        mu_z1 = (-5.23/2)*log((Vs30^2 + 412.39^2)/(1360^2 + 412.39^2)) - log(1000);
        delta_z1 = z1 - mu_z1;
    end
    if T < 0.65
        Fdz1 = 0.;
    elseif T >= 0.65 && delta_z1 <= (f7(i)/f6(i))
        Fdz1 = f6(i)*delta_z1;
    elseif T >= 0.65 && delta_z1 > (f7(i)/f6(i))
        Fdz1 = f7(i);
    end
    
    Fs = lnFlin + lnFnl + Fdz1;
    % Aleatory Uncertainty
%     if M <= 4.5
%         tau = t1(i);
%         phiM = phi1(i);
%     elseif M > 4.5 && M < 5.5
%         tau = t1(i) + (t2(i) - t1(i))*(M - 4.5);
%         phiM = phi1(i) + (phi2(i) - phi1(i))*(M - 4.5);
%     elseif M >= 5.5
%         tau = t2(i);
%         phiM = phi2(i);
%     end
    tau = t1(i);
    phiM = phi1(i);
%     if Rjb <= R1(i)
%         phiMR = phiM;
%     elseif Rjb > R1(i) && Rjb <= R2(i)
%         phiMR = phiM + DfR(i)*(log(Rjb/R1(i))/log(R2(i)/R1(i)));
%     elseif Rjb > R2(i)
%         phiMR = phiM + DfR(i);
%     end
    phiMR = phiM;
%     elseif Rjb > R1(i) 
%     if Vs30 >= v2
%         phi = phiMR;
%     elseif Vs30 >= v1 && Vs30 <= v2
%         phi = phiMR - DfV(i)*(log(v2/Vs30)/log(v2/v1));
%     elseif Vs30 <= v1
%         phi = phiMR - DfV(i);
%     end
    phi = phiMR;
    
    % Median Ground Motion
    lnSa = Fm + Fd + Fs;
    Sa = exp(lnSa); % cm/s2
    % Standard Deviation
    sigma = sqrt(phi^2 + tau^2);
end