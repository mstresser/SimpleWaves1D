function [SWOut] = runSimpleWaves1D(x,z,wl,H_rmsO,T_rep,thetaO,formulation,gamma,B) 
%%runSimpleWaves1D
%
% TODO: describe input paratmeters
%
%
% Written by: Michael Stresser, 11/1/2019
%
%
% Copyright (c) 2019 Michael Stresser
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
% initialize output
SWOut=struct;

% constants
rho_w = 1025;
g = 9.81;

dx=x(2)-x(1); % compute grid spacing
d = wl-z; % compute water depth
d(d<0)=NaN; % negative water depth is not possible

% for stability
if thetaO>70; return; end
dmin = 0.05;
d(d<dmin)=dmin;

%% compute wave phase and group speed
w = 2*pi/T_rep;
k = wavenum(w,d); % frequency stays the same (no current)
cp= w./k;      % calculate phase speed
cg = cp .* (0.5 + k.*d./(sinh(2*k.*d))); % calculate group speed

%% compute wave direction using snells law
theta = asind((cp./cp(1)).*sind(thetaO));

%% projections of wave propagation parameters 
cp_x = cp .* cosd(theta);
cg_x = cg .* cosd(theta);
cp_y = cp .* sind(theta);
cg_y= cg .* sind(theta);
k_x = k .* cosd(theta);
k_y = k .* sind(theta);
        

%%
[H_rms,E,F,D,Qb] = fluxBalance(dx,d,cg_x,H_rmsO,T_rep,B,gamma,formulation);
[Er,Dr] = rollerBalance(dx,D,cp_x);


%% compute radiation stresses
S = (2*(cg./cp)-0.5).*E; % airy theory radiation stress 
Sxx = S.*cosd(theta).^2;
Sxy = S.*cosd(theta).*sind(theta);
Syy = S.*sind(theta).^2;

%% compute wave induced setup
[setup] = wavesetup(d,Sxx);

%% compute wave induced force and longshore current
Fy = (Dr./cp) .* sind(theta);
c_d = 0.003; % friction coefficient (tunable)
V = sqrt(abs(Fy./rho_w./c_d)); % heuristical equation based on friction only  

%% fill output struct
SWOut.d=d;
SWOut.z=z;
SWOut.wl=wl;
SWOut.x=x;
SWOut.H_rms=H_rms;
SWOut.E=E;
SWOut.F=F;
SWOut.D=D;
SWOut.Sxx=Sxx;
SWOut.Sxy=Sxy;
SWOut.Syy=Syy;
SWOut.setup=setup;
SWOut.Qb=Qb;
SWOut.Er=Er;
SWOut.Dr=Dr;
SWOut.Fy=Fy;
SWOut.V = V;
SWOut.cp = cp;
SWOut.cg = cg;
SWOut.cp_x = cp_x;
SWOut.cp_y = cp_y;
SWOut.cg_x = cg_x;
SWOut.cg_y = cg_y;
SWOut.k_x = k_x;
SWOut.k_y = k_y;
SWOut.theta = theta;
SWOut.theta0 = theta0;
SWOut.T_rep = T_rep;











