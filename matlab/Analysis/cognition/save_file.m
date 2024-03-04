% label_1= sub_info(:,[1,2,5]);
% varname = {'Temperature','Time','Station'};
% %,'VariableNames', varname
% result_label=table(label_1 );
% str1= strcat('D:\User\Desktop\coupling\python\jupyter\sc_mode_','info','.csv');
% writetable(result_label, str1);

result_label=table(Z_SDI );

result_label=table(Z_SDI(:,1),Z_SDI(:,2),Z_SDI(:,3) ,'VariableNames',{'fa','md','num'});
str1= strcat('F:\Code\coupling\python\jupyter\SDI_sub\SDI_sub.csv');
writetable(result_label, str1);