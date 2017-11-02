% This script processs data from water content reflectometers.
% We used calibration equations from the default (Manual Campbell
% Scientific).
%These coefficients should provide accurate volumetric water content in 
% mineral soils with bulk electrical conductivity less than 0.5 dS m-1, 
% bulk density less than 1.55 g cm-3, and clay content less than 30%.
%% The same processing was proposed in Eagle  FInal Report document.(c:\Speulderbos\Documentation\)
% Because the sensors were not calibrated for the specific soil, a standard calibration for soils
% with an electric conductivity less than 0.5 dS/m and a density less than 1.55 g/cm3 and a clay
% content of less than 30% was used. The values for soil moisture content calculated in this way
% are unusually lower.
%% % First import data, then Processing 
 function ProcessSoilVWC()
addpath                    c:\Speulderbos\Processing\MatlabProcess\functions\

load ('c:\Speulderbos\Data\CR23xSoil\MATFILE\CR213Tab1Tab2' ,'table1','t_soil');
load ('C:\Speulderbos\Data\RainHobo\MATFILE\RHOBO_1_2')
%%  table1 contain data from soil sensors

tPrg03                           = datenum([2015 06 19 00 00 0]); 
toff2015                         = datenum([2016 11 01 00 00 00]);   
I_p03                            = find(t_soil>=tPrg03 & t_soil< toff2015);
% From ProcessSapFlow02 script
t_soil_p03                         = t_soil(I_p03);
%% Soil Moisture in ms it has to be converted to VWC (volumetric water content)
% ;8 SoilMo_1_AVG  L		SMC05       : Soil moisture signal (ms) at 5 cm depth Campbell Sci. Inc. CS616
% ;9 SoilMo_2_AVG  L		SMC30       : Soil moisture signal (ms) at 30 cm depth Campbell Sci. Inc. CS616
% ;10 SoilMo_3_AVG  L		SMC55       : Soil moisture signal (ms) at 55 cm depth Campbell Sci. Inc. CS616


SMC05                              = table1(I_p03,8);	
SMC30                              = table1(I_p03,9);	
SMC55                              = table1(I_p03,10);	

[SMC05_10minAvg]                   = avg_xmin_v3(t_soil_p03,SMC05,10);
[SMC30_10minAvg]                   = avg_xmin_v3(t_soil_p03,SMC30,10);
[SMC55_10minAvg]                   = avg_xmin_v3(t_soil_p03,SMC55,10);

t_soil_VWC                         = SMC05_10minAvg(:,1);    
SMC05c                             = SMC05_10minAvg(:,2);    
SMC30c                             = SMC30_10minAvg(:,2);
SMC55c                             = SMC55_10minAvg(:,2);
%% Coefficients from CS616
C0                                =   -0.0663;
C1                                =   -0.0063;
C2                                =    0.0007;

VWC05                             = C0 + C1*SMC05c + C2*SMC05c.^2;    
VWC30                             = C0 + C1*SMC30c + C2*SMC30c.^2;    
VWC55                             = C0 + C1*SMC55c + C2*SMC55c.^2;    

%%
figure()
ax1=subplot(2,1,1);
hold on
plot(t_soil_VWC,VWC05,'r')
plot(t_soil_VWC,VWC30,'g')
plot(t_soil_VWC,VWC55,'b')
legend({'VWC05' 'VWC30' 'VWC55'})
datetick('x', 'mmm-dd' ,'keepticks')
grid on
ax2=subplot(2,1,2);
hold on
plot  (R(1).agg_wt,R(1).agg_mm_cor,'-b')
plot  (R(2).agg_wt,R(2).agg_mm_cor,'-r')
legend({'P 1' 'P 2'})
datetick('x', 'mmm-dd' ,'keepticks')
grid on

linkaxes([ax1,ax2],'x')
% end

%% Saving values VWC 10 min resol
% save('c:\Speulderbos\Data\SoilWaterContentProcessed\MATFILE\SoilVWC', 't_soil_VWC','VWC05','VWC30','VWC55')

end