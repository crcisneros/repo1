% function ProcessRadiationComparison()
% This script is now just used to plot radiation data from CNR1 and CNR4
addpath                          c:\Speulderbos\Processing\MatlabProcess\functions\;
%%
load('c:\Speulderbos\Data\CNR4\MATFILE\CNR4_Rn')
load('C:\Speulderbos\Data\Met_AVG\05MATFILE\MetAVG_RN35m')
%%
% PLOT Rs_in

plotRadiation(t_T2,t_CNR4,Rs_in35m,Rs_in45m)

%%
plotRadiation(t_T2,t_CNR4,Rs_out35m,Rs_out45m)

%%

plotRadiation(t_T2,t_CNR4,Rl_in35m_c,Rl_in45m_c)
plotRadiation(t_T2,t_CNR4,Rl_out35m_c,Rl_out45m_c)

%%
figure()
ax1=subplot(2,2,1);
hold on
plot(t_T2, Rs_in35m, '.-g')
plot(t_CNR4, Rs_in45m, '.-b')
legend({'Rs in35m', 'Rs in45m'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
set(gca,'xtick', datenum([2016 10 14 0 0 0]):datenum([0 0 0 6 0 0]):datenum([2016 11 01 23 59 0]),...
    'xlim', [datenum([2016 10 14 0 0 0]) datenum([2016 11 01 23 59 0])] );%'fontsize', 8
datetick('x', 'mm/dd/HH:MM' ,'keepticks')

ax2=subplot(2,2,2);
hold on
plot(t_T2, Rs_out35m, '.-g')
plot(t_CNR4, Rs_out45m, '.-b')
legend({'Rs out35m', 'Rs out45m'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'{"IsDistinguishedFolder":true,"FolderId":{"Id":"AQMkADAwATE0YjQwLWIyZmEtZWQ2ZC0wMAItMDAKAC4AAAOSs1EfLjT6QriXa066PfpSAQAcq0kHTuZSQY9J7CnMOdpBAAACAQwAAAA=","ChangeKey":"AQAAABYAAAAcq0kHTuZSQY9J7CnMOdpBAAAqiovf"},"DragItemType":2}
set(gca,'xtick', datenum([2016 10 14 0 0 0]):datenum([0 0 0 6 0 0]):datenum([2016 11 01 23 59 0]),...
    'xlim', [datenum([2016 10 14 0 0 0]) datenum([2016 11 01 23 59 0])] );%'fontsize', 8
datetick('x', 'mm/dd/HH:MM' ,'keepticks')

ax3=subplot(2,2,3);
hold on
plot(t_T2, Rl_in35m_c, '.-g')
plot(t_CNR4, Rl_in45m_c, '.-b')
legend({'Rl in35m', 'Rl in45m'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
set(gca,'xtick', datenum([2016 10 14 0 0 0]):datenum([0 0 0 6 0 0]):datenum([2016 11 01 23 59 0]),...
    'xlim', [datenum([2016 10 14 0 0 0]) datenum([2016 11 01 23 59 0])] );%'fontsize', 8
datetick('x', 'mm/dd/HH:MM' ,'keepticks')

ax4=subplot(2,2,4);
hold on
plot(t_T2, Rl_out35m_c, '.-g')
plot(t_CNR4, Rl_out45m_c, '.-b')
legend({'Rl out35m', 'Rl out45m'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'

linkaxes([ax1,ax2,ax3,ax4],'xy')
set(gca,'xtick', datenum([2016 10 14 0 0 0]):datenum([0 0 0 6 0 0]):datenum([2016 11 01 23 59 0]),...
    'xlim', [datenum([2016 10 14 0 0 0]) datenum([2016 11 01 23 59 0])] );%'fontsize', 8
datetick('x', 'mm/dd/HH:MM' ,'keepticks')

 