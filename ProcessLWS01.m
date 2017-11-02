% Process LWS1234... RESULT: until 05 May 2016
% load('c:\Speulderbos\Data\Met_LWS\MATFILE\MetAVG_LWS')
% use these datasets with t_T2 time serie.

%%  LOAD TO PROCESS LWS
% In case of important changes update ProcessMetAVG02.m, before load it.
load('C:\Speulderbos\Data\Met_AVG\05MATFILE\MetAVG_LWS1234')
load ('C:\Speulderbos\Data\RainHobo\MATFILE\RHOBO_1_2')

%% We will separate the series into 2(at the end seems to be more than 2) big groups
% 1. From 12 Jun 2015 to 18 Oct 24:00 2015

% 2. From 2 Nov 2015  to 3 May 2016

% LWS1_20m It is the most continuous dataset
% LWS3_26m It is the most continuous dataset change 19 August

%//////////////////////////////////////////////////////////////////////////////

% LWSo_1 at 20 meter organizing files

%1. We choose the 12 of june to start the analysis, before that the sensor
%was not placed

%COPY THE COL LWS1 to do the proper corrections
LWSo1_20m           = LWS_1_AVG;%---------------LWS2(Port1)

LWSo3_26m           = LWS_3_AVG;%---------------LWS2(Port3)

% Sensor were not properly placed until 12 of June 2015
I1                  = (t_T2<datenum([2015 06 12 24 00 00]));
LWSo1_20m(I1==1)    = NaN;        
LWSo3_26m(I1==1)    = NaN;        
clear I1
%------------ CALIB 1----------------------------------------
% Calibration wetting both sensors(LW120 LW3 at different levels)
ICal1            =  (t_T2>datenum([2015 06 15 10 00 00])& t_T2<datenum([2015 06 15 12 00 00]));
LWSo1_20m(ICal1==1)    = NaN;        
LWSo3_26m(ICal1==1)    = NaN;        
% Calibration Matrixs for 15 Jun 2015, sensitivity 0-600 wet; 600-6999
% sligthlywet
        %%% C1
%             [LWSo1_20mC1]       =[t_T2(ICal1==1) LWSo1_20m(ICal1==1)];
%             [LWSo3_26mC1]       =[t_T2(ICal1==1) LWSo3_26m(ICal1==1)];
clear LWS_1_AVG LWS_3_AVG ICal1

%% ------------ CHANGE OF POSITION 1 (19-Aug-15)----------------------------------------
% LWSo1_20m          Keep the same    
I2                   = (t_T2<datenum([2015 08 18 24 00 00]));

% Using the port2 = LWS2 to test ONE new sensor NewS2 at 24m
LWSn2_24m            = LWS_2_AVG; %---------------LWS2(Port2)
LWSn2_24m(I2==1)     = NaN; %Data previous to the date of installation is removed
% Remove data from previous position
LWSo3_24m            = LWSo3_26m;
% The previous data that belongs to LWSo3_26m replaced by NaN
LWSo3_24m(I2==1)     = NaN;% NewLine added on Dec2016

% Update values from LWSo3_26 after moving position
I3                   = ( t_T2>datenum([2015 08 19 09 30 00]));
LWSo3_26m(I3==1)     = NaN;
clear I2 I3
%------------ CALIB 2----------------------------------------
% Calibration of 3sensors (LW,1,2 LW3 at different levels) on 19-Aug-2015
% Data NaN
ICal2                = (t_T2>datenum([2015 08 19 09 30 00])& t_T2<datenum([2015 08 19 17 00 00]));
LWSo1_20m (ICal2==1)    = NaN;          
LWSn2_24m (ICal2==1)    = NaN;
LWSo3_24m (ICal2==1)    = NaN;        

% Calibration Matrixs on 19-Aug-2015 from 9:30 to 17:00 
% sligthlywet
        %%% C2
%             [LWSo1_20mC2]       =[t_T2(ICal2==1) LWSo1_20m (ICal2==1)];
%             [LWSn2_24mC2]       =[t_T2(ICal2==1) LWSn2_24m (ICal2==1)];
%             [LWSo3_24mC2]       =[t_T2(ICal2==1) LWSo3_24m (ICal2==1)];
% clear  LWSo1_20mC2 LWSn2_24mC2 LWSo3_24mC2
clear ICal2
%------------ CALIB 3----------------------------------------
% Calibration 28-Aug-2015 from 14:00 till 16:00
ICal3                = (t_T2>datenum([2015 08 28 12 00 00])& t_T2<datenum([2015 08 28 16 00 00]));

LWSo1_20m (ICal3==1)    = NaN;          
LWSn2_24m (ICal3==1)    = NaN;
LWSo3_24m (ICal3==1)    = NaN;        

clear ICal3

% Calibration Matrixs on 28-Aug-2015 
% sligthlywet
        %%% C3
%             [LWSo1_20mC3]       =[t_T2(ICal3==1) LWSo1_20m (ICal3==1)];
%             [LWSn2_24mC3]       =[t_T2(ICal3==1) LWSn2_24m (ICal3==1)];
%             [LWSo3_24mC3]       =[t_T2(ICal3==1) LWSo3_24m (ICal3==1)];

%% On Sep 1st CHANGE IN PROGRAM TO CORRRECT 101 VALUE IN LWS3
%% On Sep 7th sensor LWSn2 was removed and sent to the Company
% Sep-Aug-15 Around midday canopy still wet (observation from field)
% LWSo1_20m          Keep the same    
% LWSo3_24m          Keep the same    
% LWSn2_24m          Keep the same    

% Remove data (0) from sensor LWSn2_24m from 7sep 12:35 to 29 sep 11:03
I4                   = (t_T2>datenum([2015 09 07 12 35 00])& t_T2<=datenum([2015 09 29 11 03 00]));
LWSn2_24m(I4==1)     = NaN;
clear I4
%% LWSn2 moved from 24m to 20m on 29-Sep-2016 and conections ports changed

% LWSo1_20m          Keep the same    
LWSn4_20m             = LWS_4_AVG;
%Duplicate LWSo3_24m because data after 29-Sep will be replaced by data
%from LWSn2_24m
LWSo3_24m_copy        = LWSo3_24m; 

%LWSn2_20m Is new data set because new sensor S2 change from 24 to 20 m

LWSn2_20m             = LWSn2_24m;% Just change of position
I5                    = (t_T2>=datenum([2015 09 29 17 49 00]));
LWSo3_24m(I5==1)      = LWSn2_24m(I5==1);%----------> OK
LWSn2_20m(I5==1)      = LWSo3_24m_copy(I5==1);%----------> OK
LWSn2_24m(I5==1)      = NaN; %LWSn2_24m > datenum([2015 09 29 17 49 00])=NaN   OK
clear I5 LWSo3_24m_copy

I6                      = (t_T2<=datenum([2015 09 29 17 49 00]));
LWSn2_20m(I6==1)        =NaN;%%%%%------------> OK
LWSn4_20m(I6==1)        =NaN;    
% LWSo3_24m(I6==1)        =NaN;%NOOOOOOOOOOOOOOOOOOO bad line

clear I6
% Calibration on 30 Sep  from 00:00 till 24:00
ICal4                = (t_T2>datenum([2015 09 30 00 00 00])& t_T2<=datenum([2015 09 30 24 00 00]));

LWSo1_20m(ICal4==1)        =NaN;
LWSo3_24m(ICal4==1)        =NaN;
LWSn2_20m(ICal4==1)        =NaN;
LWSn4_20m(ICal4==1)        =NaN;
%%% C4
%             [LWSo1_20mC4]       =[t_T2(ICal4==1) LWSo1_20m(ICal4==1)];
%             [LWSn2_20mC4]       =[t_T2(ICal4==1) LWSn2_20m(ICal4==1)];
%             [LWSo3_24mC4]       =[t_T2(ICal4==1) LWSo3_24m(ICal4==1)];
%             [LWSn4_20mC4]       =[t_T2(ICal4==1) LWSn4_20m(ICal4==1)];
clear ICal4
%% 30 sep to 19 Oct remove data from LWSn2
I7                = (t_T2>datenum([2015 09 30 24 00 00])& t_T2<datenum([2015 10 19 15 00 00]));
% LWSo1_20m Keep the same
% LWSo3_24m Keep the same
LWSn2_20m(I7==1)        =NaN;
% LWSn4_20m Keep the same
clear I7
%% 19 Oct 2015 15:00; to Nov 3 keep the same
%% From 3 nov to 17-Apr-2016
% LWSo1_20m_copy             =LWSo1_20m;
% LWSo3_24m_copy             =LWSo3_24m;
% LWSn2_20m_copy             =LWSn2_20m;
% LWSn4_20m_copy             =LWSn4_20m;
%
PW4o1_21m             = LWSn4_20m;
PW3o3_23m             = LWSn2_20m;
PW2n2_25m             = LWSo3_24m;
PW1n1_27m             = LWSo1_20m;

I8                         = (t_T2>datenum([2015 11 03 13 00 00]));

LWSn4_20m(I8==1)        =NaN;
LWSn2_20m(I8==1)        =NaN;
LWSo3_24m(I8==1)        =NaN;
LWSo1_20m(I8==1)        =NaN;

clear I8
% Remove previous data to 3 Nov2015
I9                         = (t_T2<=datenum([2015 11 03 13 00 00]));

PW4o1_21m(I9==1)             = NaN;
PW3o3_23m(I9==1)             = NaN;
PW2n2_25m(I9==1)             = NaN;
PW1n1_27m(I9==1)             = NaN;
clear I9

% From 12 April PW2n2_25m and PW1n1_27m Sensors not reliable
I10                         = (t_T2>datenum([2016 04 12 00 00 00]));

PW2n2_25m(I10==1)             = NaN;
PW1n1_27m(I10==1)             = NaN;
clear I10
clear LWS_2_AVG LWS_4_AVG 

%% save 
save('c:\Speulderbos\Data\Met_LWS\MATFILE\MetAVG_LWS',...
    't_T2',...
    'LWSo1_20m',...
    'LWSo3_26m',...
    'LWSn2_24m',...
    'LWSn2_20m',...
    'LWSo3_24m',...
    'LWSn4_20m',...
    'PW1n1_27m',...
    'PW2n2_25m',...
    'PW3o3_23m',...
    'PW4o1_21m')

%%
load('c:\Speulderbos\Data\Met_LWS\MATFILE\MetAVG_LWS')
load ('C:\Speulderbos\Data\RainHobo\MATFILE\RHOBO_1_2')
load('C:\Speulderbos\Data\Met_AVG\05MATFILE\JoinRn_avg', 't_Rn', 'Rn_30min')
load ('C:\Speulderbos\Data\RainHobo\MATFILE\RHOBO_30min', 't_P30min', 'P_30min');
%% Plot of data availability
t_inicial         = datenum([2015 02 10 00 00 00]);
t_final           = datenum([2016 05 09 24 00 00]);
ttick           = datenum([0 0 1 0 0 0]);%[yyyy mm dd hh mm ss]
% ttick             = datenum([0 0 0 1 0 0]);%[yyyy mm dd hh mm ss]

figure()
hold on

plot (t_T2,(LWSo1_20m)./(LWSo1_20m)*20,'.','color','red')%
plot (t_T2,(LWSo3_26m)./(LWSo3_26m)*26,'.','color','blue')
plot (t_T2,(LWSo3_24m)./(LWSo3_24m)*24+0.5,'--','color','blue')%
plot (t_T2,(LWSn2_24m)./(LWSn2_24m)*24+0.2,'--','color','green')%

plot (t_T2,(LWSn2_20m)./(LWSn2_20m)*20+0.5,'--','color','green')%
plot (t_T2,(LWSn4_20m)./(LWSn4_20m)*20+0.2,'--','color','black')%

plot (t_T2,(PW1n1_27m)./(PW1n1_27m)*27,'-','color','green')%rand(1,3)
plot (t_T2,(PW2n2_25m)./(PW2n2_25m)*25,'-','color','black')%t_T2,LWSo3_26m
plot (t_T2,(PW3o3_23m)./(PW3o3_23m)*23,'-','color','blue')
plot (t_T2,(PW4o1_21m)./(PW4o1_21m)*21,'-','color','red')

% plot  (R(1).agg_wt,R(1).agg_mm*2000,'-r')
%             'PW1n1 27m' 'PW2n2 25m ' 'PW3o3 23m' 'PW4o1 20m'...
legend({'LWSo1 20m' 'LWSo3 26m'...
                    'LWSo3 24m' 'LWSn2 24m'...
                                'LWSn2 20m' 'LWSn4 20m'...
        'PW1n1 27m' 'PW2n2 25m ' 'PW3o3 23m' 'PW4o1 21m'...
             },'FontSize',8,'FontWeight','bold')
%     legend({'LWSo1 20m' 'LWSo3 26m '  },'FontSize',8,'FontWeight','bold')
%     set(gca,'xtick', t_inicial:ttick:t_final,'FontSize',7);%'xLim',[t_inicial  t_final],
%     datetick('x','dd HH:MM','keepticks')%'mm/dd HH:MM''keeplimits'
    
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech,'yLim' ,[18 28]);
ylabel('Height')
datetick('x', 'mmm-dd' ,'keepticks')

%% Plot of data  form different LWS and aat different positions on the trees


figure()
hold on
plot (t_T2,(LWSo1_20m),'*','color','red')%
plot (t_T2,(LWSo3_26m),'*','color','blue')
plot (t_T2,(LWSo3_24m),'*','color','yellow')%
plot (t_T2,(LWSn2_24m),'.','color','green')%
plot (t_T2,(LWSn2_20m),'.','color','green')%
plot (t_T2,(LWSn4_20m),'.','color','black')%

plot (t_T2,(PW1n1_27m),'.','color','green')%rand(1,3)
plot (t_T2,(PW2n2_25m),'.','color','black')%t_T2,LWSo3_26m
plot (t_T2,(PW3o3_23m),'.','color','blue')
plot (t_T2,(PW4o1_21m),'.','color','red')

%figure, hold on
plot(t_Rn, Rn_30min,'r')
plot (t_P30min, P_30min*1000, 'b');
% plot(ev_EBEC.lE_EC_day(2).t_EC+0.0104166666666667,1000*ev_EBEC.lE_EC_day(2).mm,'-ok')
plot  (R(1).agg_wt,R(1).agg_mm_cor*1000,'-y')



%             'PW1n1 27m' 'PW2n2 25m ' 'PW3o3 23m' 'PW4o1 20m'...
% 'LWSn2 24m'...
%                                 'LWSn2 20m' 'LWSn4 20m'...
% legend({'LWSo1 20m' 'LWSo3 26m'...
%                     'LWSo3 24m' ...
%         'PW1n1 27m' 'PW2n2 25m ' 'PW3o3 23m' 'PW4o1 21m'...
%              },'FontSize',8,'FontWeight','bold')
    
    anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm-dd' ,'keepticks')

%%
%/////////////////// ATTACK ON 17 APRIL ////////////////////////////
%% Average of Leaf wetness sensor
% [new_ts] = avg_xmin_v1(dat_num,variable,interval_min)
% plot (t_T2,(PW3o3_23m),'.','color','blue')
% plot (t_T2,(PW4o1_21m),'.','color','red')

[PW3o3_23m_avg30] = avg_xmin_v1(t_T2, PW3o3_23m, 30);
% isnan(PW3o3_23m)
t_PW3_avg30             = PW3o3_23m_avg30(:,1);
PW3_avg30               = PW3o3_23m_avg30(:,2)/3000;

[PW4o1_21m_avg30] = avg_xmin_v1(t_T2,PW4o1_21m,30);

t_PW4_avg30       = PW4o1_21m_avg30(:,1);
PW4_avg30         = PW4o1_21m_avg30(:,2)/3000;

% t_PW4_avg30,PW4_avg30
save('c:\Speulderbos\Data\Met_LWS\MATFILE\MetAVG_LWS30min', 't_PW3_avg30','PW3_avg30','t_PW4_avg30','PW4_avg30')
% load('c:\Speulderbos\Data\Met_LWS\MATFILE\MetAVG_LWS30min', 't_PW3_avg30','PW3_avg30','t_PW4_avg30','PW4_avg30')