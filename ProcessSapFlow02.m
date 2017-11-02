%% Process SapFlow01 
% First using previous script to import, then Processing sapflow
% measurements
addpath                    c:\Speulderbos\Processing\MatlabProcess\functions\

load ('c:\Speulderbos\Data\CR23xSoil\MATFILE\CR213Tab1Tab2' );
% load('C:\Speulderbos\Data\Met_AVG\05MATFILE\MetAVG_RN35m')
% run('C:\Speulderbos\Processing\MatlabProcess\EC_newALtEddy.m')

%%
  %load ('c:\Speulderbos\Data\SapFlow\MATFILE\SapF')

%% %Modification on 4 August 2015
%%new version Date 04August2015, Name(ImpDataCR23X_2.m) was not changed in order to not
%%affect other dependent scripts
%it is decided to separate values with code 2 from
%%the rest of table ID (137,131,132,134), then when processing each measurement
%%is better to use a combination of time and ID to filter out the data

%Description of files:
%At this date (4August2015)there are 17 files 
%///////////////////////////////////////////////////////////////////////////////
%%% 4 first: They records with indicator////// 137 /////(before sapflow measurements)
%%% and indicator Table 2 for the table collecting tipping data measurement
% soil_20150303_ed.dat (ed indicator that data from testing Tipping buckets were deleted)
% soil_20150413.dat
% soil_20150421.dat
% soil_20150501.dat
%///////////////////////////////////////////////////////////////////////////////
%%% from the 5th to the 13th
%%%Table WITH indicator ///////132////// included sap flow from 1st of May (there are measurements with heater on and off)
%%% and indicator Table 2 for the table collecting tipping data measurement
%soil_20150507.dat, %soil_20150513.dat 
%soil_20150516ed.dat ////////////////THIS FILE was edited because after 
%repower the logger NAN and 26 and 27 values were found//////(16 of may heater of the sap flow sensors were powered ON)
%soil_20150518.dat %soil_20150519.dat
%soil_20150526.dat %soil_20150610.dat 
%soil_20150615.dat  (Ind:134) 
%soil_20150616.dat  (Ind:134,130,132,131) 
%///////////////////////////////////////////////////////////////////////////////
%%% from the 14th to the 17th FILE, logger program was changed to use only
%%% port 1 and 2 in the Multiplexer and 

%%%Table WITH indicator ///////131 ////// included sap flow from 1st of May (there are measurements with heater on and off)
%%% and indicator Table 2 for the table collecting tipping data
%%% measurement\\

%% Filter out and organizing Sap flow data
% ;   Diff1       Sap Flow 1.1  ///UP sensors AF91(up)-AF92(down)-//// Tree
% next to the house; on 24May2016  was moved after vandalism of the tower
% ;               Sap Flow 1.2
% ;   Diff2       Sap Flow 2.1  ///UP sensors AF93(up)-AF94(down)-//// Tree inside of the parcel
% ;               Sap Flow 2.2
% ;   Diff3       SapfFlow 3.1  ///UP sensors AF8F(up)-AF90(down)-//// Tree next to logger CR23xSoil
% ;               Sap Flow 3.2

%% ////////////////////// 1st PERIOD(I_p01)HEATER OFF&DUPLICATE SENS1=SENS2: 
%                                   01 MAY 2015 TO 16 MAY 2015 
% 1st of May 2015 13:10:00 sensors were installed and logger program was installed on CR23X2,
% but heater was not conected until 16 of May 2015 12:00:00,

tsfw_inst                        = datenum([2015 05 01 13 10 0]);
tHeatON                          = datenum([2015 05 16 12 00 0]);

I_p01                            = find(table1(:,1)==132 &...
                                   t_soil>tsfw_inst & t_soil<tHeatON); 
%both conditions are used in case ID 137 appear again

% data_p01                         = stot132(I_p01,:);
t_sf_p01                         = t_soil(I_p01);
Td1_p01                          = table1(I_p01,25);
Td2_p01                          = table1(I_p01,26);
Td3_p01                          = table1(I_p01,27);

% Sens1 =Sens2, and Sens 3 is not collecting data(erroneous data)
clear I_p01      
%% ////////////////////// 2nd PERIOD(I_p02): 
%                    16 MAY 2015 12:00:00 to 15 JUN 2015
%%14:00:00 //////WARNING: at the end of this period heaters were turned off and also sensor #2 shows a not reliable signal 
%and sensor#3 is not showing signal
% Logger program was modified on           15 June 14:00:00

tPrg02                           = datenum([2015 06 15 12 00 0]); 
                                       % 12:00:00 is selected in order to avoid testing values
I_p02                            = find(t_soil>tHeatON & t_soil< tPrg02);

t_sf_p02                         = t_soil(I_p02);
Td1_p02                          = table1(I_p02,25);
Td2_p02                          = table1(I_p02,26);
Td3_p02                          = table1(I_p02,27);

% figure()
% plot(t_sf_p02,[Td1_p02 Td2_p02 Td3_p02])
% legend({'1' '2' '3'})
% datetick('x','dd/mm HH:MM')
clear I_p02 tPrg02 tsfw_inst tHeatON
%% //////////////////// 3rd PERIOD(I_p03): 
%              v01  16 JUN 2015 1:00:00 to 13 JUL2015.. (Note on26May2016 why13Jul2015?)
%              v02  19 JUN 2015 12:00 to 04 MAY 2016  when the sensor was
%              took out,(heated off for three sensors)
%% because logger program was modified on 15June 14:00:00 we decide not take
%  in account data of that day and a new period was stabliseh from
%  16JUN2015, the new program consider only 25 cols of Data and those used
% f or T diff were:
%           Tdiff1=col24,    Tdiff2=col25, Tdiff3=col11

%% 19 of june is selected as a reference because part of the days between
%  16Jun to 19Jun the heater wasturned off

tPrg03                           = datenum([2015 06 19 00 00 0]); 
toff2015                         = datenum([2015 11 01 00 00 00]);   
I_p03                            = find(t_soil>=tPrg03 & t_soil< toff2015);

t_sf_p03                         = t_soil(I_p03);

Td1_p03                          = table1(I_p03,24);
Td2_p03                          = table1(I_p03,25);
Td3_p03                          = table1(I_p03,11);

%% We did this step to avoid data gaps that make time discontinuity

[avgdT1]                        = avg_xmin_v3(t_sf_p03,Td1_p03,10);
[avgdT2]                        = avg_xmin_v3(t_sf_p03,Td2_p03,10);
[avgdT3]                        = avg_xmin_v3(t_sf_p03,Td3_p03,10);

t_sf_p03                        = avgdT1(:,1);
Td1_p03                         = avgdT1(:,2);
Td2_p03                         = avgdT2(:,2);
Td3_p03                         = avgdT3(:,2);
clear avgdT1 avgdT2 avgdT3 

%%
% 1 Solve the problem with data (log)%% one incomplete row in table1 was
% removed from the original file on 19 January2016
% 2 Solve the unpluged sensor times S1 was unpluged 14 Apr 2016 and
% reconected on a new tree Td1new_p04
% t_unplugg                        = datenum([2016 04 12 00 00 00]);
% I_T1p03c                         = (t_sf_p03 > t_unplugg & t_sf_p03 < toff2015);
% Td1_p03(I_T1p03c)                = NaN; 

% datevec([t_soil(end)])
% clear I_p03 I_T1p03c tPrg03
%% //////////////////// 4th PERIOD(I_p04): last dissconection 04 may 2016( solved by making a group 04)

% on 12 Apr 2016 ------> Probably Sensor #1 was broken , then  
% on 04 May 2016 ------> It was unplugged, and then two others heaters were turned off
%                        because serial conection of heater.
% On 24 May 2016-------> sensor #1 was placed on another tree, then heater on again
%           Tdiff1=col24,    Tdiff2=col25, Tdiff3=col11
% 
%---------------- changed the time of toff04
tBrokeSens1                      = datenum([2016 04 12 11 40 00]); 
toff04                           = datenum([2016 05 04 11 40 00]); 
% Use this time to exclude data when heater was off.
t_reinst                         = datenum([2016 05 24 18 00 00]); 

tFailAllSens                    = datenum([2016 09 16 00 00 00]); % Time to exlude last data collectio with problems on data

I_p04                            = find(t_soil > toff2015 & t_soil < tFailAllSens);
t_sf_p04                         = t_soil(I_p04);
Td1_p04                          = table1(I_p04,24); 
Td1new_p04                       = table1(I_p04,24); %Change of name from Td1 to Td1New because it was set on a different tree.
Td2_p04                          = table1(I_p04,25);
Td3_p04                          = table1(I_p04,11);% 

% Correctioin for Sensor 1 (sensor disturbed)
I_pAttack                        = find(t_sf_p04> tBrokeSens1);% {from 12 Apr 2016  till 24 May 2016} Because only the sensor1 was affected
I_pOff                           = find(t_sf_p04> toff04 & t_sf_p04< t_reinst);%      {from  04 May 2016  till 24 May 2016}
I_prevNewSens1                   = find(t_sf_p04< t_reinst);

Td1_p04(I_pAttack)               = NaN;
Td1new_p04(I_prevNewSens1)       = NaN;
Td2_p04(I_pOff)                  = NaN;
Td3_p04(I_pOff)                  = NaN;

%%
[avgdT1]                        = avg_xmin_v3(t_sf_p04,Td1_p04,10);
[avgdT1new]                     = avg_xmin_v3(t_sf_p04,Td1new_p04,10);
[avgdT2]                        = avg_xmin_v3(t_sf_p04,Td2_p04,10);
[avgdT3]                        = avg_xmin_v3(t_sf_p04,Td3_p04,10);

t_sf_p04                        = avgdT1(:,1);
Td1_p04                         = avgdT1(:,2);
Td1new_p04                      = avgdT1new(:,2);
Td2_p04                         = avgdT2(:,2);
Td3_p04                         = avgdT3(:,2);

clear avgdT1 avgdT2 avgdT3 avgdT1new

% clear I_p04 t_unplugg 
%% Plot last periods 3, 4 

time_tk           =datenum([0 0 1 0 0 0]);
figure()
% plot(t_sf_p02,[Td1_p02 Td2_p02 Td3_p02])
hold on
plot(t_sf_p03,Td1_p03,'.r')
plot(t_sf_p03,Td2_p03,'.g')
plot(t_sf_p03,Td3_p03,'.b')
% plot(Rn_avg30m(:,1),14+Rn_avg30m(:,2)/400,'k')
plot(t_sf_p04,Td1_p04,'r')
plot(t_sf_p04,Td1new_p04,'k')
plot(t_sf_p04,Td2_p04,'g')
plot(t_sf_p04,Td3_p04,'b')
legend({'T Diff1(C)' 'T Diff2(C)' 'T Diff3(C)' ...
        'T Diff1(C)' 'T Diff1(C)new' 'T Diff2(C)' 'T Diff3(C)' },'FontSize',7,'FontWeight','bold')
ylabel('Tdiff');
title('Plot Temp Differrences Granier');
% set(gca,'xtick', t_sf_p03(1):time_tk:t_sf_p03(end));
% datetick('x','dd-mmm ','keepticks')
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'yymmm' ,'keepticks')



%% save vector files, for the periods 3 and 4
save('c:\Speulderbos\Data\SapFlow\MATFILE\SapFseries',...
    't_sf_p03','Td1_p03',...
    'Td2_p03','Td3_p03',...
     't_sf_p04','Td1_p04', 'Td1new_p04',...
    'Td2_p04','Td3_p04')
% 
% 
%% Processing Sapflow  (Temperature difference)
% Temperature diferences are measured on mv and then multiplied  by 25 to
% convert them to Celsius degrees
% 
% ambient Temperature in the tree -20°C … -10° Factor 37.4 ?V/°C
% ambient Temperature in the tree -10°C … 0° Factor 38.3 ?V/°C
% ambient Temperature in the tree 0°C … 10° Factor 39.1 ?V/°C
% ambient Temperature in the tree 10°C … 20° Factor 39.8 ?V/°C, we use
% 1/40=0.025;0.025*1000=25 factor to convert to temp C, this multiplier is
% included in the logger program
% ambient Temperature in the tree 20°C … 30° Factor 40.7 ?V/°C
% ambient Temperature in the tree 30°C … 40° Factor 41.5 ?V/°C


%%


%------- DOUBLE REGRESSION


%% Applying the double regression to get dTMax

% [dTmax1_p03_DR] = dTmax_02(t_sf_p03,Td1_p03,10);
% [dTmax2_p03_DR] = dTmax_02(t_sf_p03,Td2_p03,10);
% [dTmax3_p03_DR] = dTmax_02(t_sf_p03,Td3_p03,10);

%% Figure of regression lines
% figure
% hold on
% plot(t_sf_p03,dTmax1_p03_DR,'r')
% plot(t_sf_p03,Td1_p03,'r')
% plot(t_sf_p03,dTmax2_p03_DR,'g')
% plot(t_sf_p03,Td2_p03,'g')
% plot(t_sf_p03,dTmax3_p03_DR,'b')
% plot(t_sf_p03,Td3_p03,'b')
% datetick('x','dd/mm','keepticks')%HH:MM
% 
%% Estimation of sap flux density, with Doble regression method

% divdT1_p03                      =dTmax1_p03_DR./Td1_p03;
% divdT2_p03                      =dTmax2_p03_DR./Td2_p03;
% divdT3_p03                      =dTmax3_p03_DR./Td3_p03;
% 
% plot(((divdT1_p03)-1))
% 
% sf_dens1_p03_DR                   = 0.74*((divdT1_p03)-1).^1.231;
% sf_dens2_p03_DR                   = 0.74*((divdT2_p03)-1).^1.231;
% sf_dens3_p03_DR                   = 0.74*((divdT3_p03)-1).^1.231;
% 
% clear divdT1_p03 divdT2_p03 divdT3_p03
%% Filtering those values with imaginary sf_dens

%THERE were SOME NEGATIVE VALUES AFTER THE SUBSTRACTION OF DIV-1 THIS
%PRODUCES imaginary values

% for k = 1:length(sf_dens1_p03_DR)
% real_vals1(k,1) = isreal(sf_dens1_p03_DR(k,1));
% end
% 
% sf_dens1_p03_DR(real_vals1==0)      = 0;       
% 
% for k = 1:length(sf_dens2_p03_DR)
% real_vals2(k,1) = isreal(sf_dens2_p03_DR(k,1));
% end
% 
% sf_dens2_p03_DR(real_vals2==0)       = 0;
% 
% for k = 1:length(sf_dens3_p03_DR)
% real_vals3(k,1) = isreal(sf_dens3_p03_DR(k,1));
% end
% 
% sf_dens3_p03_DR(real_vals3==0)       = 0;
% 
% clear real_vals1 real_vals2 real_vals3 k
%% PLot of sap flux density with dtMax from double regression
% t_ini=datenum([2015 07 01 0 0 0]);
% t_fin=datenum([2015 10 12 0 0 0]);
% time_tk=datenum([0 0 7 0 0 0]);
% 
% figure
% hold on
% plot(t_sf_p03, sf_dens1_p03_DR*60,'-r')
% plot(t_sf_p03, sf_dens2_p03_DR*60,'-g')
% plot(t_sf_p03, sf_dens3_p03_DR*60,'-b')
% % plot(R(1).agg_wt,R(1).agg_mm,'.k')
% datetick('x','dd/mm','keepticks')%HH:MM
% legend({'Tree 1 ' 'Tree 2' 'Tree 3'})
%     grid on
%     set(gca,'xtick', t_ini:time_tk:t_fin,'ylim',[0 7],'Fontsize',11);
%     datetick('x','dd/mm','keepticks')%HH:MM
% title('SapFlux density using dtMax Double regression')    
%% t_soil is the time series complete, t_sap is the variable used for the... 
% ...sf_desn = sap flow density [ml * cm-2 * min-1]
% sf_dens1                   = 0.74*((TdN/Tdiff1)-1)^1.231;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t_sf_p03 
% Td3_p03

%% 
%-------------dtMax  DAILY (6AM to 6AM)

%% ESTIMATING SAPFLOW VELOCITY for 2015 data
% Formula sf_dens= 0.74*(((divdT)-1).^1.231); is included in the old
% function
[TdN1_p03_D , sf_dens1_p03_D ]=dTmax_6AM_01(t_sf_p03,Td1_p03);
[TdN2_p03_D , sf_dens2_p03_D ]=dTmax_6AM_01(t_sf_p03,Td2_p03);
[TdN3_p03_D , sf_dens3_p03_D ]=dTmax_6AM_01(t_sf_p03,Td3_p03);

%% Plot dT maximum (Still testing wich day should it use to process)
figure()
hold on
plot(t_sf_p03,[TdN1_p03_D Td1_p03],'r')
plot(t_sf_p03,[TdN2_p03_D Td2_p03],'b')
plot(t_sf_p03,[TdN3_p03_D Td3_p03],'g')
set(gca,'xtick', t_sf_p03(1):1:t_sf_p03(end));
datetick('x','dd/mm HH','keepticks')%HH:MM

%% VPD

load('c:\Speulderbos\Data\CR1000\MATFILE\VPD46mRaw', 't_trh','t_10minTRH','VPD46m','T46m_raw', 'RH46m_raw')

%% PLot for sf density with dtmax Daily 2015 data

figure()
hold on
% plot(t_sf_p03, sf_dens1_p03_D*10000/60*2*(60*60*60/10^7),'r')
% plot(t_sf_p03, sf_dens2_p03_D*10000/60*2*(60*60*60/10^7),'g')
% plot(t_sf_p03, sf_dens3_p03_D*10000/60*2*(60*60*60/10^7),'b')
plot(t_sf_p03, sf_dens1_p03_D*60,'r')
plot(t_sf_p03, sf_dens2_p03_D*60,'g')
plot(t_sf_p03, sf_dens3_p03_D*60,'b')


% plot(t_EC,1000*2*lE_PM./lambda,'k')
% plot(R(1).agg_wt,R(1).agg_mm,'.k')
% plot(t_Rtow,Rain_tow,'.b')
% plot(R30(:,1),R30(:,2),'.b')
% legend({'Sap Flow density 1 [ml * cm-2 * h-1]' 'Sap Flow density 2 [ml * cm-2 * h-1]' 'Sap Flow density 3 [ml * cm-2 * h-1]'})
    legend({'Tree 1 ' 'Tree 2' 'Tree 3'})
%     grid on
plot(t_10minTRH, VPD46m/10, '--r')
    set(gca,'xtick', t_sf_p03(1):1:t_sf_p03(end),'Fontsize',11); %'ylim',[0 .1]
    datetick('x','dd/mm HH','keepticks')%HH:MM
title('SapFlux density using 6AM to 6AM 2015')    

%     clear time_tk

%% Estimating Transpiration

TreeDBH1                    = 30; % circunf=2*Pi*raidus
TreeDBH2                    = 31;
TreeDBH3                    = 32;

circTree1                   = 2*pi*(TreeDBH1/2); % in cm
circTree2                   = 2*pi*(TreeDBH2/2); %in cm
circTree3                   = 2*pi*(TreeDBH3/2); % in cm

SapWoodRad1                 = 0.04*circTree1-1.33;
SapWoodRad2                 = 0.04*circTree2-1.33;
SapWoodRad3                 = 0.04*circTree3-1.33;

SwArea1                     = pi*SapWoodRad1^2; % cm^2
SwArea2                     = pi*SapWoodRad2^2; % cm^2
SwArea3                     = pi*SapWoodRad3^2; % cm^2


%% ESTIMATING SAPFLOW VELOCITY for 2016 data
[TdN1_p04_D , sf_dens1_p04_D ]              = dTmax_6AM_01(t_sf_p04,Td1_p04);
[TdN1new_p04_D , sf_dens1new_p04_D ]        = dTmax_6AM_01(t_sf_p04,Td1new_p04);
[TdN2_p04_D , sf_dens2_p04_D ]              = dTmax_6AM_01(t_sf_p04,Td2_p04);
[TdN3_p04_D , sf_dens3_p04_D ]              = dTmax_6AM_01(t_sf_p04,Td3_p04);

%% PLot for sf density with dtmax Daily 2016 data

figure()
hold on
plot(t_sf_p04, sf_dens1_p04_D*10000/60,'r')
plot(t_sf_p04, sf_dens1new_p04_D*10000/60,'-*r')
plot(t_sf_p04, sf_dens2_p04_D*10000/60,'g')
plot(t_sf_p04, sf_dens3_p04_D*10000/60,'b')

% plot(Time_Sf,u2,'-b')
% plot(Time_Sf,u3,'-r')
% plot(R(1).agg_wt,R(1).agg_mm,'.k')
% plot(t_Rtow,Rain_tow,'.b')
% plot(R30(:,1),R30(:,2),'.b')
% legend({'Sap Flow density 1 [ml * cm-2 * h-1]' 'Sap Flow density 2 [ml * cm-2 * h-1]' 'Sap Flow density 3 [ml * cm-2 * h-1]'})
legend({'Tree 1 ' 'Tree 1* ' 'Tree 2' 'Tree 3' 'u2 CesarJ' 'u3 CesarJ'})
% grid on
set(gca,'xtick', t_sf_p04(1):1:t_sf_p04(end),'Fontsize',11);%'ylim',[0 .5],
datetick('x','dd/mm HH','keepticks')%HH:MM
title('SapFlux density using 6AM to 6AM 2016')    
ylabel('SapFlux density [ml * cm^-2 * min^-1]')


%%
%     't_sf_p03','sf_dens1_p03_DR', 'sf_dens2_p03_DR', 'sf_dens3_p03_DR',...%calculated with double regression
save('c:\Speulderbos\Data\SapFlow\MATFILE\SapFdensity',...
    't_sf_p03', 'sf_dens1_p03_D', 'sf_dens2_p03_D', 'sf_dens3_p03_D');%Calculated with 24 hours past.


%% Load and process PAR radiation generated from ImpMetAvgRn01()
load('C:\Speulderbos\Data\PAR_AVG\MATFILE\PARin','t_T2','PARinnew_AVG')

[avgPAR]                           = avg_xmin_v3(t_T2,PARinnew_AVG,10);

t_PAR                              = avgPAR(:,1);
PAR_10min                          = avgPAR(:,2);

%% Load VPD
% load('c:\Speulderbos\Data\CR1000\MATFILE\VPD46mRaw', 't_trh','t_10minTRH','VPD46m','T46m_raw', 'RH46m_raw')
load('c:\Speulderbos\Data\CR1000\MATFILE\VPD46mRaw', 't_10minTRH','VPD46m', 'T46m_raw', 'RH46m_raw')

%% Export data to be processed on baseliner
% The current required data format is:
% 1: Plot ID (for user reference, not used in processing)
% 2: Year (for user reference, not used in processing)
% 3: Day of year
% 4: Time of day (format HHMM, such such that 1:45 AM = 145 and 3:00 PM = 1500)
% 5: Vapor pressure deficit (kPa, however any units will work, user defines
% threshold value), function uses output hPa, then has to be divided to 10
% 6: Photosynthetically active radiation (any units will work, user defines day/night threshold)
% 6+n: dT data, Sensor set #n (either degrees C or mV)

% Initial val Changed due to discontinuity on data growS_end                   datenum([2015 05 01 0 0 0 ]);
growS_ini                   = datenum([2015 06 19 0 0 0 ]);
% ENd Changed due to discontinuity on data growS_end                   =datenum([2015 09 01 0 0 0 ]);
growS_end                   = datenum([2015 09 01 0 0 0 ]); %= datenum([2015 08 04 0 0 0 ]); 
I_growS                     = find(t_sf_p03>= growS_ini & t_sf_p03<growS_end);
I_PAR                       = find(t_PAR>= growS_ini & t_PAR<growS_end);
I_VPD                       = find(t_10minTRH>= growS_ini & t_10minTRH<growS_end);

% plot(time_csv,VPD)
time_csv                    = t_sf_p03(I_growS);
numTime                     = numel(time_csv);
ID                          = ones(numTime,1);
Year                        = year(time_csv);
Doy                         = floor(time_csv- datenum(Year(1),1,0));
TimeDay                     = hour(time_csv)*100+minute(time_csv);
% VPD                         = nan(numTime,1);
VPD                         = VPD46m(I_VPD);
% PAR                         = nan(numTime,1);
PAR                         = PAR_10min(I_PAR);
% numel(PAR) it is 10656
sensor1                     = Td1_p03(I_growS);
sensor2                     = Td2_p03(I_growS);
sensor3                     = Td3_p03(I_growS);
%% Testing errors on Baseliner code loadRawSapflowData.m
% 
% hour = floor(TimeDay./ 100);
% minute = mod(TimeDay, 100);

%%%% sampleTime = datetime(Year, 1, Doy, hour, minute, 0); %datetime only
%%%% available on 2016 version
% sampleTime = datenum(Year, 1, Doy, hour, minute, 0);
    % Check that the time step is uniform.
% timeSteps = sampleTime(2:end) - sampleTime(1:end-1);       %TEMP!!! just use MATLAB's diff()

% interval = unique(timeSteps);
%% Export to dat format

dataSF                      =[ID,Year,Doy,TimeDay,VPD,PAR,sensor1,sensor2,sensor3];
csvwrite('c:\Speulderbos\Data\SapFlow\Baseliner\csv\csvSF.csv',dataSF)

%% Export to SapFluxNet
T2                         = T46m_raw(I_VPD);
RH2                        = RH46m_raw(I_VPD);

load('c:\Speulderbos\Data\CupAnemTop\MATFILE\WSTower', 't_WS','WS_tow') % one minute data
[WS_10m_avg]                = avg_xmin_v3(t_WS,WS_tow,10);
I_WS                       = find(WS_10m_avg(:,1)>= growS_ini & WS_10m_avg(:,1)<growS_end);
WS10                        = WS_10m_avg(I_WS,2);

load('C:\Speulderbos\Data\Met_AVG\05MATFILE\MetAVG_RN_10minavg', 'Rn_10m_avg','Rs_in10m_avg');
% size(Rn_10m_avg)
% size(Rs_in10m_avg)
I_Rn2                       = find(Rn_10m_avg(:,1)>= growS_ini & Rn_10m_avg(:,1)<growS_end);
Rn10                        = Rn_10m_avg(I_Rn2,2);
Rnsw10                      = Rs_in10m_avg(I_Rn2,2);

load('c:\Speulderbos\Data\RainTower\MATFILE\RTowCorr', 't_Rain10min', 'Rain_10min');
I_Precip10                       = find(t_Rain10min>= growS_ini & t_Rain10min<growS_end);
P10                        = Rain_10min(I_Precip10);


%Timestamp
% datestr(time_csv(1:5), 'yyyy/mm/dd HH:MM:SS') % Create a few values and
% extend them on excel

dataSFNetwork                      =[T2,RH2,VPD/10,Rnsw10,PAR,Rn10,WS10,P10,sf_dens1_p03_D(I_growS)*60,sf_dens2_p03_D(I_growS)*60,sf_dens3_p03_D(I_growS)*60]; %VPD units are hPa, then divided to 10 to get KPa

csvwrite('c:\Speulderbos\Data\SapFlow\SapFluxNet\data.csv',dataSFNetwork)
whos T2 RH2 VPD  Rnsw10 PAR Rn10 WS10 sf_dens1_p03_D
