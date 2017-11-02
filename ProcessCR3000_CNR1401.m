%% Scrip to read AVG.txt files
% path    = 'C:\Speulderbos\Data\Met_AVG\avg_ready\';
% path    = 'C:\Speulderbos\Data\Met_AVG\newready\';
path                               = 'c:\Speulderbos\Data\CR3000\USB\EditedNAN\';
addpath                               c:\Speulderbos\Processing\MatlabProcess\auxscripts\;

files      =      dir(fullfile(path,'*.dat'));

tfile    =       [];

for i = 1:length(files)
    
    F(i).name             =       files(i).name; %files_trh(i).name; 
    
    F(i).data             =       textscan(fopen(fullfile(path,(F(i).name))), '%q %*[^\n]',...
                                    'HeaderLines',4,'delimiter', ',');%   
    fclose('all'); 
    fmtdate               =       'yyyy-mm-dd HH:MM:SS';
    tnum_R                =       datenum(F(i).data{1,1},fmtdate);
    tfile                 =      [tfile;tnum_R]; 
end
datevec_tfile                      =    datevec(tfile);
year_vec                           =    datevec_tfile;
year_vec(:,2:6)                    =    0;   
year                               =    year_vec(:,1);
year_num                           =    datenum(year_vec);
% length(year)
%%
% The idea is to join all the edited files in one according to the identified columns

fcols    =       [];

for i=1 : length(files) 
    f(i).name                      =       files(i).name; 
    f(i).data                      =       dlmread(fullfile(path,(files(i).name)),',',4,1);
    fcols                           =       [fcols;f(i).data];

end

%% Assign variable names
% RECORD          1
% batt_volt_Min	2
% logger_temp	    3
fcols(abs(fcols)>9000)                                  = NaN;
short_up_Avg                 =fcols(:,4);
short_dn_Avg                 =fcols(:,5);
long_up_Avg                  =fcols(:,6);
long_dn_Avg                  =fcols(:,7);
cnr4_T_C_Avg                 =fcols(:,8);
cnr4_T_C_Avg(abs(cnr4_T_C_Avg)>100)                    =NaN;
% cnr4_T_K_Avg	9   
long_up_corr_Avg            =fcols(:,10);
long_dn_corr_Avg            =fcols(:,11);
long_up_corr_Avg(abs(long_up_corr_Avg)>1000)            =NaN;            
long_dn_corr_Avg(abs(long_dn_corr_Avg)>1000)            =NaN;
Rs_net_Avg                  =fcols(:,12);
Rl_net_Avg                  =fcols(:,13);
albedo_Avg                  =fcols(:,14);
Rn_CNR4                      =fcols(:,15);%Rn_Avg
Rn_CNR4(abs(Rn_CNR4) ==9999)                            =NaN;

%%
%////// CNR1 ////////////////////////////////
Rs_in35m_AVG                 =fcols(:,16); %CNR1_Avg(1)
Rs_out35m_AVG                =fcols(:,17);  %CNR1_Avg(2)
Rl_in35m_AVG                 =fcols(:,18);  %CNR1_Avg(3)
Rl_out35m_AVG                =fcols(:,19);  %CNR1_Avg(4)

RPT100_Avg                   =fcols(:,20);
TCNR1_35m_AVG                =fcols(:,21);%PT100_Avg	                 

Rli                         = Rl_in35m_AVG  +...
                              5.67E-8*((TCNR1_35m_AVG +273.15).^4); 

Rlo                         = Rl_out35m_AVG +...
                              5.67E-8*((TCNR1_35m_AVG +273.15).^4); 

Rn_CNR1                          = Rs_in35m_AVG-Rs_out35m_AVG +Rli- Rlo;



%% PLots CNR1
figure()
% subplot(211)
hold on
plot(tfile, Rs_in35m_AVG,'.r')
plot(tfile,Rs_out35m_AVG ,'.b')   
plot(tfile, Rli,'.g')
plot(tfile,Rlo,'.y')   
plot(tfile,Rn_CNR1, '.k')
% plot(Rn_avg30m(:,1),Rn_avg30m(:,2),'-k')
legend({'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn CNR1'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
%     set(gca,'xtick', datenum([2016 03 01 0 0 0]):datenum([0 0 5 0 0 0]):datenum([2016 03 05 0 0 0]),'fontsize', 8);
datetick('x','mmm/dd','keepticks')  
    hold off   

% PLots CNR4
figure()

hold on
plot(tfile, short_up_Avg                 ,'.r')
plot(tfile,short_dn_Avg                 ,'.b')   
plot(tfile, long_up_corr_Avg            ,'.g')
plot(tfile,long_dn_corr_Avg            ,'.y')   
plot(tfile,Rn_CNR4, '.k')
% plot(Rn_avg30m(:,1),Rn_avg30m(:,2),'-k')
legend({'Rs(in)','Rs(out)','Rl(in)','Rl(out)','RnCNR4'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
%     set(gca,'xtick', datenum([2016 03 01 0 0 0]):datenum([0 0 5 0 0 0]):datenum([2016 03 05 0 0 0]),'fontsize', 8);
datetick('x','mmm/dd','keepticks')  
    hold off   

%% PLot Temperatures
figure()
hold on
plot(tfile, cnr4_T_C_Avg,'.r')
plot(tfile,TCNR1_35m_AVG,'.b')   
legend({'T CNR4','TCNR1'},'FontSize',8,'FontWeight','bold') %'Rs(in)','Rs(out)','Rl(in)','Rl(out)','Rn'
%     set(gca,'xtick', datenum([2016 03 01 0 0 0]):datenum([0 0 5 0 0 0]):datenum([2016 03 05 0 0 0]),'fontsize', 8);
datetick('x','mmm/dd','keepticks')  
    hold off   

%%  ////////////////////// calculating the difference//////////////////////////////
 Dif_T                          = TCNR1_35m_AVG - cnr4_T_C_Avg;
nanmean(Dif_T )
nanmax(Dif_T )
nanmin(Dif_T)
figure
 plot(Dif_T)

%%
Dif_Rs_in                            =Rs_in35m_AVG - short_up_Avg;
nanmean(Dif_Rs_in)
nanmax(Dif_Rs_in)
nanmin(Dif_Rs_in)
figure
 plot(Dif_Rs_in)
%%
Dif_Rs_out                           =Rs_out35m_AVG - short_dn_Avg;
nanmean(Dif_Rs_out)
nanmax(Dif_Rs_out)
nanmin(Dif_Rs_out)
figure
 plot(tfile,Dif_Rs_out)
 datetick('x')
%% Rl_in35m_AVG -->Rli
Dif_Rl_in                           =Rli - long_up_corr_Avg;
nanmean(Dif_Rl_in)
nanmax(Dif_Rl_in)
nanmin(Dif_Rl_in)
figure
 plot(tfile, Dif_Rl_in)
 datetick('x')
%% Rl_out35m_AVG -->Rlo
Dif_Rl_out                           =Rlo - long_dn_corr_Avg;
nanmean(Dif_Rl_out)
nanmax(Dif_Rl_out)
nanmin(Dif_Rl_out)
figure

plot(tfile, Dif_Rl_out)
 datetick('x')
%% Rl_out35m_AVG -->Rlo
Dif_Rn                          =Rn_CNR1 - Rn_CNR4;
nanmean(Dif_Rn)
nanmax(Dif_Rn)
nanmin(Dif_Rn)
figure
plot(tfile, Dif_Rn)
 datetick('x')

%% Rn avg

[Rn_CNR130m]                 = avg_xmin_v1(tfile,Rn_CNR1,30);
[Rn_CNR430m]                 = avg_xmin_v1(tfile,Rn_CNR4,30);
Dif_Rn30                     = Rn_CNR130m(:,2)-Rn_CNR430m(:,2);
 
%%
t_inicial         = datenum([2016 05 14 00 00 00]);
t_final           = datenum([2016 05 17 24 00 00]);
ttick           = datenum([0 0 0 3 0 0]);%[yyyy mm dd hh mm ss]

figure
hold on
plot(tfile, Dif_Rs_in,'-*r')
plot(tfile, Dif_Rs_out,'g')
plot(tfile, Dif_Rl_in,'-*b') 
plot(tfile, Dif_Rl_out,'k')
%  plot(Rn_CNR130m(:,1), Dif_Rn30,'k')
datetick('x',' HH:MM','keepticks')%'mm/dd HH:MM''keeplimits'
%% figure
hold on
plot(Rn_CNR130m(:,1), Rn_CNR130m(:,2),'k')
plot(Rn_CNR430m(:,1), Rn_CNR430m(:,2),'r')
legend({'Dif Rs in' 'Dif Rs out' 'Dif Rl in' 'Dif Rl out'})
    set(gca,'xtick', t_inicial:ttick:t_final,'FontSize',7);%'xLim',[t_inicial  t_final],
 datetick('x',' HH:MM','keepticks')%'mm/dd HH:MM''keeplimits'
