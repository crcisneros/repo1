%Script to process data from the dataloger CR1000 located al 37 m
%in the tower of Speulderbos,(CR1000)
% Author Cesar Cisneros
%%V0.1
%Diferent tables were download using loggernet :
%Table Meteo for CS216 (digital sensors)
%TRH Analog mode sensors
%Rotronic(1-3) HC2-S3C03: RH1a, RH2a, RH3a, , T1a, T2a, T3a, Rense RH4a, T4a (a=analog)
%SN #1 61474819 #2 61474838 #3 61474837 #4 HT 732H26
%
%
%
%TRH Digital mode sensors
% CS215: T1d...3d, RH1d...3d (d=digital)
% Hht(m)Secti(m)logger label		Brand	Model
% 4	    0	10	T3d_AVG	RH3d_AVG	Campbell	CS215 (digital sensors)% % Later was replaced by another Rotronic sensor
% 16	10	20	T1a_AVG	RH1a_AVG	Rotronic	HC2-S3C03
% 24	20	28	T2a_AVG	RH2a_AVG	Rotronic	HC2-S3C03   2Analg Reference
% 32	28	35	T3a_AVG	RH3a_AVG	Rotronic	HC2-S3C03
% 38	35	42	T1d_AVG	RH1d_AVG	Campbell	CS215 (digital sensors)
% 46	42	46	T2d_AVG	RH2d_AVG	Campbell	CS215 (digital sensors)

%% /////////////////Setting the directories and files/////////////////////
addpath                    c:\Speulderbos\Processing\MatlabProcess\functions\
path2                     =      'c:\Speulderbos\Data\CR1000\03TRHDataReady\';
f                         =       dir(fullfile(path2,'*.dat'));

path3                      =      'c:\Speulderbos\Data\CR1000\02InterCData\';
coef                       =       fullfile(path3,'RHTcalibRefTRH2a.txt');

coef_val                   =      dlmread(coef,'\t');     
coef_val                   =      coef_val(:,1:6);        
%%If only one file is needed to be processed, then copy the name of the
%%file and replace '*.dat' (previous solution of change i=#of file doesn't work because alter the if condition i>1)

t_trh                      = [];  %t=time
data_trh                   = [];  %all thr records

for i= 1:length(f) 
    
    trh(i).name            =       f(i).name; %files_trh(i).name; 
    trh(i).abrir           =       fopen(fullfile(path2,(f(i).name)));  
    trh(i).time            =       textscan(trh(i).abrir, '%q %*[^\n]', 'HeaderLines', 4,'delimiter', ',');
    % 15 remaining cols were not included
    fclose('all');
    
    formatIn               =       'yyyy-mm-dd HH:MM:SS';

    tnum_trh               =       datenum(trh(i).time{1,1},formatIn);
    t_trh                  =       [t_trh; tnum_trh];
    
    trh(i).data            =       dlmread(fullfile(path2,(f(i).name)),',',4,1);
    data_trh               =      [data_trh; trh(i).data];
end
%% 
% size(data_trh)
 data_trh(abs(data_trh)>6000)        = NaN;
 
%% "Averages values every minute
T1d_Avg         = data_trh(:,2);
RH1d_Avg        = data_trh(:,3);
T2d_Avg         = data_trh(:,4);
RH2d_Avg        = data_trh(:,5);
T3d_Avg         = data_trh(:,6);
RH3d_Avg        = data_trh(:,7);
T1a_Avg         = data_trh(:,8);
RH1a_Avg        = data_trh(:,9);
T2a_Avg         = data_trh(:,10);
RH2a_Avg        = data_trh(:,11);
T3a_Avg         = data_trh(:,12);
RH3a_Avg        = data_trh(:,13);
T4a_Avg         = data_trh(:,14);
RH4a_Avg        = data_trh(:,15);

%% Ploting TRH vs Time 
% T1d_Avg,T2d_Avg,T3d_Avg,T1a_Avg,T2a_Avg,T3a_Avg,T4a_Avg
% RH1d_Avg,RH2d_Avg,RH3d_Avg,RH1a_Avg,RH2a_Avg,RH3a_Avg,RH4a_Avg
figure(1)
ax11=subplot(211);
plot(t_trh,[T1d_Avg,T2d_Avg,T3d_Avg,T1a_Avg,T2a_Avg,T3a_Avg])
legend({'T1d' 'T2d' 'T3d' 'T1a' 'T2a' 'T3a' },'FontSize',8,'FontWeight','bold')
datetick('x','mmm')
grid on
% plot(t_trh,T1d_Avg,'*r')
% datetick('x')
ax12=subplot(212);
plot(t_trh,[RH1d_Avg,RH2d_Avg,RH3d_Avg,RH1a_Avg,RH2a_Avg,RH3a_Avg])
legend({'RH1d' 'RH2d' 'RH3d' 'RH1a' 'RH2a' 'RH3a' },'FontSize',8,'FontWeight','bold')
datetick('x','mmm')
grid on
linkaxes([ax11,ax12],'x')
%%
% TRH          =mat_TRH(~any(isnan(mat_TRH),2),:); %taking out NAN values, if any value is NAN in any row the complete row is eliminated.

Traw        =[T1d_Avg,T2d_Avg,T3d_Avg,T1a_Avg,T2a_Avg,T3a_Avg];
RHraw       =[RH1d_Avg,RH2d_Avg,RH3d_Avg,RH1a_Avg,RH2a_Avg,RH3a_Avg];

Tcor        = Traw;
RHcor       = RHraw;

coef_T       = coef_val(:,1:3);
coef_RH       = coef_val(:,4:6);

for i = 1:3
   
    Tcor(:,i)   = Traw(:,i).^2 *coef_T(i,1)  +  Traw(:,i)*coef_T(i,2) + coef_T(i,3);
    RHcor(:,i)  = RHraw(:,i).^2*coef_RH(i,1)  + RHraw(:,i)*coef_RH(i,2) + coef_RH(i,3);
end

for i = 4:2:6;% 
    
  
    Tcor(:,i)   = Traw(:,i)*coef_T(i,2) + coef_T(i,3);
    RHcor(:,i)  = RHraw(:,i)*coef_RH(i,2) + coef_RH(i,3);   
end
% size(Tcor)
% size(RHcor)
% size(Traw)
% size(RHraw)

%% Saving Corrected by intercalibration Temperatures and RH as matrix

save('c:\Speulderbos\Data\CR1000\MATFILE\TempRelHum', 't_trh','RHcor','Tcor')
%% Export 30 min average corrected (except sensor at 4m)
% This is a function done to export in the same way that the raw data at 30 minutes

Export_TRHCorr(t_trh,RHcor,Tcor);

% load('c:\Speulderbos\Data\CR1000\MATFILE\TRH_30minAvg_corrected')

%% Plots T cor vs T raw
clear Traw RHraw
%------>>>>>>> check data to see when ne TRH4 analog was installed
% THe sensor TRH4a (Rotronic) started to work 19 Oct 2015


Traw        =[T1d_Avg,T2d_Avg,T4a_Avg,T1a_Avg,T2a_Avg,T3a_Avg];
RHraw       =[RH1d_Avg,RH2d_Avg,RH4a_Avg,RH1a_Avg,RH2a_Avg,RH3a_Avg];

% 4	    0	10	col 3    T3d_AVG	RH3d_AVG	(T4a_Avg RH4a_Avg )Campbell	CS215 (digital sensors)% % Later was replaced by another Rotronic sensor
% 16	10	20  col 4    T1a_AVG	RH1a_AVG	Rotronic	HC2-S3C03
% 24	20	28	col 5    T2a_AVG	RH2a_AVG	Rotronic	HC2-S3C03   2Analg Reference
% 32	28	35	col 6    T3a_AVG	RH3a_AVG	Rotronic	HC2-S3C03
% 37	35	42	col 1    T1d_AVG	RH1d_AVG	Campbell	CS215 (digital sensors)
% 46	42	46	col 2    T2d_AVG	RH2d_AVG	Campbell	CS215 (digital sensors)
%% Figure Tcor vs Traw
ttick        = datenum([0 0 0 0 1 0]);
t1=datenum([2015 09 27 12 45 0]);
t2=datenum([2015 09 27 13 30 0]);

figure()
ax21=subplot(211);
hold on
plot(t_trh,Tcor(:,2),'color','r')%'T2d(46m)'
plot(t_trh,Tcor(:,1),'color','g')%'T1d(37m)'
plot(t_trh,Tcor(:,6),'--b')%'T3a(32m)'
plot(t_trh,Tcor(:,5),'--k')%'T2a(24m)'
plot(t_trh,Tcor(:,4),'--y')%'T1a(16m)'
plot(t_trh,Tcor(:,3),'color',rand(1,3))%'T3d(4m)'% 'T3d(4m)'
legend({'T2d(46m)' 'T1d(37m)' 'T3a(32m)' 'T2a(24m)' 'T1a(16m)' 'T4a' },'FontSize',8,'FontWeight','bold')
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')
grid on

ax22=subplot(212);
hold on
plot(t_trh,Traw(:,2),'color','r')%'T2d(46m)'
plot(t_trh,Traw(:,1),'color','g')%'T1d(37m)'
plot(t_trh,Traw(:,6),'--b')%'T3a(32m)'
plot(t_trh,Traw(:,5),'--k')%'T2a(24m)'
plot(t_trh,Traw(:,4),'--y')%'T1a(16m)'
 plot(t_trh,Traw(:,3),'color',rand(1,3))%'T3d(4m)'% 'T3d(4m)'
legend({'T2d raw(46m)' 'T1d raw(37m)' 'T3a raw(32m)' 'T2a raw(24m)' 'T1a raw(16m)'  },'FontSize',8,'FontWeight','bold')
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')
grid on

linkaxes([ax21,ax22],'x')


%% Figure of relative Humidity
figure()
ax21=subplot(211);
hold on
plot(t_trh,RHcor(:,2),'color','r')%'T2d(46m)'
plot(t_trh,RHcor(:,1),'color','g')%'T1d(37m)'
plot(t_trh,RHcor(:,6),'--b')%'T3a(32m)'
plot(t_trh,RHcor(:,5),'--k')%'T2a(24m)'
plot(t_trh,RHcor(:,4),'--y')%'T1a(16m)'
plot(t_trh,RHcor(:,3),'color',rand(1,3))%'T3d(4m)'% 'T3d(4m)'
legend({'RH2d(46m)' 'RH1d(37m)' 'RH3a(32m)' 'RH2a(24m)' 'RH1a(16m)'  'Rh4a(m)'},'FontSize',8,'FontWeight','bold')
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')
grid on
% plot(t_trh,T1d_Avg,'*r')
% datetick('x')
ax22=subplot(212);
hold on
% plot(t_trh,[RHraw(:,2),RHcor(:,2)])
plot(t_trh,RHraw(:,2),'color','r')%'RH2d(46m)'
plot(t_trh,RHraw(:,1),'color','g')%'RH1d(37m)'
plot(t_trh,RHraw(:,6),'color','b')%'RH3a(32m)'
plot(t_trh,RHraw(:,5),'--k')      %'RH2a(24m)'
plot(t_trh,RHraw(:,4),'--y')      %'RH1a(16m)'
plot(t_trh,RHraw(:,3),'-.k')%'RH3d(4m)'% 'RH3d(4m)'
% legend({'RH2d raw(46m)' 'RH2d corr(46m)'  },'FontSize',8,'FontWeight','bold')
legend({'RH2d raw(46m)' 'RH1d raw(37m)' 'RH3a raw(32m)' 'RH2a raw(24m)' 'RH1a raw(16m)'  'RH4a raw (4 m)'},'FontSize',8,'FontWeight','bold')
%legend({'RH1d(37m)' 'RH2d(46m)' 'RH3d(4m)' 'RH1a(16m)' 'RH2a(24m)' 'RH3a(32m)' },'FontSize',8,'FontWeight','bold')
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')
grid on
linkaxes([ax21,ax22],'x')

%% Calculate average at %%%%%%%%10 min %%%%%%for one sensor only(TRHd2)
%----------------------------------^^^^----------------------
[RH46m]                           = avg_xmin_v3(t_trh,RHraw(:,2),10);
[T46m]                            = avg_xmin_v3(t_trh,Traw(:,2),10);

[es46m]                           = satvap(T46m(:,2));
t_10minTRH                        = T46m(:,1);
T46m_raw                          = T46m(:,2);
RH46m_raw                         = RH46m(:,2);
VPD46m                            = (1-RH46m_raw/100).*es46m;

save('c:\Speulderbos\Data\CR1000\MATFILE\VPD46mRaw', 't_trh','t_10minTRH','VPD46m','T46m_raw', 'RH46m_raw')
% load('c:\Speulderbos\Data\CR1000\MATFILE\VPD46mRaw', 't_trh','t_10minTRH','VPD46m','T46m_raw', 'RH46m_raw')

%% Calculate average at 30 min for one sensor only(TRHd2)
% [RH46m]                           = avg_xmin_v3(t_trh,RHraw(:,2),30);
% [T46m]                            = avg_xmin_v3(t_trh,Traw(:,2),30);
% % [es46m]                           = satvap(T46m(:,2));
% t_30minTRH                        = T46m(:,1);
% T46m_raw30min                          = T46m(:,2);
% RH46m_raw30min                         = RH46m(:,2);
% % VPD46m                            = (1-RH46m_raw/100).*es46m;
% 
% save('c:\Speulderbos\Data\CR1000\MATFILE\TRH46mRaw30min', 't_30minTRH','T46m_raw30min', 'RH46m_raw30min')
% load('c:\Speulderbos\Data\CR1000\MATFILE\TRH46mRaw30min', 't_30minTRH','T46m_raw30min', 'RH46m_raw30min')
%%  Create half hour series for raw temperature and Relative humidity 

% 4	    0	10	col 3    T3d_AVG	RH3d_AVG	Campbell	CS215 (digital sensors)% % Later was replaced by another Rotronic sensor
%                        T4a_Avg    RH4a_Avg    
% 16	10	20  col 4    T1a_AVG	RH1a_AVG	Rotronic	HC2-S3C03
% 24	20	28	col 5    T2a_AVG	RH2a_AVG	Rotronic	HC2-S3C03   2Analg Reference
% 32	28	35	col 6    T3a_AVG	RH3a_AVG	Rotronic	HC2-S3C03
% 37	35	42	col 1    T1d_AVG	RH1d_AVG	Campbell	CS215 (digital sensors)
% 46	42	46	col 2    T2d_AVG	RH2d_AVG	Campbell	CS215 (digital sensors)

%------------------------------------------------------------------

[RH04m]                             = avg_xmin_v3(t_trh,RHraw(:,3),30);
[T04m]                              = avg_xmin_v3(t_trh,Traw(:,3),30);
[RH16m]                             = avg_xmin_v3(t_trh,RHraw(:,4),30);
[T16m]                              = avg_xmin_v3(t_trh,Traw(:,4),30);
[RH24m]                             = avg_xmin_v3(t_trh,RHraw(:,5),30);
[T24m]                              = avg_xmin_v3(t_trh,Traw(:,5),30);
[RH32m]                             = avg_xmin_v3(t_trh,RHraw(:,6),30);
[T32m]                              = avg_xmin_v3(t_trh,Traw(:,6),30);
[RH37m]                             = avg_xmin_v3(t_trh,RHraw(:,1),30);
[T37m]                              = avg_xmin_v3(t_trh,Traw(:,1),30);
[RH46m]                             = avg_xmin_v3(t_trh,RHraw(:,2),30);
[T46m]                              = avg_xmin_v3(t_trh,Traw(:,2),30);

%Time
t_30minTRH                          = T04m(:,1);
%datevec( t_30minTRH(1))
%datevec( t_30minTRH(end))
I_matchFluxes                      = find(t_30minTRH>= datenum([2015 06 19 00 00 00]) & t_30minTRH< datenum([2016 10 31 23 30 00]));
t_30minTRH_Flx                     = T04m(I_matchFluxes,1);

% Temperature
T04m_raw30min                       = T04m(I_matchFluxes,2);
% Editing T04m, it was available only after  datenum([2015 10 20 0 00 0])
start_TRH04                             = datenum([2015 10 21 0 00 0]);
T04m_raw30min(t_30minTRH_Flx<start_TRH04)= nan;
T16m_raw30min                       = T16m(I_matchFluxes,2);
T24m_raw30min                       = T24m(I_matchFluxes,2);
T32m_raw30min                       = T32m(I_matchFluxes,2);
T37m_raw30min                       = T37m(I_matchFluxes,2);
T46m_raw30min                       = T46m(I_matchFluxes,2);

% Relative humidity
RH04m_raw30min                      = RH04m(I_matchFluxes,2);
RH04m_raw30min(t_30minTRH_Flx<start_TRH04)= nan;
RH16m_raw30min                      = RH16m(I_matchFluxes,2);
RH24m_raw30min                      = RH24m(I_matchFluxes,2);
RH32m_raw30min                      = RH32m(I_matchFluxes,2);
RH37m_raw30min                      = RH37m(I_matchFluxes,2);
RH46m_raw30min                      = RH46m(I_matchFluxes,2);
% [es46m]                           = satvap(T46m(:,2));
% VPD46m                            = (1-RH46m_raw/100).*es46m;

% figure
% hold on
% plot(t_30minTRH_Flx, T16m_raw30min,'b')
% plot(t_30minTRH_Flx, T04m_raw30min,'r')

save('c:\Speulderbos\Data\CR1000\MATFILE\TRH_30minAvg',...
                                    't_30minTRH_Flx',...
                                    'T04m_raw30min','RH04m_raw30min',...
                                    'T16m_raw30min','RH16m_raw30min',...
                                    'T24m_raw30min','RH24m_raw30min',...
                                    'T32m_raw30min','RH32m_raw30min',...
                                    'T37m_raw30min','RH37m_raw30min',...
                                    'T46m_raw30min','RH46m_raw30min')

% load('c:\Speulderbos\Data\CR1000\MATFILE\TRH_30minAvg')
% load('c:\Speulderbos\Data\CR1000\MATFILE\TRH_30minAvg','T37m_raw30min','RH37m_raw30min')
%% Old                                        
% save('c:\Speulderbos\Data\CR1000\MATFILE\TRH38mRaw30min', 't_30minTRH','T38m_raw30min', 'RH38m_raw30min')
% load('c:\Speulderbos\Data\CR1000\MATFILE\TRH38mRaw30min', 't_30minTRH','T38m_raw30min', 'RH38m_raw30min')
% save('c:\Speulderbos\Data\CR1000\MATFILE\TRH32mRaw30min', 't_30minTRH','T32m_raw30min', 'RH32m_raw30min')
%%


% 4	    0	10	col 3    T3d_AVG	RH3d_AVG	Campbell	CS215 (digital sensors)% % Later was replaced by another Rotronic sensor
%                        T4a_Avg    RH4a_Avg    
% 16	10	20  col 4    T1a_AVG	RH1a_AVG	Rotronic	HC2-S3C03
% 24	20	28	col 5    T2a_AVG	RH2a_AVG	Rotronic	HC2-S3C03   2Analg Reference
% 32	28	35	col 6    T3a_AVG	RH3a_AVG	Rotronic	HC2-S3C03
% 37	35	42	col 1    T1d_AVG	RH1d_AVG	Campbell	CS215 (digital sensors)
% 46	42	46	col 2    T2d_AVG	RH2d_AVG	Campbell	CS215 (digital sensors)

%------------------------------------------------------------------

[RH04m60]                             = avg_xmin_v3(t_trh,RHraw(:,3),60);
[T04m60]                              = avg_xmin_v3(t_trh,Traw(:,3),60);
[RH16m60]                             = avg_xmin_v3(t_trh,RHraw(:,4),60);
[T16m60]                              = avg_xmin_v3(t_trh,Traw(:,4),60);
[RH24m60]                             = avg_xmin_v3(t_trh,RHraw(:,5),60);
[T24m60]                              = avg_xmin_v3(t_trh,Traw(:,5),60);
[RH32m60]                             = avg_xmin_v3(t_trh,RHraw(:,6),60);
[T32m60]                              = avg_xmin_v3(t_trh,Traw(:,6),60);
[RH37m60]                             = avg_xmin_v3(t_trh,RHraw(:,1),60);
[T37m60]                              = avg_xmin_v3(t_trh,Traw(:,1),60);
[RH46m60]                             = avg_xmin_v3(t_trh,RHraw(:,2),60);
[T46m60]                              = avg_xmin_v3(t_trh,Traw(:,2),60);

%Time
t_60minTRH                          = T04m60(:,1);
%datevec( t_30minTRH(1))
%datevec( t_30minTRH(end))
I_matchFluxes60                      = find(t_60minTRH>= datenum([2015 06 19 00 00 00]) & t_60minTRH< datenum([2016 10 31 23 30 00]));
t_60minTRH_Flx                     = T04m60(I_matchFluxes60,1);

% Temperature
T04m_raw60min                       = T04m(I_matchFluxes60,2);
% Editing T04m, it was available only after  datenum([2015 10 20 0 00 0])
start_TRH04_60                             = datenum([2015 10 21 0 00 0]);
T04m_raw60min(t_60minTRH_Flx<start_TRH04_60)= nan;
T16m_raw60min                       = T16m60(I_matchFluxes60,2);
T24m_raw60min                       = T24m60(I_matchFluxes60,2);
T32m_raw60min                       = T32m60(I_matchFluxes60,2);
T37m_raw60min                       = T37m60(I_matchFluxes60,2);
T46m_raw60min                       = T46m60(I_matchFluxes60,2);

% Relative humidity
RH04m_raw60min                      = RH04m60(I_matchFluxes60,2);
RH04m_raw60min(t_60minTRH_Flx<start_TRH04_60)= nan;
RH16m_raw60min                      = RH16m(I_matchFluxes60,2);
RH24m_raw60min                      = RH24m(I_matchFluxes60,2);
RH32m_raw60min                      = RH32m(I_matchFluxes60,2);
RH37m_raw60min                      = RH37m(I_matchFluxes60,2);
RH46m_raw60min                      = RH46m(I_matchFluxes60,2);
% [es46m]                           = satvap(T46m(:,2));
% VPD46m                            = (1-RH46m_raw/100).*es46m;

% figure
% hold on
% plot(t_30minTRH_Flx, T16m_raw30min,'b')
% plot(t_30minTRH_Flx, T04m_raw30min,'r')

save('c:\Speulderbos\Data\CR1000\MATFILE\TRH_60minAvg',...
                                    't_60minTRH_Flx',...
                                    'T04m_raw60min','RH04m_raw60min',...
                                    'T16m_raw60min','RH16m_raw60min',...
                                    'T24m_raw60min','RH24m_raw60min',...
                                    'T32m_raw60min','RH32m_raw60min',...
                                    'T37m_raw60min','RH37m_raw60min',...
                                    'T46m_raw60min','RH46m_raw60min')
% load('c:\Speulderbos\Data\CR1000\MATFILE\TRH_60minAvg')