%% Import data from Logger
% First using previous script to import, then Processing sapflow
% measurements
addpath                    c:\Speulderbos\Processing\MatlabProcess\functions\
load ('C:\Speulderbos\Data\RainHobo\MATFILE\RHOBO_1_2')
load ('c:\Speulderbos\Data\CR23xSoil\MATFILE\CR213Tab1Tab2' );
load('c:\Speulderbos\Data\RainTower\MATFILE\RainTower')
%%  table1 contain data from soil sensors

tPrg03                           = datenum([2015 06 19 00 00 0]); %
toff2015                         = datenum([2016 11 01 00 00 00]);   
I_p03                            = find(t_soil>=tPrg03 & t_soil< toff2015);
% From ProcessSapFlow02 script
t_soil_p03                         = t_soil(I_p03);
% Td1_p03                          = table1(I_p03,24);
% Td2_p03                          = table1(I_p03,25);
% Td3_p03                          = table1(I_p03,11);
%% 
% 12. Tsoil litter
% 13. Tsoil - 1 cm
% 14. Tsoil - 2 cm % Excluded due to issues in the measurements
% 15. Tsoil - 3 cm
% 16. Tsoil - 4 cm
% 17. Tsoil - 8 cm
% 18. Tsoil - 20 cm
% 19. Tsoil - 50 cm
% 20. Tsoil - 100 cm
% ;21 SHF_1_AVG  L 	keep on litter
% ;22 SHF_2_AVG  L untill  25-Nov-16	moved to 8 cm depth
% ;23 SHF_3_AVG  L         25-Nov-16	moved to 8 cm depth
 

Tsoil_1cm                           = table1(I_p03,13); % From summer 2016 seems to be wrong data
Tsoil_2cm                           = table1(I_p03,14);
Tsoil_3cm                           = table1(I_p03,15);
Tsoil_4cm                           = table1(I_p03,16);
Tsoil_8cm                           = table1(I_p03,17);
Tsoil_20cm                          = table1(I_p03,18);
Tsoil_50cm                          = table1(I_p03,19);
Tsoil_100cm                         = table1(I_p03,20);

SHF_1                              = table1(I_p03,21);	
SHF_2                              = table1(I_p03,22);	
SHF_3                              = table1(I_p03,23);	

%% PLot
% Tsoil_3cm seems to fail 'Tsoil 3cm'
figure()
ax1=subplot(2,1,1);
hold on
plot(t_soil_p03,[Tsoil_1cm Tsoil_3cm Tsoil_4cm Tsoil_8cm Tsoil_20cm Tsoil_50cm Tsoil_100cm])%Tsoil_1cm 
legend({'Tsoil 1cm'  'Tsoil 3cm' 'Tsoil 4cm' 'Tsoil 8cm' 'Tsoil 20cm' 'Tsoil 50cm' 'Tsoil 100cm' },'FontSize',7,'FontWeight','bold')
set(gca,'xtick',[datenum(t_soil_p03(1)):1: datenum(t_soil_p03(end))])
datetick('x', 'mmm-dd' ,'keepticks')
title(' Soil Temp Profile and Rainfall')
% grid on

ax2=subplot(2,1,2);
hold on
plot  (R(1).agg_wt,R(1).agg_mm_cor,'-b')
plot  (R(2).agg_wt,R(2).agg_mm_cor,'-r')
 plot(t_Rtow,(Rain_tow),'xk')
% set(gca,'xlim',[datenum(growS_ini) datenum(growS_end)])
datetick('x','mmm-dd','keepticks')
legend({'P1 mm' 'P2 mm'})
grid on

linkaxes([ax1,ax2],'x')
%% plot soil heat fluxes
figure()
hold on 
plot(t_soil_p03,[SHF_1,SHF_2,SHF_3])
legend({'SH1' 'SH2' 'SH3'})
set(gca,'xtick',[datenum(t_soil_p03(1)):1: datenum(t_soil_p03(end))])
title(' Soil Heat Flux Raw data from SHFplates')
datetick('x', 'mmm-dd' ,'keepticks')




%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating files to be used on Sol heat flux calculations iniS1 only
% consider dry days
% iniS1  = datenum([2016 06 01 0 0 0]); %Previous begin 2016 06 01
% finS1  = datenum([2016 06 10 24 0 0]); %Previous end 2016 06 10

% Originally t_soil_p03 starts on [2015 6 19 0 0 0]
iniS1  = datenum([2015 11 26 0 0 0]);
finS1  = datenum([2016 11 01 24 0 0]);

IS1    = find(t_soil_p03 >=iniS1 & t_soil_p03 <=finS1);
datevec(t_soil_p03(1:10))

[Tsoil_1cm_30minAvg]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_1cm(IS1),30);
[Tsoil_2cm_30minAvg]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_2cm(IS1),30);
[Tsoil_3cm_30minAvg]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_3cm(IS1),30);
[Tsoil_4cm_30minAvg]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_4cm(IS1),30);
[Tsoil_8cm_30minAvg]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_8cm(IS1),30);
[Tsoil_20cm_30minAvg]                = avg_xmin_v3(t_soil_p03(IS1),Tsoil_20cm(IS1),30);
[Tsoil_50cm_30minAvg]                = avg_xmin_v3(t_soil_p03(IS1),Tsoil_50cm(IS1),30);
[Tsoil_100cm_30minAvg]               = avg_xmin_v3(t_soil_p03(IS1),Tsoil_100cm(IS1),30);

%% SHF
% SHF_2,SHF_3
[SHF_2_08cm_30minAvg]               = avg_xmin_v3(t_soil_p03(IS1),SHF_2(IS1),30);
[SHF_3_08cm_30minAvg]               = avg_xmin_v3(t_soil_p03(IS1),SHF_3(IS1),30);
%%
figure()
hold on
plot(Tsoil_1cm_30minAvg(:,1),Tsoil_1cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_2cm_30minAvg(:,1),Tsoil_2cm_30minAvg(:,2),'r') % Ts2cm seems
% to bewrong data
plot(Tsoil_3cm_30minAvg(:,1),Tsoil_3cm_30minAvg(:,2),'color',rand(1,3))
plot(Tsoil_4cm_30minAvg(:,1),Tsoil_4cm_30minAvg(:,2),'color',rand(1,3))
plot(Tsoil_8cm_30minAvg(:,1),Tsoil_8cm_30minAvg(:,2),'color',rand(1,3))
plot(Tsoil_20cm_30minAvg(:,1),Tsoil_20cm_30minAvg(:,2),'color',rand(1,3))
plot(Tsoil_50cm_30minAvg(:,1),Tsoil_50cm_30minAvg(:,2),'color',rand(1,3))
plot(Tsoil_100cm_30minAvg(:,1),Tsoil_100cm_30minAvg(:,2),'color',rand(1,3))
plot(Tsoil_100cm_30minAvg(:,1),SHF_2_08cm_30minAvg(:,2))
plot(Tsoil_100cm_30minAvg(:,1),SHF_3_08cm_30minAvg(:,2),'--')
% plot(Tsoil_100cm_30minAvg(:,1),SHF_avg08cm,'-r')
% SHF_avg08cm 
legend({'T1cm' 'T3cm' 'T4cm' 'T8cm' 'T20cm' 'T50cm' 'T100cm' 'SHF2' 'SHF3'})
title('Soil Temp Prof 30 min')
datetick('x', 'mmm-dd' ,'keepticks')
%%
% Ts      = load([pa 'Ts.dat']);   % 6 cols...Ts[^oC]	Soil temperature at 1,2,4,8,16, 32 cm depth (OnSet sensors)
% Tsoil_2cm_30minAvg(:,2),...
Ts =[Tsoil_1cm_30minAvg(:,2),...
     Tsoil_3cm_30minAvg(:,2),...
     Tsoil_4cm_30minAvg(:,2),...
     Tsoil_8cm_30minAvg(:,2),...
     Tsoil_20cm_30minAvg(:,2),...
     Tsoil_50cm_30minAvg(:,2)];%Tsoil_100cm_30minAvg(:,2)];

t_all= Tsoil_2cm_30minAvg(:,1);

SHF2_08cm   = SHF_2_08cm_30minAvg(:,2);% [Wm-2] 	soil heat flux at 8 cm depth
SHF3_08cm   = SHF_3_08cm_30minAvg(:,2);% [Wm-2] 	soil heat flux at 8 cm depth
SHF_avg08cm = nanmean([SHF_2_08cm_30minAvg(:,2) SHF_3_08cm_30minAvg(:,2)],2);

% save('c:\Speulderbos\Data\SoilHeatFlux\data\Ts.dat','Ts','-ascii');
% save('c:\Speulderbos\Data\SoilHeatFlux\data\t.dat','t_all','-ascii');
% save('c:\Speulderbos\Data\SoilHeatFlux\data\SHF2_08cm.dat','SHF2_08cm','-ascii');
% save('c:\Speulderbos\Data\SoilHeatFlux\data\SHF3_08cm.dat','SHF3_08cm','-ascii');
% save('c:\Speulderbos\Data\SoilHeatFlux\data\SHF3_avg08cm.dat','SHF_avg08cm','-ascii');

save('c:\Speulderbos\Data\SoilHeatFlux\data\TsSHFprof', 'Ts', 't_all', 'SHF_avg08cm', 'SHF2_08cm', 'SHF3_08cm');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%          Second dataset for 2015 (data based on 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Originally t_soil_p03 starts on [2015 6 19 0 0 0]
iniS1  = datenum([2015 6 19 0 0 0]);
finS1  = datenum([2015 11 26 0 0 0]);

IS1    = find(t_soil_p03 >=iniS1 & t_soil_p03 <finS1);
datevec(t_soil_p03(1:10))

[Tsoil_1cm_30min]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_1cm(IS1),30);
% [Tsoil_2cm_30min]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_2cm(IS1),30);
[Tsoil_3cm_30min]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_3cm(IS1),30);
[Tsoil_4cm_30min]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_4cm(IS1),30);
[Tsoil_8cm_30min]                 = avg_xmin_v3(t_soil_p03(IS1),Tsoil_8cm(IS1),30);
[Tsoil_20cm_30min]                = avg_xmin_v3(t_soil_p03(IS1),Tsoil_20cm(IS1),30);
[Tsoil_50cm_30min]                = avg_xmin_v3(t_soil_p03(IS1),Tsoil_50cm(IS1),30);
% [Tsoil_100cm_30min]               = avg_xmin_v3(t_soil_p03(IS1),Tsoil_100cm(IS1),30);

%% SHF

[SHF_2_01cm_30min]               = avg_xmin_v3(t_soil_p03(IS1),SHF_2(IS1),30);

%%
% figure()
% hold on
% plot(Tsoil_1cm_30minAvg(:,1),Tsoil_1cm_30minAvg(:,2),'color',rand(1,3))
% % plot(Tsoil_2cm_30minAvg(:,1),Tsoil_2cm_30minAvg(:,2),'r') % Ts2cm seems
% % to bewrong data
% plot(Tsoil_3cm_30minAvg(:,1),Tsoil_3cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_4cm_30minAvg(:,1),Tsoil_4cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_8cm_30minAvg(:,1),Tsoil_8cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_20cm_30minAvg(:,1),Tsoil_20cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_50cm_30minAvg(:,1),Tsoil_50cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_100cm_30minAvg(:,1),Tsoil_100cm_30minAvg(:,2),'color',rand(1,3))
% plot(Tsoil_100cm_30minAvg(:,1),SHF_2_08cm_30minAvg(:,2))
% plot(Tsoil_100cm_30minAvg(:,1),SHF_3_08cm_30minAvg(:,2),'--')
% legend({'T1cm' 'T3cm' 'T4cm' 'T8cm' 'T20cm' 'T50cm' 'T100cm' 'SHF2' 'SHF3'})
% title('Soil Temp Prof 30 min')
% datetick('x', 'mmm-dd' ,'keepticks')
%%
Ts2015 =[Tsoil_1cm_30min(:,2),...
     Tsoil_3cm_30min(:,2),...
     Tsoil_4cm_30min(:,2),...
     Tsoil_8cm_30min(:,2),...
     Tsoil_20cm_30min(:,2),...
     Tsoil_50cm_30min(:,2)];%Tsoil_100cm_30minAvg(:,2)];

t_all2015= Tsoil_1cm_30min(:,1);

SHF2_01cm   = SHF_2_01cm_30min(:,2);% [Wm-2] 	soil heat flux at 1 cm depth

save('c:\Speulderbos\Data\SoilHeatFlux\data\TsSHFprof2015', 'Ts2015', 't_all2015', 'SHF2_01cm');