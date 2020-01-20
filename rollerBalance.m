function [Er,Dr] = rollerBalance(dx,D,cp)
%ROLLERBALANCE Roller Energy Flux Balance 
%   Solves the stationary roller energy flux balance equation
%
%
%
%  Written by: Michael Stresser, 12/1/2019
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
nx = length(D);

% constants
rho_w = 1025;
g = 9.81;


for ii = 1:(nx-1)
    if ii==1
        Fr(ii,1) = 0; % not sure if it is correct to assume Fr=0 in the first cell
    end
    
%     Fr(ii,1) = max([Fr(ii,1),0]); % negative roller flux is not allowed 
    
    Er(ii,1)= Fr(ii,1)/cp(ii,1);      % calculate roller energy    
    if Er(ii,1)<=0; Er(ii,1)=0; Fr(ii,1)=0; end % set flux to zero if Er is zero
   
    beta = 0.1; % slope coefficient for roller model
    Dr(ii,1) = 2*beta*g/cp(ii,1)*Er(ii,1);
    
    
    Fr(ii+1,1)= Fr(ii,1) - Dr(ii,1)*dx + D(ii,1)*dx; 

    if ii == (nx-1) % last cell gets previous cell value for Er and Dr
                    % there might be a more elegant solution
        Er(ii+1,1)=Er(ii,1);
        Dr(ii+1,1) = Dr(ii,1);
    end
end