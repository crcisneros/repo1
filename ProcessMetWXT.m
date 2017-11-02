%% Scrip to read WXT.txt files
path    = 'c:\Speulderbos\Data\VaisWXT\';

files   =      dir(fullfile(path,'*.txt'));
% files  sometimes are not well stored, then there are mistakes in the
% script
t=[];
xtot=[];
%%
for i = 3:length(files)                          
    
    w(i).name     =       files(i).name; 
    w(i).data     =       textscan(fopen(fullfile(path,(files(i).name))), '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]', 'HeaderLines', 1,'delimiter', ',');
    
    formatIn      =       'dd-mm-yyyy HH:MM:SS';

    tnum          =       datenum(w(i).data{1,1},formatIn);
    t             =       [t; tnum];
    data          =       w(i).data{1,:}  ;
    
    x(i).data =       dlmread(fullfile(path,(files(i).name)),',',1,1);
    xtot      =      [xtot;x(i).data];
    
    fclose('all');
end

%%      
xtot(abs(xtot)>6000) = NaN;

TWXT       =   xtot(:,18);  %Temperature
RHWXT       =   xtot(:,20);
RcWXT       =   xtot(:,25);  %Rc Rain accumulation
RdWXT       =   xtot(:,26);  %Rd Rain duration
RiWXT       =   xtot(:,27);  %Ri Rain intensity

%% Rename t
t_vai=t;   %time


%%
% [a b]=size(xtot);
% 
% for i=1:b
%    figure(i) 
%    plot(t,xtot(:,i))
%    datetick('x')
% end

%% Plot T, Rh, rain
%time tick
time_tk=datenum([0 0 5 0 0 0]);%[yyyy mm dd hh mm ss]

figure()
subplot(3,1,1)
plot(t,[cumsum(RcWXT) cumsum(RiWXT)],'r-') %date_rain_num,cumsum(day_rain),'-k'
legend({'R cum(mm)'},'FontSize',8,'FontWeight','bold')
set(gca,'xtick', t(1,1):time_tk:t(end,1), 'xlim',[t(1,1) t(end,1)],'FontSize',7 );
datetick('x', 'keepticks')

grid on

subplot(3,1,2)
plot(t,[RiWXT ],'g-')
legend({'RIntensity(mm/h)'},'FontSize',8,'FontWeight','bold')
set(gca,'xtick', t(1,1):time_tk:t(end,1), 'xlim',[t(1,1) t(end,1)],'FontSize',7 );
datetick('x', 'keepticks')

grid on

subplot(3,1,3)
plot(t,[RcWXT ])
legend({'Rain mm)'},'FontSize',8,'FontWeight','bold')
set(gca,'xtick', t(1,1):time_tk:t(end,1), 'xlim',[t(1,1) t(end,1)],'FontSize',7.5 );
datetick('x', 'keepticks')
grid on
%% 
% figure()
% plot(t,[TWXT RHWXT RcWXT  ])
% legend({'T(C)','RH(%)','Rain cum(mm)'},'FontSize',8,'FontWeight','bold')
% datetick('x')

%% Converting t to tWXT
%t_WXT=diano2(t); %convierte a doy sin anio 


%% Precipitation resolution
% n_res    =0;   %excluded value
% 
% RdWXT2 = RdWXT;
% I_mt_nres = find(RcWXT > n_res);
% I_let_nres = find(RcWXT <= n_res);
% 
% RdWXT2=RdWXT(I_mt_nres);
% RcWXT2=RcWXT(I_mt_nres);
% sum(RcWXT2*RdWXT2)
% new_RcWXT = RcWXT(I_mt_nres);
% sum(new_RcWXT)

%% date sum
date_ini = datenum([2015 03 25 00 00 01]);
date_fin = datenum([2015 03 25 23 59 59]);

% 
% RcWXT_interval = [];
% 
% I_interval = find(t >= date_ini & t < date_fin);
% 
% RcWXT_interval= RcWXT(I_interval);
% 
% SUMA= sum(RcWXT_interval);
