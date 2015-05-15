%Script to process data from the dataloger CR23x located in the forest
%floor of Speulderbos,(named as CR23X_2 or CR23Xsoil)
%Id's for for diferent records weere specified as:
%  2: Tippingbucket table
%137: Table1 in the old program version before modify to installing sapflow sensors
%132: Table1 after 01 of May 2015 13:10(doy121), considering 3 sapflow sensors
% Author Cesar Cisneros

%% /////////////////Setting the directories and files/////////////////////
% files  sometimes are not well stored, then there are mistakes in the
% script
path                        = 'c:\Speulderbos\Data\CR23xSoil\';
files                       =      dir(fullfile(path,'*.dat'));

%%Change the data from 5 to 1 if all txt files are needed

stot    = [];
   
for i= 1 : 5%length(files) 
    s(i).name               =       files(i).name; 
    s(i).data               =       dlmread(fullfile(path,(files(i).name)),',',0,0);
    [a , b]                 =       size(s(i).data); 
    [c , d]                 =       size (stot);
    
       if d <= b && i > 2
                stot(c,b)           =       0;
                stot                =       [stot; s(i).data];  
       else

                stot                =       [stot; s(i).data];
    
    end
end
%%      
stot(abs(stot)>6000)        = NaN;
%% Finding tables

II                          = find(stot(:,1)==132);             %creating index to split in two different files
JJ                          = find(stot(:,1)==2);
KK                          = find(stot(:,1)==137);

stot132                     = stot(II,:); % it has records with indicator 132 (soil measurements & sapflow)
stot2                       = stot(JJ,:); % it has records with indicator 2   (Tipping bucket table)
stot137                     = stot(KK,:); % it has records with indicator 137 (before sapflow measurements

%% Date&Time for different tables

%Time for Table2(TippingBuk)
yt2                         = stot2(:,2);                      %get year
hourt2                      = floor(stot2(:,4)/100);           %get hour
minutet2                    = stot2(:,4)-hourt2*100;             %get minute
secondst2                   = stot2(:,5);                      %get seconds   
tim_soil_t2                 = stot2(:,3)+hourt2/24 + minutet2/24/60 + secondst2/86400;

%Time for Table132
yt132                       = stot132(:,2);                      %get year
hourt132                    = floor(stot132(:,4)/100);           %get hour
minutet132                  = stot132(:,4)-hourt132*100;         %get minute
secondst132                 = stot132(:,5);                      %get seconds   
tim_soil                    = stot132(:,3)+hourt132/24 + minutet132/24/60 + secondst132/86400;

dosm15                      =datenum([2015 00 00 0 0 0]);   % year 2015 addet to date from CR23x data file

%//////////////Time in datenumber included year//////////////////////////
t_soil                      =tim_soil+dosm15; 
%////////////////////////////////////////////////////////////////////////


%% Converting tips to mm of rainfall
Tip1                        = stot2(:,6); 
Tip2                        = stot2(:,7); 

res_tip1                    =0.083; %This values should be verified some time after installation
res_tip2                    =0.083;

% Tipp1= SN141201 (located close to the tower)& Tipp2= SN141202(located  closest to the border)
thr1mm                      = Tip1*res_tip1;
thr2mm                      = Tip2*res_tip2;

dosm15                      =datenum([2015 00 00 0 0 0]);   % year 2015 addet to date from CR23x data file

%//////////////Time in datenumber included year//////////////////////////
t_tipp                      =tim_soil_t2+dosm15; 
%////////////////////////////////////////////////////////////////////////


%% Ploting Through vs Time
figure()
plot(t_tipp,thr1mm,'xr',t_tipp,thr2mm,'xb')
legend({'thr1mm','thr2mm'},'FontSize',8,'FontWeight','bold')
datetick('x')
grid on
% Plot with dates

%% Processing Sapflow  (Temperature difference)
% Temperature diferences are measured on mv and then multiplied  by 25 to
% convert them to Celsius degrees
% 
% ambient Temperature in the tree -20°C … -10° Factor 37.4 ?V/°C
% ambient Temperature in the tree -10°C … 0° Factor 38.3 ?V/°C
% ambient Temperature in the tree 0°C … 10° Factor 39.1 ?V/°C
% ambient Temperature in the tree 10°C … 20° Factor 39.8 ?V/°C
% ambient Temperature in the tree 20°C … 30° Factor 40.7 ?V/°C
% ambient Temperature in the tree 30°C … 40° Factor 41.5 ?V/°C
Tdiff1                      = stot132(:,25);
Tdiff2                      = stot132(:,26);
Tdiff3                      = stot132(:,27);

%% Plot Temp Diff from Granier sensors and Air Temperature at forest floor level scaled to 0.01
figure()
plot(t_soil,[Tdiff1,Tdiff2,Tdiff3,stot132(:,11)/100])
datetick('x')


 


