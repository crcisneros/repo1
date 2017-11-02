% load ('C:\Speulderbos\Data\RainHobo\MATFILE\RHOBO_1_2','R')
Ical                    = find(R(1).agg_wt>datenum([2016 07 27 16 23 00]));
% Changing resolution from 0.2 to 0.21 considering volmetric calibration
rainTBRG1_cal           = R(1).agg_mm(Ical)*(0.21/0.2);
rainTBRG1_tim           = R(1).agg_wt(Ical);

%% Calibration formula
% #9 Rain Collector II
% DAVIS
% Parameters
%(RI=a·(RIref)^b)
a = 1.16;
b = 0.92;
% R2=  0.73

%% Plot Rainfall per minute

R_1minRaw               = rainTBRG1_cal*60;
Rcorr_1min              = (R_1minRaw./a).^(1/b);
Pcorr1min               = Rcorr_1min/60;

figure
plot(rainTBRG1_tim, R_1minRaw, 'b')
tickTime                = [round(rainTBRG1_tim(1)):5:round(rainTBRG1_tim(end))];
title('Intensities 1 minute interval mm/h')

set(gca, 'xtick',tickTime,'fontsize',9)
datetick('x', 'dd-mm','keepticks')

%% Histogram
%hist(rainTBRG1_cal(rainTBRG1_cal>0)*60,20)

%% Check the intervals collected with bottles

tm0= [2016	7	27	15	23 0];
tm1= [2016	8	4	14	27 0];
tm2= [2016	8	10	13	24 0];
tm3= [2016	8	18	17	44 0];
tm4= [2016	9	9	13	37 0];
tm5= [2016	10	14	14	35 0];


tdev0= [2016	9	13	15	0	0];
tdev1= [2016	9	16	15	0	0];
tdev2= [2016	9	26	15	0	0];
tdev3= [2016	10	24	10	0	0];
%% Limiting 1st period
Ip1= find(rainTBRG1_tim<= datenum(tm1));
Ip2= find(rainTBRG1_tim> datenum(tm1)& rainTBRG1_tim <= datenum(tm2));
Ip3= find(rainTBRG1_tim> datenum(tm2)& rainTBRG1_tim <= datenum(tm3));
Ip4= find(rainTBRG1_tim> datenum(tm3)& rainTBRG1_tim <= datenum(tm4));
Ip5= find(rainTBRG1_tim> datenum(tm4)& rainTBRG1_tim <= datenum(tm5));
%%%%%%%
Idev1= find(rainTBRG1_tim> datenum(tdev0)& rainTBRG1_tim <= datenum(tdev1));
Idev2= find(rainTBRG1_tim> datenum(tdev1)& rainTBRG1_tim <= datenum(tdev2));
Idev3= find(rainTBRG1_tim> datenum(tdev2)& rainTBRG1_tim <= datenum(tdev3));
%% Plot cummuative rainfall and P corrected 1 min

figure
plot(rainTBRG1_tim,cumsum(rainTBRG1_cal),'b')
hold on
plot(rainTBRG1_tim,cumsum(Pcorr1min),'r')
plot(rainTBRG1_tim(Ip1),cumsum(Pcorr1min(Ip1)),'xk')
plot(rainTBRG1_tim(Ip2),cumsum(Pcorr1min(Ip2)),'xk')
plot(rainTBRG1_tim(Ip3),cumsum(Pcorr1min(Ip3)),'xk')
plot(rainTBRG1_tim(Ip4),cumsum(Pcorr1min(Ip4)),'xk')
plot(rainTBRG1_tim(Ip5),cumsum(Pcorr1min(Ip5)),'xk')
plot(datenum([tm0;tm1;tm2;tm3;tm4;tm5]),ones(1,6),'or')
tickTime                = [round(rainTBRG1_tim(1))-1:5:round(rainTBRG1_tim(end))];
title('Intensities 1 minute interval mm/h')
set(gca, 'xtick',tickTime,'fontsize',9)
datetick('x', 'dd-mm','keepticks')

%% %%%%%
%%  Separate rainfall per 10 minutes periods, kind of cummulative

[Rain10Min] = agg_xmin_v3(rainTBRG1_tim,rainTBRG1_cal,10);

TBRG1_P10Min= Rain10Min(:,2);
R_10minRaw = TBRG1_P10Min*6;
TBRG1_time10Min= Rain10Min(:,1);
clear Rain10Min

Rcorr_10min              = (R_10minRaw./a).^(1/b);
Pcorr_10min             = Rcorr_10min./6;
figure
plot(TBRG1_time10Min,cumsum(TBRG1_P10Min),'b');
hold on
plot(TBRG1_time10Min,cumsum(Pcorr_10min),'r');
%%
% Validation of Subtotal for the 1st period
%%
I10p1= find(TBRG1_time10Min<= datenum(tm1));
I10p2= find(TBRG1_time10Min> datenum(tm1)& TBRG1_time10Min<= datenum(tm2));
I10p3= find(TBRG1_time10Min> datenum(tm2)& TBRG1_time10Min <= datenum(tm3));
I10p4= find(TBRG1_time10Min> datenum(tm3)& TBRG1_time10Min <= datenum(tm4));
I10p5= find(TBRG1_time10Min> datenum(tm4)& TBRG1_time10Min <= datenum(tm5));
%%


cumsum(Pcorr_10min(I10p1))
cumsum(Pcorr_10min(I10p2))
cumsum(Pcorr_10min(I10p3))
cumsum(Pcorr_10min(I10p4))
cumsum(Pcorr_10min(I10p5))
%%
cumsum(Pcorr1min(Idev1))
cumsum(Pcorr1min(Idev2))
cumsum(Pcorr1min(Idev3))


%% Cumulative totals

cumsum(Pcorr_10min(Ip1))
cumsum(Pcorr_10min(Ip2))
cumsum(Pcorr_10min(Ip3))
cumsum(Pcorr_10min(Ip4))
cumsum(Pcorr_10min(Ip5))



% Plot rainfall INtensities
figure
plot(TBRG1_time10Min,R_10minRaw )
tickTime =[round(rainTBRG1_tim(1)):5:round(rainTBRG1_tim(end))];
title('Rainfall Intensities 10 min interval mm/h')
set(gca, 'xtick',tickTime,'fontsize',9)
datetick('x', 'dd-mm','keepticks')







%% Interval 15 minutes


%%  Separate rainfall per 10 minutes periods, kind of cummulative

[Rain15Min] = agg_xmin_v3(rainTBRG1_tim,rainTBRG1_cal,15);

TBRG1_P15Min= Rain15Min(:,2);
R_15minRaw = TBRG1_P15Min*4;

TBRG1_time15Min= Rain15Min(:,1);
clear Rain15Min

% Plot rainfall INtensities
figure
plot(TBRG1_time15Min,R_15minRaw )
tickTime =[round(rainTBRG1_tim(1)):5:round(rainTBRG1_tim(end))];
title('Rainfall Intensities 15 min interval mm/h')
set(gca, 'xtick',tickTime,'fontsize',9)
datetick('x', 'dd-mm','keepticks')



%%
[SumFil,MaxFil,numEvenFil,eventID,rainHours,sumAllEv,maxAllEv] = storm_separ_v1(rainTBRG1_cal,rainTBRG1_tim,120,0.4);
lenRHour=length(rainHours);
rainHours{lenRHour}=[0];
tini=cellfun(@(x) x(1),rainHours,'UniformOutput',false);
tend=cellfun(@(x) x(end),rainHours,'UniformOutput',false);

% datevec(cell2mat(tini)) %Test

difT=cell2mat(tend)-cell2mat(tini);
HourEvent=hour(difT)+minute(difT)/60;
RInt=sumAllEv./HourEvent;
RIntFilt3h=RInt(~isinf(RInt)&~isnan(RInt))';

suma_acum= cumsum(rainTBRG1_cal);
defEvent =rainTBRG1_tim(eventID);
defAcumEv= suma_acum(eventID);
RInt2=[RInt 0];
%%   Plot rainfall Events and Partial intensities

plot(rainTBRG1_tim,suma_acum)
hold on
plot(rainTBRG1_tim(eventID),suma_acum(eventID),'xr')
tickTime =[round(rainTBRG1_tim(1)):5:round(rainTBRG1_tim(end))];
set(gca, 'xtick',tickTime,'fontsize',9)
datetick('x', 'dd-mm','keepticks')
for i=1:length(defEvent)
text(defEvent(i) ,defAcumEv(i)+5, sprintf('%d', round(RInt2(i))), 'FontSize',9);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


