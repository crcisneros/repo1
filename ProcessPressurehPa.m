load('c:\Speulderbos\Data\CR23xSoil\MATFILE\CR213Tab1Tab2')


% pa          : Air pressure (hPa)
% From ProcessSapFlow02 script
tPrg03                           = datenum([2015 06 19 00 00 0]); %
toff2015                         = datenum([2016 11 01 00 00 00]);   
I_p03                            = find(t_soil>=tPrg03 & t_soil< toff2015);

t_phPa                           = t_soil(I_p03);
press_hPa                           = table1(I_p03,7); % From summer 2016 seems to be wrong data
% numel(t_phPa)
% datevec(t_phPa(end))
% numel(press_hPa)
%% Calculate  avg 30 min

[press_hPa_avg30]                  = avg_xmin_v3(t_phPa,press_hPa,30);

t_press_hPa_avg30                  = press_hPa_avg30(:,1);
press_hPa_avg30                    = press_hPa_avg30(:,2);
% datevec(t_press_hPa_avg30(1:2))
% datevec(t_press_hPa_avg30(end))

save('c:\Speulderbos\Data\CR23xSoil\MATFILE\AriPress30min',...
    't_press_hPa_avg30','press_hPa_avg30')
% load('c:\Speulderbos\Data\CR23xSoil\MATFILE\AriPress30min')

%%
figure()
hold on
plot(t_phPa,press_hPa,'r')
plot(t_30minTRH,es_16m.*(RH16m_raw30min/100))
anio=[repmat(2015,12,1); repmat(2016,12,1)];
mes=repmat((1:12)',2,1);
fech=datenum([anio mes ones(24,1)]);
set(gca,'xtick',fech);
datetick('x', 'mmm' ,'keepticks')


