%% Scrip to read CNR4 files from CR5000 logger

function ImpCNR4v01()
path                               = 'c:\Speulderbos\Data\CNR4\';
addpath                   c:\Speulderbos\Processing\MatlabProcess\functions\;

files                      = dir(fullfile(path,'*.dat'));

t_CNR4                     = arrayfun(@(x) ReadTimeCNR4(fullfile(path,(x.name)),4),files, 'UniformOutput', false);
t_CNR4                     = vertcat(t_CNR4{:});

fcols                      = arrayfun(@(x) dlmread(fullfile(path,(x.name)),',',4,1),files, 'UniformOutput', false);
fcols                      = vertcat(fcols{:});


%%
%%%%%%%% IT IS NOT NECESSARY TO CHANGE THE TIME FIELD %%%%%%%
%% we need to delay the time in order to match with CR23x Logger
% it is about -13min30sec
t_CNR4                     =t_CNR4-datenum([0 0 0 0 13 30]);
%% Header "TIMESTAMP",(not count)
% "RECORD","logger_temp",
%3 "short_up_Avg",%4 "short_dn_Avg",%5 "long_up_Avg",%6 "long_dn_Avg",
%7 "cnr4_T_C_Avg",%8 "cnr4_T_K_Avg",%9 "long_up_corr_Avg",%10 "long_dn_corr_Avg",
%11 "Rs_net_Avg",12"Rl_net_Avg",13"albedo_Avg",14"Rn_Avg"
%% Assign variable names
% RECORD          1
% logger_temp	2
% 	    3
fcols(abs(fcols)>6999)                                  = NaN;
Rs_in45m                     =fcols(:,3);%short_up_Avg                 
Rs_out45m                    =fcols(:,4);
Rl_in45m                     =fcols(:,5);
Rl_out45m                    =fcols(:,6);
cnr4_T_C_Avg                 =fcols(:,7);
cnr4_T_C_Avg(abs(cnr4_T_C_Avg)>100)                    =NaN;
% cnr4_T_K_Avg	8   
Rl_in45m_c            =fcols(:,9);
Rl_out45m_c            =fcols(:,10);
Rl_in45m_c(abs(Rl_in45m_c)>1000)            =NaN;            
Rl_out45m_c(abs(Rl_out45m_c)>1000)            =NaN;
Rs_net45m                  =fcols(:,11);
Rl_net45m                  =fcols(:,12);
albedo_45m                  =fcols(:,13);

Rn_45m                      =fcols(:,14);%Rn_Avg
Rn_45m(abs(Rn_45m) ==9999)                            =NaN;
 
%% 30 min average
[Rn_45m_avg]                 = avg_xmin_v3(t_CNR4,Rn_45m,30);
[Rs_in45m_avg]               = avg_xmin_v3(t_CNR4, Rs_in45m ,30);
[Rs_out45m_avg]              = avg_xmin_v3(t_CNR4, Rs_out45m ,30);

%% Saving
save('c:\Speulderbos\Data\CNR4\MATFILE\CNR4_Rn',...
't_CNR4',...
    'Rs_in45m','Rs_out45m',...
    'Rl_in45m_c','Rl_out45m_c',...
    'Rn_45m', 'Rn_45m_avg',...
    'Rs_in45m_avg','Rs_out45m_avg','cnr4_T_C_Avg')
% load('c:\Speulderbos\Data\CNR4\MATFILE\CNR4_Rn')

%% PLots CNR4
figure()
% subplot(211)
hold on
plot(t_CNR4, Rs_in45m    ,'xr')
plot(t_CNR4, Rs_out45m   ,'xb')   
plot(t_CNR4, Rl_in45m_c  ,'xg')
plot(t_CNR4, Rl_out45m_c   ,'xy')   
plot(t_CNR4, Rn_45m, 'xk')
legend({'Rs(in)','Rs(out)','Rl(in)','Rl(out)','RnCNR4'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
%     set(gca,'xtick', datenum([2016 03 01 0 0 0]):datenum([0 0 5 0 0 0]):datenum([2016 03 05 0 0 0]),'fontsize', 8);
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')

hold off   

%% PLot Temperatures
% figure()
% hold on
% plot(tfile, cnr4_T_C_Avg,'.r')
% plot(tfile,TCNR1_35m_AVG,'.b')   
% legend({'T CNR4','TCNR1'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
% %     set(gca,'xtick', datenum([2016 03 01 0 0 0]):datenum([0 0 5 0 0 0]):datenum([2016 03 05 0 0 0]),'fontsize', 8);
% datetick('x','mmm/dd','keepticks')  
%     hold off   

%%  ////////////////////// calculating the difference//////////////////////////////
%%
% Dif_Rs_in                            =Rs_in35m_AVG - short_up_Avg;
% nanmean(Dif_Rs_in)
% nanmax(Dif_Rs_in)
% nanmin(Dif_Rs_in)
% figure
%  plot(Dif_Rs_in)
% %%
% Dif_Rs_out                           =Rs_out35m_AVG - short_dn_Avg;
% nanmean(Dif_Rs_out)
% nanmax(Dif_Rs_out)
% nanmin(Dif_Rs_out)
% figure
%  plot(tfile,Dif_Rs_out)
%  datetick('x')
% %% Rl_in35m_AVG -->Rli
% Dif_Rl_in                           =Rli - long_up_corr_Avg;
% nanmean(Dif_Rl_in)
% nanmax(Dif_Rl_in)
% nanmin(Dif_Rl_in)
% figure
%  plot(tfile, Dif_Rl_in)
%  datetick('x')
% %% Rl_out35m_AVG -->Rlo
% Dif_Rl_out                           =Rlo - long_dn_corr_Avg;
% nanmean(Dif_Rl_out)
% nanmax(Dif_Rl_out)
% nanmin(Dif_Rl_out)
% figure
% 
% plot(tfile, Dif_Rl_out)
%  datetick('x')
% %% Rl_out35m_AVG -->Rlo
% Dif_Rn                          =Rn_CNR1 - Rn_CNR4;
% nanmean(Dif_Rn)
% nanmax(Dif_Rn)
% nanmin(Dif_Rn)
% figure
% plot(tfile, Dif_Rn)
%  datetick('x')
% 
% %% Rn avg
% 
% [Rn_CNR130m]                 = avg_xmin_v1(tfile,Rn_CNR1,30);
% [Rn_CNR430m]                 = avg_xmin_v1(tfile,Rn_CNR4,30);
% Dif_Rn30                     = Rn_CNR130m(:,2)-Rn_CNR430m(:,2);
%  
% %%
% t_inicial         = datenum([2016 05 14 00 00 00]);
% t_final           = datenum([2016 05 17 24 00 00]);
% ttick           = datenum([0 0 0 3 0 0]);%[yyyy mm dd hh mm ss]
% 
% figure
% hold on
% plot(tfile, Dif_Rs_in,'r')
% plot(tfile, Dif_Rs_out,'g')
% plot(tfile, Dif_Rl_in,'b') 
% plot(tfile, Dif_Rl_out,'k')
% % plot(Rn_CNR130m(:,1), Dif_Rn30,'k')
% figure
% hold on
% plot(Rn_CNR130m(:,1), Rn_CNR130m(:,2),'k')
% plot(Rn_CNR430m(:,1), Rn_CNR430m(:,2),'r')
% legend({'Dif Rs in' 'Dif Rs out' 'Dif Rl in' 'Dif Rl out'})
%     set(gca,'xtick', t_inicial:ttick:t_final,'FontSize',7);%'xLim',[t_inicial  t_final],
%  datetick('x',' HH:MM','keepticks')%'mm/dd HH:MM''keeplimits'
end