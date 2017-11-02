%% First using previous script to import, then Processing Tipping buckets for Throughfall
% First using previous script to import, then Processing sapflow
% measurements
function ProcessThroughfall01
tic
addpath                   c:\Speulderbos\Processing\MatlabProcess\functions\;

load('c:\Speulderbos\Data\CR23xSoil\MATFILE\CR213Tab1Tab2',...
    't_tipp','table2')
%the previous line will load(data created from ImpDataCR23X_2.m):
% t_tipp: time from the tipping buckets connected to gutters
% table2: data from gutters
% below variables were not loaded
% t_soil: time for the data of table1,data of CR23x excluding tipping bucket gutter
% table1: data form CR23x_2 data from soil sensors

%% Depurating data because logger time changes
% t_tipp for measurements that are considered   after 17 Feb 2015 when tipping system to collect 
% TF was installed.
% ---------------------------------
% /) t_tipp consider two changes
% 
% ///1//30Apr2015///////
% Connect logger:
% Computer 14:15:37
% Logger 14:08:33
% el loger estaba con 0:07:04atrasado
% 
% DATA (SALTO)
% 
% 2015(04 30) doy 120 14:14:3.3 hay un salto hasta 
%              14:22
% 
% es decir a todos los datos del logger CR23X2  obtenidos antes de 2015 04 30 14:14, hay que 
% SUMAR 0:07:04 para llevar a un tiempo sincronizado comun.*** datos no se 
% duplican ya que la suma de 14:14:3 + 00:07:04 hace 14:21:7.3 y los datos
% no se sobreponen
d_corr1             =  datenum([2015 04 30 14 15 00]); % se escoge 15 como
%                         un valor intermedio para no afectar el dato 14:3sec
I_corr1             =  find(t_tipp < d_corr1);
err1time            =  datenum([0000 00 00 00 07 0]);%4 secs were eliminated

t_tipp_c1           =  t_tipp;
t_tipp_c1(I_corr1)  =  t_tipp(I_corr1)+err1time;

%%%%%%%%%%%%%%%%%%%%t_tipp_c1 ((((((IS THE NEW VECTOR WITH TIME DATA
%%%%%%%%%%%%%%%%%%%%CORRECTED AT FIRST TIME)))))))))
%%% Some commands to verify, there is not repetitions
% length(t_tipp_c1); length(t_tipp_c1); length(Tip1)
% datevec(t_tipp_c1(I_corr1(end)+1)); newdtset=unique(t_tipp_c1);
% length(newdtset); mat2bedel=t_tipp(I_corr1);
% length(mat2bedel); otruni=unique(mat2bedel);
% length(otruni)
% 
% ///2//13 MAY 2015///////
% 
% La fecha del COmputador está 00:06:12 adelantada
% cuando se hace el set del tiempo el reloj del 
% logger vuelve a contar desde 14:34,
% 14:37
% 14:38
% 14:39
% -------cómo se encuentra este punto??? DE LA MISMA MANERA QUE ARRIBA pero
% utilizando un rango
% 14:34
% 14:35
% 1.Aca empieza el problema, como se hace para 
% dividir la informacion
% 2. Encontrar los datos con ID menores a 14:39 y 
% luego restar los 00:06:12
%%
d_corr2in             =  datenum([2015 05 13 14 33 00]); % se escoge 15 como un valor intermedio para no afectar el dato 14:3sec
d_corr2su             =  datenum([2015 05 13 14 40 00]); % se escoge 15 como un valor intermedio para no afectar el dato 14:3sec

I_borr                =   find(t_tipp_c1 > d_corr2in & t_tipp_c1 < d_corr2su);
borr                  =   I_borr(7:12);

I_corr2               =   find(t_tipp_c1 < d_corr2su);
err2time              =  datenum([0000 00 00 00 06 0]); % 12 secs were eliminated
t_tipp_c2             =  t_tipp_c1;
t_tipp_c2(I_corr2)    =  t_tipp_c1(I_corr2)-err2time;

M1                    = t_tipp_c2(1:borr(1)-1);
M2                    = t_tipp_c2(borr(end)+1:end); 

t_tipp_cr       =[M1;M2];

clear M1
clear M2

%% Converting tips to mm of rainfall
% Tip1                        = stot2(:,6); 
% Tip2                        = stot2(:,7); 
Tip1                        = table2(:,6);  %#ok<NODEF>
Tip2                        = table2(:,7); 

%%%%%%%%%%%%%%%%%%%%%%
% Correcting values

Maux1                    =Tip1(1:borr(1)-1);
Maux2                    =Tip1(borr(end)+1:end); 

Tip1_c                   = [Maux1;Maux2];

Maux3                    =Tip2(1:borr(1)-1);
Maux4                    =Tip2(borr(end)+1:end); 

Tip2_c                   = [Maux3;Maux4];
% clear Maux1; clear Maux2; clear Maux3; clear Maux4;
%%  Estimation of tipping resolution
%%%%%%%
lrG1                        =2*cos(5*pi()/180);
lrG2                        =2*cos(3*pi()/180);
lrG3                        =2*cos(4*pi()/180);
lrG4                        =2*cos(5*pi()/180);

areaT1                      = lrG1*0.3+lrG2*0.3;
areaT2                      = lrG3*0.3+lrG4*0.3;

res_tip1                    = 100/(areaT1*1000);
res_tip2                    = 100/(areaT2*1000);


% res_tip1                    =0.083; %This values should be verified some time after installation
% res_tip2                    =0.083;

% Tipp1= SN141201 (located close to the tower)& Tipp2= SN141202(located  closest to the border)
thr1mm                      = Tip1_c*res_tip1;
thr2mm                      = Tip2_c*res_tip2;


%% Filter TF dada clogged in Gutters
%Gutter1
ini_clogG1                          = datenum([2015 08 15 12 00 00]);
fin_clogG1                          = datenum([2015 09 15 10 20 00]);
%t_tipp_cr

% IclogG1_time                        = find(t_tipp_cr >= ini_clogG1 &...
%                                         t_tipp_cr < fin_clogG1);
% thr1mm_ed                                     = thr1mm;
thr1mm(t_tipp_cr >= ini_clogG1 &...
          t_tipp_cr < fin_clogG1)             = NaN;% Similar to thr1mm

%% Gutter2 %Cloged detected on 2016 03 24
ini_clogG2                          = datenum([2016 03 24 12 00 00]);
fin_clogG2                          = datenum([2016 05 04 12 00 00]);

thr2mm(t_tipp_cr >= ini_clogG2 &...
          t_tipp_cr < fin_clogG2)             = NaN;% Similar to thr1mm


%% Ploting Through vs Time
% figure()
% plot(t_tipp_cr,thr1mm,'xr',t_tipp_cr,thr2mm,'xb')
% legend({'thr1mm','thr2mm'},'FontSize',8,'FontWeight','bold')
% datetick('x')
% grid on

% save('c:\Speulderbos\Data\CR23xSoil\MATFILE\TF12_cr','t_tipp_cr','thr1mm','thr2mm');%Excluded ,'thr1mm_ed'
% load('c:\Speulderbos\Data\CR23xSoil\MATFILE\TF12_cr')
%% Correct time gaps using aggregation script 
[Tf1_1min]                   = agg_xmin_v3(t_tipp_cr,thr1mm,1);
[Tf2_1min]                   = agg_xmin_v3(t_tipp_cr,thr2mm,1);

%% Replacing NaN data by zeros where NaN was not true
gapLim_1                     = datenum([2015 8 5 11 0 0]);
gapLim_2                     = datenum([2016 7 15 13 0 0]);

I_gapLim_1                   = isnan(Tf1_1min(:,2)) & Tf1_1min(:,1)< gapLim_1;
I_gapLim_2                   = isnan(Tf2_1min(:,2)) & Tf2_1min(:,1)> gapLim_2;

Tf1_1min(I_gapLim_1,2)       = 0;
Tf2_1min(I_gapLim_1,2)       = 0;

Tf1_1min(I_gapLim_2,2)       = 0;
Tf2_1min(I_gapLim_2,2)       = 0;

%% Saving New values of Tf resol 1 minute they were stored with new variables names

t_tipp_agg1min               = Tf1_1min(:,1);
thr1mm_agg1min               = Tf1_1min(:,2);
thr2mm_agg1min               = Tf2_1min(:,2);


%% Average of two gutter systems

Tf_avg1min                  = nanmean([thr1mm_agg1min,thr2mm_agg1min],2);

Tf_max1min                  = nanmax(thr1mm_agg1min,thr2mm_agg1min);
Tf_minim1min                = nanmin(thr1mm_agg1min,thr2mm_agg1min);

%% Agregated 10 min and 30 min
[Tf1_10min]                     = agg_xmin_v3(t_tipp_agg1min,thr1mm_agg1min,10);
[Tf2_10min]                     = agg_xmin_v3(t_tipp_agg1min,thr2mm_agg1min,10);

t_tipp_agg10min                 = Tf1_10min(:,1);
thr1mm_agg10min                 = Tf1_10min(:,2);
thr2mm_agg10min                 = Tf2_10min(:,2);

[Tf1_30min]                     = agg_xmin_v3(t_tipp_agg1min,thr1mm_agg1min,30);
[Tf2_30min]                     = agg_xmin_v3(t_tipp_agg1min,thr2mm_agg1min,30);

t_tipp_agg30min                 = Tf1_30min(:,1);
thr1mm_agg30min                 = Tf1_30min(:,2);
thr2mm_agg30min                 = Tf2_30min(:,2);

% Tf avg 
[Tf_avg_10min]                  = agg_xmin_v3(t_tipp_agg1min,Tf_avg1min,10);
t_Tf_10min_avg                  = Tf_avg_10min(:,1);
Tf_10min_avg                    = Tf_avg_10min(:,2);

[Tf_avg_30min]                  = agg_xmin_v3(t_tipp_agg1min,Tf_avg1min,30);
t_Tf_30min_avg                  = Tf_avg_30min(:,1);
Tf_30min_avg                    = Tf_avg_30min(:,2);

% Tf_max1min    
[Tf_max_10min]                  = agg_xmin_v3(t_tipp_agg1min,Tf_max1min,10);
t_Tf_10min_max                  = Tf_max_10min(:,1);
Tf_10min_max                    = Tf_max_10min(:,2);

[Tf_max_30min]                  = agg_xmin_v3(t_tipp_agg1min,Tf_max1min,30);
t_Tf_30min_max                  = Tf_max_30min(:,1);
Tf_30min_max                    = Tf_max_30min(:,2);


%% Plot Cumsum with NAN
t_tipp_cr_agg                   = Tf1_1min(:,1);
q                               = isnan(Tf1_1min(:,2)) ;% find all NaNs
w                               = isnan(Tf2_1min(:,2)) ;
aux1mm                          = Tf1_1min(:,2);
aux1mm(q)                       = 0 ; % treat NaNs as zero
aux2mm                          = Tf2_1min(:,2);
aux2mm(w)                       = 0 ;
thr1mmcsum                      = cumsum(aux1mm) ;
thr2mmcsum                      = cumsum(aux2mm) ;
% /%/%/%/%/%/%/%/%/%/       figure       /%/%/%/%/%/%/ . . .%----% % % % %
% Plotting from 1st of may
lim_may                         = datenum([2015 02 18 00 0 0]);
I_May                           = find (t_tipp_cr_agg >=lim_may);

figure()
hold on
plot(t_tipp_cr_agg(I_May),thr1mmcsum(I_May),'xr')
plot(t_tipp_cr_agg(I_May),thr2mmcsum(I_May),'xb')
plot(t_tipp_cr_agg(isnan(Tf1_1min(:,2))),ones(length(t_tipp_cr(isnan(Tf1_1min(:,2)))),1)*220,'xr')
plot(t_tipp_cr_agg(isnan(Tf2_1min(:,2))),ones(length(t_tipp_cr(isnan(Tf2_1min(:,2)))),1)*250,'ob')
% plot  (R(2).agg_wt,R(2).agg_mm_cor*100,'-y')
% plot(t_tow10_cor, rtow10_cor*100,'g')
plot(t_tipp_agg1min, cumsum(Tf_avg1min), 'xk')%, hold on
plot(t_tipp_agg1min, Tf_avg1min*100, 'xr')
plot(t_tipp_agg1min, cumsum(Tf_max1min), 'oy')
plot(t_tipp_agg1min, cumsum(Tf_minim1min ), 'oy')


% legend({'thr1mm','thr2mm'},'FontSize',8,'FontWeight','bold')
title('Throughfall Gutters(mm)')
anio  =[repmat(2015,12,1); repmat(2016,12,1)];
mes   =repmat((1:12)',2,1);
fech  =datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')

grid on

%% Find a new start values
% lim_may                     = datenum([2015 03 01 00 0 0]);
% I_May                       = find (t_tipp_cr>=lim_may);
% datevec(t_tipp_cr(I_Mar(1)))
%% Cumulative Tf per XXX minutes
% per_th                  = 15;
% 
% [th_1mtx]             = agg_xmin_v2(t_tipp_cr,thr1mm,per_th);
% [th_2mtx]             = agg_xmin_v2(t_tipp_cr,thr2mm,per_th);

save('c:\Speulderbos\Data\CR23xSoil\MATFILE\TF12_cr',...
    't_tipp_cr', 'thr1mm', 'thr2mm',...
    't_tipp_agg1min','thr1mm_agg1min','thr2mm_agg1min','Tf_avg1min',...
    't_Tf_10min_avg','Tf_10min_avg',...
    't_Tf_30min_avg','Tf_30min_avg',...
    't_tipp_agg30min', 'thr1mm_agg30min','thr2mm_agg30min');

% load('c:\Speulderbos\Data\CR23xSoil\MATFILE\TF12_cr',...
%     't_tipp_cr', 'thr1mm', 'thr2mm',...
%     't_tipp_agg1min','thr1mm_agg1min','thr2mm_agg1min','Tf_avg1min');
% 

toc
end