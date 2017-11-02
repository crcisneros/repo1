%% Scrip to read AVG.txt files
% path    = 'C:\Speulderbos\Data\Met_AVG\avg_ready\';
% path    = 'C:\Speulderbos\Data\Met_AVG\newready\';
path                               = 'c:\Speulderbos\Data\CR3000\USB\';
addpath                               c:\Speulderbos\Processing\MatlabProcess\auxscripts\;

files      =      dir(fullfile(path,'*.dat'));

tfile    =       [];

for i = 1:length(files)
    
    F(i).name             =       files(i).name; %files_trh(i).name; 
    F(i).data             =       textscan(fopen(fullfile(path,(F(i).name))), '%s %*[^\n]',...
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
% %%
% % The idea is to join all the edited files in one according to the identified columns
% ftot    =       [];
% for i=1 : length(files) 
%     f(i).name                      =       files(i).name; 
%     f(i).data                      =       dlmread(fullfile(path,(files(i).name)),',',1,1);
%     ftot                           =       [ftot;f(i).data];
% 
% end
