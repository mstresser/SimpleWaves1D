function [setup] = wavesetup(d,Sxx)
%WAVESETUP Calculate wave induced setup 
%
%
%
%  Written by: Michael Stresser, 12/1/2019
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

% constants
rho_w = 1025;
g = 9.81;

d = d(1:end-1);



dSxxdx = diff(Sxx);

deta = - (rho_w*g.*d).^-1 .* dSxxdx; % assumption: setup << d

for ii = 1 : length(d)
   setup(ii,1)=0.0+deta(ii,1); % wave setup in before first cell is not
                               % known and, hence, set to 0; 
end
setup(length(d)+1,1)=0; % this might be not correct, but who cares, it's the last cell    

