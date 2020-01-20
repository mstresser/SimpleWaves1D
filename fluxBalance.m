function [H_rms,E,F,D,Qb] = fluxBalance(dx,d,cg,H_rms_0,T_rep,B,gamma,formulation)
%FLUXBALANCE Energy Flux Balance
%   Solves the stationary wave energy flux balance equation
%
%
%
%  Written by: Michael Stresser, 11/1/2019
%
%
% Copyright (c) 2017 Michael Stresser
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
nx = length(d);

d(d<0.3)=NaN; % 30 cm is minimum water depth 
              % (this should better be dependend on the wavelength in future)

% constants
rho_w = 1025;
g = 9.81;

% initialize output vectors
H_rms = nan(nx,1);
E = nan(nx,1);
F = nan(nx,1);
D = nan(nx,1);
Qb = nan(nx,1);



EO = 1/8 * rho_w * g * H_rms_0^2;
for ii = 1:(nx-1)
    if ii==1
        F(ii,1) = EO * cg(ii,1);
    end  
    
    E(ii,1)= F(ii,1)/cg(ii,1); % calculate wave energy
    if E(ii,1)<0; E(ii,1)=0; end % calculate wave energy
    
    H_rms(ii,1)=sqrt(8*E(ii,1)/rho_w/g); % calculate wave height
    
    [Dtmp,Qbtmp] = breaking(H_rms(ii,1),T_rep,d(ii,1),B,gamma,formulation);
    D(ii,1)=Dtmp;
    Qb(ii,1)=Qbtmp;
    F(ii+1,1)= F(ii,1) - D(ii,1)*dx;
    
end

