function [T_res] = Ttest_22(SDI)
%双样本T检验
ROI = 90;

T_res = cell(7,length(SDI));
for mode = 1 : length(SDI)
    for center = 1:7
        SDI_NC = SDI{mode}{center,1};
        SDI_MC = SDI{mode}{center,2};
        SDI_AD = SDI{mode}{center,3};
        T_temp = zeros(3,ROI,5);
        t_data = {SDI_NC,SDI_MC,SDI_NC;SDI_AD,SDI_AD,SDI_MC};
        for t_count = 1:3
            for area = 1:ROI
                x1 = t_data{1,t_count}(area,:);
                x2 = t_data{2,t_count}(area,:);
                x = [x1,x2];
                asd = ones(1,length(x1));
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
                
                T_temp(t_count,area,:)= [area,p3,stats4.tstat,stats4.df,p4];
            end
        end
        T_res{center,mode} =T_temp;
    end
end
%T_res_order = T_order(T_res) ;       

end

function [T_res_order] = T_order(T_res)
T_res_order = T_res ;
for i = 1:7
    for j = 1:3
        for t_count =1:3
            T_res_order{i,j} = sortrows(T_res_order{i,j},5);
        end
    end
end
end
% [num,txt,raw] = xlsread('Resting State.xlsx');
%  
% %% indenpendent two sample ttest
% idx=num(:,5);
% x=num(:,1);
% x_M=x(idx==1);
% x_F=x(idx==0);
% % 方差齐性检验，即检验两组样本的总体方差是否相同
% [p3,stats3] = vartestn(x,idx,...
% 'TestType','LeveneAbsolute','Display','off');
% disp('Independent t-test with Eyes open:');
% disp(['Levene’s test: p = ',num2str(p3,'%0.2f')]);%方差检验方法：Levene检验
% if p3<0.05
%     disp('Equal variances not assumed') %方差不相同
%     [h4,p4,ci4,stats4]=ttest2(x_M,x_F,...
%         'Vartype','unequal');                                 
% else
%     disp('Equal variances assumed'); %方差相同
%     [h4,p4,ci4,stats4]=ttest2(x_M,x_F);
% end
% disp(['t = ',num2str(stats4.tstat,'%0.2f')]);
% disp(['df = ',num2str(stats4.df,'%0.2f')]);
% disp(['p = ',num2str(p4,'%0.2f')]);