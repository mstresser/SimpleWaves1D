function visOutput(SWOut)
%  Written by: Michael Stresser, 11/1/2019
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
%% Output
figure('Position',[0 0 800 800]);
ax1=subplot(411);
plot(SWOut.x,SWOut.H_rms,'Color',[70,130,180]./255,'LineWidth',2);
hold on
plot(SWOut.x,sqrt(2)*SWOut.H_rms,':','Color',[70,130,180]./255,'LineWidth',2);
hold on
grid on

ylim([0 sqrt(2)*SWOut.H_rms(1)+.5])
legend('H_{rms}','H_s','Location','South')
xlabel 'X [m]'
ylabel('Wave Height [m]')

ax2=subplot(412);
plot(SWOut.x,SWOut.Qb,'Color',[70,130,180]./255,'LineWidth',2);
ylim([0 1]);
grid on
xlabel 'X [m]'
ylabel('Frac. Breaking [-]')

ax3=subplot(413);
plot(SWOut.x,SWOut.V,'Color',[70,130,180]./255,'LineWidth',2);
grid on
xlabel 'X [m]'
ylabel('Alongsh. Current [m/s]')

ax4=subplot(414);
plot(SWOut.x,SWOut.setup+SWOut.wl,'-','Color',[50,110,150]./255,'LineWidth',1);
hold on 
plot([0,max(SWOut.x)],[SWOut.wl SWOut.wl],'Color',[70,130,180]./255,'LineWidth',2);
plot([0,max(SWOut.x)],[0 0],'k:');

hold on
plot(SWOut.x,SWOut.z,'Color',[139,69,19]./255,'LineWidth',2);
grid on
xlabel 'X [m]'
ylabel 'Elevation z [mMSL]'

linkaxes([ax1 ax2 ax3 ax4],'x')


end

