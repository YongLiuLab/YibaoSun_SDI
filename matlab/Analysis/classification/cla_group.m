
[t_re,SDI_list] = test123(SDI_cov_sub,sub_info);

%%t_re是全脑平均SDI做t检验得到的结果；SDI_list是将SDI值展平后的结果
function  [t_re,SDI_list] = test123(SDI,sub_info)
SDI_list = zeros(3,793,246);
t_re = zeros(9,5);
for sc_mode=1:3
    num = 1
    for center=1:7
        for group=1:3
            size_1 = size(SDI{sc_mode}{center,group});
            b = SDI{sc_mode}{center,group}';
            SDI_list(sc_mode,num:num+size_1(2)-1,:) = SDI{sc_mode}{center,group}';
            num=num+size_1(2);
              
        end
    end
    a= squeeze(SDI_list(sc_mode,:,:));     
    label_1= sub_info(:,1);
    model = svmtrain(label_1,a, '-c 1 -g 0.07' );

    [predict_label, accuracy,dec_values]=svmpredict(label_1,a, model);
    b = label_1 == 1;
    
    x_NC = squeeze(mean(SDI_list(sc_mode,label_1 ==1,:),3));
    x_MCI = squeeze(mean(SDI_list(sc_mode,label_1 ==2,:),3));
    x_AD = squeeze(mean(SDI_list(sc_mode,label_1 ==3,:),3));
    
    t_data = {x_NC,x_MCI,x_NC;x_AD,x_AD,x_MCI};
    a=1;
    
    for t_count = 1:3
        
        x1 = t_data{1,t_count};
        x2 = t_data{2,t_count};
        asd = ones(1,length(x1));
        x = [x1,x2];
        idx = [ones(1,length(x1)),zeros(1,length(x2))];
        % 方差齐性检验，即检验两组样本的总体方差是否相同
        [p3,stats3] = vartestn(x',idx','TestType','LeveneAbsolute','Display','off');
        %disp('Independent t-test with Eyes open:');
        %disp(['Levene’s test: p = ',num2str(p3,'%0.2f')]);%方差检验方法：Levene检验
        if p3<0.05
            %disp('Equal variances not assumed') %方差不相同
            [h4,p4,ci4,stats4]=ttest2(x1,x2,...
                'Vartype','unequal');
        else
            %disp('Equal variances assumed'); %方差相同
            [h4,p4,ci4,stats4]=ttest2(x1,x2);
        end
        t_re(t_count + (sc_mode-1)*3,:) = [h4,p4,ci4,stats4.tstat];
    end
    
    
    boxchart(idx,x);
    xlabel("Decade");
    ylabel("Mileage");
            
    
    
end

% sc_SDI_mean = mean(SDI_list,3)';
% sub_info(:,6:8) = sc_SDI_mean;
% SDI_re = sub_info(:,1:8)
% re= sub_info(:,1:8);
% result_label=table(re);
% str1= 'F:\Code\coupling\python\jupyter\SDI_sub\sc_mode_sdi_re.csv';
% writetable(result_label, str1);

% for sc_mode=1:3
%     a= squeeze(SDI_list(sc_mode,:,:)); 
%     result_table1=table(a);
%     str1= strcat('F:\Code\coupling\python\jupyter\SDI_sub\sc_mode_',string(sc_mode),'.csv');
%     writetable(result_table1, str1);
%     label_1= sub_info(:,1);
%     result_label=table(label_1);
%     str1= strcat('F:\Code\coupling\python\jupyter\SDI_sub\sc_mode_','label','.csv');
%     writetable(result_label, str1);
%     
% end

end
