function [ts_cov_c,ts_cov_d] = regress_covariant(sub_info,sub_info_text,n_sample,ts_c_sc,ts_d_sc)
%对ts_cd 去除协变量

ROI = 90;
label = sub_info(:,find(strcmp(sub_info_text,'Group')));
center = sub_info(:,find(strcmp(sub_info_text,'center')));
Gender = sub_info(:,find(strcmp(sub_info_text,'Gender')));
Age = sub_info(:,find(strcmp(sub_info_text,'Age')));
cli= sub_info(:,5:33);
%协变量
Covariant_info = [Age,Gender];

ts_cov_c = cell(7,3);
ts_cov_d = cell(7,3);

for center = 1:7
    for mode = 1:3
        ts_cov_c{center,mode} = zeros([0,0,0]);
        ts_cov_d{center,mode} = zeros([0,0,0]);
    end
end

n_sum = sum(n_sample,2);
%按中心去除协变量
for center = 1:7
    if center==1
        cov_center= Covariant_info(1:sum(n_sum(1:center)),:);
    else
        cov_center= Covariant_info(sum(n_sum(1:center-1))+1:sum(n_sum(1:center)),:);
    end
    for mode = 1:3
        data_list_c = zeros([0,0,0]);
        data_list_d = zeros([0,0,0]);
        for group = 1:3
            a = size(data_list_c);
            data_list_c(:,:,a(3)+1: a(3)+ n_sample(center,group)) =  ts_c_sc{center,group}{mode};
            data_list_d(:,:,a(3)+1: a(3)+ n_sample(center,group)) =  ts_d_sc{center,group}{mode};
            
        end
        size_a = size(data_list_c);
        for num_roi = 1:ROI
            for ts = 1:size_a(2)
                ab = squeeze(data_list_c(num_roi,ts,:));
                [B,BINT,score_c,RINT] = regress(squeeze(data_list_c(num_roi,ts,:)),cov_center);
                abc = [score_c,squeeze(data_list_c(num_roi,ts,:))];
                [B,BINT,score_d,RINT] = regress(squeeze(data_list_d(num_roi,ts,:)),cov_center);
                ts_cov_c{center,mode}(num_roi,ts,:) = score_c;
                ts_cov_d{center,mode}(num_roi,ts,:) = score_d;
            end
        end
    end
end
end
