function k=wavenum(w,h)
% y=wavenum(w,h): FUNCTION for the calculation of the wavenumber.
%                   The dispertion relation is solved using a 
%                   polynomial approximation.
%                   w, wave radial frequency; w=2*pi*f;.
%                   h, water depth (in m).
%
%       George Voulgaris, SUDO, 1992
% Modified function by Urs Neumeier: http://neumeier.perso.ch/matlab/waves.html
% Based on polynomial approximation from Hunt, J. N. 1979. “Direct Solution of Wave Dispersion Equation,” ASCE Jour. Waterw., Port, Coastal and Ocean Engr., Vol 105, pp 457-459 suggested by George Voulgaris, University of South Carolina 
f=w/2/pi;
tmp1=(w.^2)*h/9.81;
tmp2=tmp1+(1.0+0.6522*tmp1+0.4622*tmp1.^2+0.0864*tmp1.^4+0.0675*tmp1.^5).^(-1);
tmp3=sqrt(9.81*h.*tmp2.^(-1))./f;
k=2*pi*tmp3.^(-1);