%% Net radiation
function ProcessJoinNetRadiation()
load('C:\Speulderbos\Data\Met_AVG\05MATFILE\MetAVG_RN35m', 'Rn_35m_avg');% Importing average 30min matrix 3 cols
load('C:\Speulderbos\Data\CNR4\MATFILE\CNR4_Rn','Rn_45m_avg');   % Importing average 30min matrix 3 cols
t_Rn                    = Rn_35m_avg(:,1);
Rn_30min                = Rn_35m_avg(:,2);


t_Rn2                    = Rn_45m_avg(:,1);
Rn_30min2                = Rn_45m_avg(:,2);

%Rn CNR1 
I_Rn1                   = find(t_Rn> datenum([2016 06 23 17 00 00]) & t_Rn< datenum([2016 10 30 24 00 00])); % First date CNR4 [2016 06 23 17 00 00]
I_Rn2                   = find(t_Rn2> datenum([2016 06 23 17 00 00])  & t_Rn2< datenum([2016 10 30 24 00 00])); % 
% length(I_Rn1)
% length(I_Rn2)
Rn_30min(I_Rn1)         =Rn_30min2(I_Rn2);
save('C:\Speulderbos\Data\Met_AVG\05MATFILE\JoinRn_avg', 't_Rn', 'Rn_30min')
% load('C:\Speulderbos\Data\Met_AVG\05MATFILE\JoinRn_avg', 't_Rn', 'Rn_30min')
end