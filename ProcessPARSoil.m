[IDpar1,VarName2,VarName4,VarName6,VarName8,VarName10,VarName12,VarName14,VarName16]=ImportfileCR21X('c:/Speulderbos/Data/CR21X/sp_par_20150828.TXT', 1,1000000);
%%
% 
% ;1 102 L                      VarName2
% ;2 Day_RTM  L                 VarName4  
% ;3 Hour_Minute_RTM  L
% ;4 PAR_1_avg  L
% ;5 PAR_2_avg  L
% ;6 PAR_3_avg  L
% ;7 PAR_4_avg  L
% ;8 PAR_5_avg  L
% ;9 PAR_6_avg  L
% ;10 PAR_7_avg  L
% ;11 PAR_8_avg  L
% ;12 PAR_9_avg  L
% ;13 PAR10_avg  L
% ;14 PAR11_avg  L
% ;15 PAR12_avg  L
% ;16 PAR13_avg  L
% 1 minute resolution
mat1=[VarName2(IDpar1==1) VarName4(IDpar1==1) VarName6(IDpar1==1)...
     VarName8(IDpar1==1) VarName10(IDpar1==1) VarName12(IDpar1==1) VarName14(IDpar1==1) VarName16(IDpar1==1)...
      VarName2(IDpar1==9) VarName4(IDpar1==9) VarName6(IDpar1==9) VarName8(IDpar1==9) VarName10(IDpar1==9) VarName12(IDpar1==9) VarName14(IDpar1==9) VarName16(IDpar1==9) ];
  
  figure()
  hold on
  plot(mat1(:,4),'r')
  plot(mat1(:,5),'g')
  plot(mat1(:,6),'b')
  plot(mat1(:,7),'k')
  plot(mat1(:,8),'y')
  
  
  hold off