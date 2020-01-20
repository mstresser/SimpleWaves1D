%% main program SIMPLEWAVE1D
%
%
% Written by: Michael Stresser, 11/1/2019
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
%%
clear; clc;

%% user input
dx=10; % horizontal grid spacing
x = (0:dx:1500)'; % x grid (must be equidistant)
wl=1.62; % water level
%z = -15 + (1/80).*x;
bathy=load('bathy.mat'); % original bathymetry
z = interp1(bathy.x,bathy.z,x); % re-interpolate bathymetry
H_rms_0 = 2.3; % root-mean-square wave height at boundary  
T_rep=10; % representative wave frequency
theta0 = 10; % wave direction (with respect to cross-shore direction) 
% select the wave breaking parameterization: 
% options:                                  defaults:   
%'BJ' (Battjes and Janssen, 1978)           gamma=0.78 , B=1  
%'JB' (Janssen and Battjes, 2007)           gamma=0.39+0.56*tanh(33*(H_rms_0/(1.56*T_rep.^2))); B=1
%'TGeq20','TGeq21' (Thornton and Guza,1983) gamma=0.42 , B=1
%'BHBW' (Baldock et. al, 1998)              gamma=0.39+0.56*tanh(33*(H_rms_0/(1.56*T_rep.^2))); B=1
%'CK' (Chawla and Kirby, 2002)              gamma=0.6 , =0.4
%'FA' (Filipot and Ardhuin, 2012) gamma=0.42 , B=0.185
formulation='FA'; 
gamma=0.42;
B=0.185;

%% run simplewaves1d
[SWOut] = runSimpleWaves1D(x,z,wl,H_rms_0,T_rep,theta0,formulation,gamma,B);

%% visualize output
visOutput(SWOut);



