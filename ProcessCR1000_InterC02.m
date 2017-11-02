%Script to process data from the dataloger CR1000 located al 37 m
%in the tower of Speulderbos,(CR1000)
% Author Cesar Cisneros
%%V0.1
%Diferent tables were download using loggernet :
% Table Meteo for CS216 (digital sensors)
%TRH Analog mode sensors
%Rotronic(1-3) HC2-S3C03: RH1a, RH2a, RH3a, , T1a, T2a, T3a, Rense RH4a, T4a (a=analog)
%SN #1 61474819 #2 61474838 #3 61474837 #4 HT 732H26

%TRH Digital mode sensors
% CS215: T1d...3d, RH1d...3d (d=digital)

%%V0.2
%Programmed in order to do intercalibration with sensors placed at the same
%conditions
% only one table is created for the 3digital and 4 analog sensors, the RH
% from the Rense sensor seems to be not working
% Downloaded files should be first corrected by changing NaN values into
% -9999 usign batch script or anyother way

%% /////////////////Setting the directories and files/////////////////////

path2                           =      'c:\Speulderbos\Data\CR1000\02InterCData\';
f                       =       dir(fullfile(path2,'TRHInt201506151011ed.dat'));

%%If only one file is needed to be processed, then copy the name of the
%%file and replace '*.dat' (previous solution of change i=#of file doesn't work because alter the if condition i>1)

t_trh                     = [];  %t=time
data_trh                  = [];  %all thr records

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
    data_trh                =      [data_trh; trh(i).data];
                      
end
%%      
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
%T1d_Avg,T2d_Avg,T3d_Avg,T1a_Avg,T2a_Avg,T3a_Avg,T4a_Avg
%RH1d_Avg,RH2d_Avg,RH3d_Avg,RH1a_Avg,RH2a_Avg,RH3a_Avg,RH4a_Avg
% figure()
% subplot(211)
% plot(t_trh,[T1d_Avg,T2d_Avg,T3d_Avg,T1a_Avg,T2a_Avg,T3a_Avg,T4a_Avg])
% legend({'T1d' 'T2d' 'T3d' 'T1a' 'T2a' 'T3a' 'T4a'},'FontSize',8,'FontWeight','bold')
% datetick('x')
% grid on
% 
% subplot(212)
% plot(t_trh,[RH1d_Avg,RH2d_Avg,RH3d_Avg,RH1a_Avg,RH2a_Avg,RH3a_Avg,RH4a_Avg])
% legend({'RH1d' 'RH2d' 'RH3d' 'RH1a' 'RH2a' 'RH3a' 'RH4a'},'FontSize',8,'FontWeight','bold')
% datetick('x')
% grid on

%% Filter out Time interval for intercalibration()
inter_start         =datenum([2015 06 10 13 00 00]);
inter_end           =datenum([2015 06 15 10 10 00]);

I_int_time          = find (t_trh>inter_start & t_trh<inter_end);

T1d_i               =T1d_Avg(I_int_time);
RH1d_i              =RH1d_Avg(I_int_time);
T2d_i               =T2d_Avg(I_int_time);
RH2d_i              =RH2d_Avg(I_int_time);
T3d_i               =T3d_Avg(I_int_time);
RH3d_i              =RH3d_Avg(I_int_time);
T1a_i               =T1a_Avg(I_int_time);
RH1a_i              =RH1a_Avg(I_int_time);
T2a_i               =T2a_Avg(I_int_time);
RH2a_i              =RH2a_Avg(I_int_time);
T3a_i               =T3a_Avg(I_int_time);
RH3a_i              =RH3a_Avg(I_int_time);
T4a_i               =T4a_Avg(I_int_time);
RH4a_i              =RH4a_Avg(I_int_time);


%% Filter out time outliers
%NEW TIME FOUNDED
t_trh_int                  =t_trh(I_int_time);

I_out1                     = find(diff(T3a_i) >= 1 | diff(T3a_i) <= -1);
% It was founded that ther is a gap with bad data from 2015/6/12 13 38 00 until 2015/6/12 13 46 00
% datevec(t_trh_int(I_out1))
I_out2                     =[I_out1(1):I_out1(end)]';

%%
t_trh_int(I_out2)           =NaN;

T1d_i(I_out2)               =NaN;
RH1d_i(I_out2)              =NaN;
T2d_i(I_out2)               =NaN;
RH2d_i(I_out2)              =NaN;
T3d_i(I_out2)               =NaN;
RH3d_i(I_out2)              =NaN;
T1a_i(I_out2)               =NaN;
RH1a_i(I_out2)              =NaN;
T2a_i(I_out2)               =NaN;
RH2a_i(I_out2)              =NaN;
T3a_i(I_out2)               =NaN;
RH3a_i(I_out2)              =NaN;
T4a_i(I_out2)               =NaN;
RH4a_i(I_out2)              =NaN;

mat_TRH     =[];
mat_TRH     =[t_trh_int T1d_i T2d_i T3d_i T1a_i T2a_i T3a_i T4a_i RH1d_i RH2d_i RH3d_i RH1a_i RH2a_i RH3a_i];

clear t_trh_int T1d_i T2d_i T3d_i T1a_i T2a_i T3a_i T4a_i RH1d_i RH2d_i RH3d_i RH1a_i RH2a_i RH3a_i
clear T1d_Avg T2d_Avg T3d_Avg T1a_Avg T2a_Avg T3a_Avg T4a_Avg
clear RH1d_Avg RH2d_Avg RH3d_Avg RH1a_Avg RH2a_Avg RH3a_Avg RH4a_Avg

TRH          =mat_TRH(~any(isnan(mat_TRH),2),:); %taking out NAN values, if any value is NAN in any row the complete row is eliminated.
t_trh_ed                    = TRH(:,1); %1
T1d_ed                      = TRH(:,2); %2 %1
T2d_ed                      = TRH(:,3); %3 %2
T3d_ed                      = TRH(:,4); %4 %3
T1a_ed                      = TRH(:,5); %5 %4
T2a_ed                      = TRH(:,6); %6 %5
T3a_ed                      = TRH(:,7); %7 %6
T4a_ed                      = TRH(:,8); %8
RH1d_ed                     = TRH(:,9); %9
RH2d_ed                     = TRH(:,10); %10
RH3d_ed                     = TRH(:,11); %11
RH1a_ed                     = TRH(:,12); %12
RH2a_ed                     = TRH(:,13); %13
RH3a_ed                     = TRH(:,14); %14


%% Plot

%%%%%%%%%%%%%%%%%%%RH4a_i is excluded

figure(1)
subplot(211)
plot(t_trh_ed,[T1d_ed,T2d_ed,T3d_ed,T1a_ed,T2a_ed,T3a_ed,T4a_ed])
legend({'T1d' 'T2d' 'T3d' 'T1a' 'T2a' 'T3a' 'T4a'},'FontSize',8,'FontWeight','bold')
datetick('x')
grid on

subplot(212)
plot(t_trh_ed,[RH1d_ed,RH2d_ed,RH3d_ed,RH1a_ed,RH2a_ed,RH3a_ed])
legend({'RH1d' 'RH2d' 'RH3d' 'RH1a' 'RH2a' 'RH3a' 'RH4a'},'FontSize',8,'FontWeight','bold')
datetick('x')
grid on


%% Intercalibration
%Reference sensor T1d_ed   and RH1d_ed    
% SO,  y=T1d_ed;
%      x=T2d_ed;

T  = TRH(:,2:7); %col #8 is exluded it belongs to T4A
RH = TRH(:,9:14);

%%%% New solution implemented after Christiaan script%%%%
%A is the matrix with coef factors of Temperature
A = zeros(6,3);%size(T,2) to get number of cols(number of T sensors), times 3 parameters from regression coef.
A(5,2) = 1;% A(1,2) = 1;
%B is the matrix with coef factors of RH
B = zeros(6,3);
B(5,2) = 1;%B(1,2) = 1;

Tcor    = T;
RHcor   = RH;

for i = 4:2:6;% ;%Change the values to place the coefficients in the final matrix properly
    
%    A(i,2:3) = linreg(T(:,i),T(:,1));
%    B(i,2:3) = linreg(RH(:,i),RH(:,1));
%    A(i,2:3) = polyfit(T(:,i),T(:,1),1);
%    B(i,2:3) = polyfit(RH(:,i),RH(:,1),1);
    
    A(i,2:3) = polyfit( T(~isnan(T(:,i)),i),T(~isnan( T(:,i)),5),1);%Change the value of 5 to generate new coefficients based on new reference
    B(i,2:3) = polyfit(RH(~isnan(RH(:,i)),i),RH(~isnan(RH(:,i)),5),1);%Change the value of 5 to generate new coefficients based on new reference
    
    Tcor(:,i)   = T(:,i)*A(i,2) + A(i,3);
    RHcor(:,i)  = RH(:,i)*B(i,2) + B(i,3);   
end

for i = 1:3
    A(i,:) = polyfit( T(~isnan( T(:,i)),i), T(~isnan( T(:,i)),5),2);
    B(i,:) = polyfit(RH(~isnan(RH(:,i)),i),RH(~isnan(RH(:,i)),5),2);
    Tcor(:,i)   = T(:,i).^2 *A(i,1)  +  T(:,i)*A(i,2) + A(i,3);
    RHcor(:,i)  = RH(:,i).^2*B(i,1)  + RH(:,i)*B(i,2) + B(i,3);
end

r = zeros(size(T,2),4);

for i = [1 2 3 4 6]%    2:size(T,2)
    r(i,1) = sqrt(mean((T(~isnan(mean(T,2)),i)-T(~isnan(mean(T,2)),5)).^2));       
    r(i,2) = sqrt(mean((RH(~isnan(mean(RH,2)),i)-RH(~isnan(mean(RH,2)),5)).^2));
    r(i,3) = sqrt(mean((Tcor(~isnan(mean(Tcor,2)),i)-Tcor(~isnan(mean(Tcor,2)),5)).^2));
    r(i,4) = sqrt(mean((RHcor(~isnan(mean(RHcor,2)),i)-RHcor(~isnan(mean(RHcor,2)),5)).^2));
end

%Old Solution
%%%%%%%%% This solution can be tested as an exercise to validate 
% p = polyfit(x,y,1); %y is the reference
% yfit = polyval(p,x);
% yresid = y - yfit;
% SSresid = sum(yresid.^2);
% SStotal = (length(y)-1) * var(y);
% rsq = 1 - SSresid/SStotal

Tresid     = T-Tcor;
RHresid    =RH-RHcor;
SSresidT = sum(Tresid.^2);

SSresidRH = sum(RHresid.^2);
SStotalT = (length(T)-1) * var(T);
SStotalRH = (length(RH)-1) * var(RH);

rsqT =1 - SSresidT./SStotalT;
rsqRH =1 - SSresidRH./SStotalRH;

CC = [A,B];
save([path2 'RHTcalibRefTRH2a.txt'], 'CC','-ascii', '-tabs')

%% Plot
%%%%%%%%%%%%%%%%%%%RH4a_i is excluded
figure(50)
subplot(211)
plot(t_trh_ed,[Tcor])
% legend({'T1d' 'T2d' 'T3d' 'T1a' 'T2a' 'T3a' 'T4a'},'FontSize',8,'FontWeight','bold')
datetick('x')
grid on
% 
subplot(212)
plot(t_trh_ed,[RHcor])
% legend({'RH1d' 'RH2d' 'RH3d' 'RH1a' 'RH2a' 'RH3a' 'RH4a'},'FontSize',8,'FontWeight','bold')
datetick('x')
grid on

%% plotting the results

minT = min(min(T))-.1;
maxT = max(max(T))+.1;

figure(2), clf

for i = [1 2 3 4 6]%2:size(T,2)
    
    subplot(3,2,i);
%     str = sprintf('Sensor = %f',i);
%     title(j,'str');
    plot(T(:,5),T(:,i),'x')
    set(gca,'xlim',[minT maxT])
    set(gca,'ylim',[minT maxT])
    hold on
    plot([minT maxT],[minT maxT],'k')
    xlabel('T_{SN 61474838 (CS215)} (^oC)')
    ylabel('T_{other sensor} (^oC)')
    
end


minRH = min(min(RH))-.1;
maxRH = max(max(RH))+.1;


figure(3), clf
for i = [1 2 3 4 6] %2:size(RH,2)
   
    subplot(3,2,i)
    plot(RH(:,5),RH(:,i),'x')
    set(gca,'xlim',[minRH maxRH])
    set(gca,'ylim',[minRH maxRH])
    hold on
    plot([minRH maxRH],[minRH maxRH],'k')
    xlabel('RH_{SN 61474838 (CS215)} (%)')
    ylabel('RH_{other sensor} (%)')
    
end

minTcor = min(min(Tcor))-.1;
maxTcor = max(max(Tcor))+.1;

figure(4), clf
for i = [1 2 3 4 6]%2:size(Tcor,2)
    
    subplot(3,2,i)
    plot(Tcor(:,5),Tcor(:,i),'x')
    set(gca,'xlim',[minTcor maxTcor])
    set(gca,'ylim',[minTcor maxTcor])
    hold on
    plot([minTcor maxTcor],[minTcor maxTcor],'k')
    xlabel('Tcor_{SN 61474838 (CS215)} (^oC)')
    ylabel('Tcor_{other sensor} (^oC)')
    
end


minRHcor = min(min(RHcor))-.1;
maxRHcor = max(max(RHcor))+.1;



figure(5), clf
for i = [1 2 3 4 6]%2:size(RHcor,2)
   
    subplot(3,2,i)
    plot(RHcor(:,5),RHcor(:,i),'x')
    set(gca,'xlim',[minRHcor maxRHcor])
    set(gca,'ylim',[minRHcor maxRHcor])
    hold on
    plot([minRHcor maxRHcor],[minRHcor maxRHcor],'k')
    xlabel('RHcor_{SN 61474838 (CS215)} (%)')
    ylabel('RHcor_{other sensor} (%)')
    
end



