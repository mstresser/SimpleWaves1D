function [D,Qb] = breaking(H_rms,T_rep,d,B,gamma,formulation)
%BREAKING Wave Breaking Parameterization
%   Computes wave breaking dissipation at one single point
%
%
%
%  Written by: Michael Stresser, 10/1/2019
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

rho_w = 1025;
g=9.81;


w = 2*pi/T_rep;
k = w2k(w,0,d);

H = 0:0.1:20;  % wave height vector to compute the Rayleigh distribution
dH = H(2)-H(1);
Pr = (2*H / (H_rms^2)) .* exp(-(H/H_rms).^2); %Rayleigh distribution
   
formulations = {'BJ','JB','TGeq20','TGeq21','BHBW','CK','FA'};
if ~any(strcmp(formulations,formulation))
    errtext = sprintf('"%s" breaking parameterization is not available!',formulation);
    error(errtext);
end


switch formulation
    case 'BJ'  % Battjes and Janssen (1978)    
        % Qb as computed in SWAN
        beta = H_rms/(gamma*d);
        if beta <= 0.5
            QO = 0;
        elseif (beta > 0.5) && (beta <=1)
            QO = (2*beta-1)^2;
        end
        B2 = beta*beta;
        
        if beta <=0.2
            Qb=0;
        elseif (beta > 0.2) && (beta < 1)
            Z = exp((QO-1.)/B2);
            Qb = QO - B2 * (QO - Z)  / (B2 - Z);
        else
            Qb = 1;
        end
        
        D = (1/4) * B * (1/T_rep) * rho_w * g * (gamma*H_rms)^2 * Qb ;
        
    case 'BHBW' % Baldock et al (1998) 
       H_b = (0.88/k) * tanh((gamma/0.88) * k * d);
       
       % implicit formulation for Qb
        R = H_b/H_rms;
        Qb  = exp(-(R)^2);
        
        D = (1/4) * rho_w * g * (1/T_rep) * B * (H_rms^2+H_b^2) * Qb; % from paper
                
    case 'JB' % Janssen and Battjes (2007)
        H_b = (0.88/k) * tanh((gamma/0.88) * k * d); % Miche's criterion 1944
       
        % implicit formulation for Qb
        R = H_b/H_rms;
        Qb  = exp(-(R)^2);
        
        D = (3*sqrt(pi)/16) * B * rho_w * g * ( (H_rms.^3 )./ d) * (1/T_rep) ...
            *(1 + ( 4/(3*sqrt(pi)) *( R^3 + (3/2)*R ) * exp(-R^2)-erf(R)));
      
    case 'JB_XB' % Janssen and Battjes (2007) as implemented in XBEACH
        % Note: the result is exactly the same as JB, but Qb is defined
        % differently
        
        H_b = (0.88/k) * tanh((gamma/0.88) * k * d); % Miche's criterion 1944
        
        R = H_b/H_rms;
        Qb = 1 + ( 4/(3*sqrt(pi)) *( R^3 + (3/2)*R ) * exp(-R^2)-erf(R));
        
        D = (3*sqrt(pi)/16) * B * rho_w * g * ( (H_rms.^3 )./ d) * (1/T_rep) * Qb;
        
        
    case 'TGeq21' % Thornton and Guza (1983), their eq. 21
        H_b = (0.88/k) * tanh((gamma/0.88) * k * d); % Miche's criterion 1944

        % eq. 21
        n=2;
        %W = ((H_rms / (gamma*d)).^n) .* (1 - exp(-((H./(gamma*d)).^2))); % orig
        W = ((H_rms / H_b).^n) .* (1 - exp(-((H./H_b).^2))); 
        
        W(W>1)=1.0;
        
        Pb = Pr .* W;
        Qb = sum(Pb*dH);
        
        % orig inal formulation
        %         D = 3*sqrt(pi)/16 * rho_w * g * B^3 * (1/T_rep) * H_rms^5 / (gamma^2 ...
        %             *d^3) * (   1 -   1 /  (1 + (H_rms/(gamma*d))^2 )^(5/2)  );
        
        D = 3*sqrt(pi)/16 * rho_w * g * B^3 * (1/T_rep) * H_rms^3 / d ...
            * (H_rms^2 / H_b^2) * (   1 -   1 /  (1 + (H_rms^2/H_b^2) )^(5/2)  );
        
    case 'TGeq20'  % Thornton and Guza (1983), their eq. 20
        H_b = (0.88/k) * tanh((gamma/0.88) * k * d); % Miche's criterion 1944

        % eq. 20
        n=4;
        W = (H_rms / H_b).^n;
%         W = (H_rms / (gamma*d)).^n; % orig
        
        W(W>1)=1.0;
        
        Pb = Pr .* W;
        Qb = sum(Pb*dH);
        
        D = 3*sqrt(pi)/16 * rho_w * g * B^3 * (1/T_rep) / H_b^4 / d * H_rms^7;
       
%         D = 3*sqrt(pi)/16 * rho_w * g * B^3 * (1/T_rep) / gamma^4 / d^5 * H_rms^7; % orig
        
    case 'CK' % Chawla and Kirby (2002)
        W = ((k*H_rms)/(gamma*tanh(k*d)))^2 * (1-exp(-((k.*H)/(gamma*tanh(k*d))).^2));
        W(W>1)=1.0;
        Pb = Pr .* W;
        Qb = sum(Pb*dH);
        
        D = 3 * B * rho_w / (32*sqrt(pi)) * sqrt((g*k).^3 / (tanh(k*d))) * ...
            (k / (gamma*tanh(k*d)))^2 * H_rms^5 * ...
            (1 - (1 + (k*H_rms / (gamma * tanh(k*d)))^2 ) )^(-5/2);               
        
    case 'FA' % Filipot and Ardhuin (2012)
             
        beta_r =(k*H_rms)/tanh(k*d);
        beta = (k.*H)./tanh(k*d);
        %                 beta_tlin = 0.88;
        
        % beta tilde as tunable parameter FA12
        beta_tilde = gamma;
        
        a = 1.5; % determined in FAB10 as best fit
        p = 4; % fitted best to all datasets in FAB10
        W = a *((beta_r / beta_tilde).^2) .* (1 - exp(-((beta./beta_tilde).^p)));
        W(W>1)=1.0;
        
        
        Pb = Pr .* W;
        Qb = sum(Pb*dH);
        
        
        p=1.5; % from the paper 
        D = (1/4)  * rho_w * g  * (B * H_rms/(tanh(k*d))^p)^3 * sqrt((g*k)/tanh(k*d)) * Qb;
        L = 2*pi/k;
        D = D/L;
             
end

%% D is per definiition >= 0;
D = max([D,0]);

