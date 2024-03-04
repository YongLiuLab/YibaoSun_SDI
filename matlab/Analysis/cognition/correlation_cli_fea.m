%%计算去除协变量的结果，和认知显著性。
function [ts_cov_c,ts_cov_d] = regress_covariant(sub_info,sub_info_text,n_sample,ts_c_sc,ts_d_sc)
label = sub_info(:,find(strcmp(sub_info_text,'Group')));
center = sub_info(:,find(strcmp(sub_info_text,'center')));
Gender = sub_info(:,find(strcmp(sub_info_text,'Gender')));
Age = sub_info(:,find(strcmp(sub_info_text,'Age')));
cli= sub_info(:,5:33);
Covariant_info = [Age,Gender];
%协变量

ts_cov_c = cell(7,3);
ts_cov_d = cell(7,3);
%存储去除协变量的ts_cd

for center = 1:7
    for mode = 1:3
        ts_cov_c{center,mode} = zeros([0,0,0]);
        ts_cov_d{center,mode} = zeros([0,0,0]);
    end
end

n_sum = sum(n_sample,2);

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
        for num_roi = 1:246
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

function [] = test()
load('Fea_corr');
load('info_cli');
load('site')
info.label(find(strcmp(info.group,'CN')))=1;
info.label(find(strcmp(info.group,'MCI')))=2;
info.label(find(strcmp(info.group,'Dementia')))=3;
label = info.label;
data = Fea(:,:,2:end);
data  = data(:,find(label),:);
info.age = info.age(find(label));
info.gender = info.gender(find(label));
info.apoe = info.apoe(find(label));
site = site(find(label));
cli = [info.mmse,info.PACC,info.ADS(:,3),info.ADS(:,1:2),info.PGRS(:,15),info.PHS,info.ab(:,1:2)];
cli = cli(find(label),:);
label = label(find(label));
for i = 1:9
    cli_flag =  cli(:,i);
    for j = 1:2
        switch j 
            case 1 
                indx = find(strcmp(site,'ADNI1')|strcmp(site,'ADNIGO'));
            case 2 
                indx = find(strcmp(site,'ADNI2')|strcmp(site,'ADNI3'));
        end
        data_used = data(:,indx,:);
        cli_flag1 = cli_flag(indx);
        age = info.age(indx);
        gender = info.gender(indx);
        label_flag = label(indx);
        %
        indx = find((cli_flag1~=0)&~isnan(cli_flag1));
        data_used = data_used(:,indx,:);
        cli_flag1 = cli_flag1(indx);
        age = age(indx);
        gender = gender(indx);
        label_flag = label_flag(indx);
        [B,BINT,score,RINT] = regress(cli_flag1,[age,gender,label_flag']);
        for regions=1:246
            for fea = 1:47
                flag_data = squeeze(data_used(regions,:,fea))';
                [r_cli(i,j,regions,fea),p_cli(i,j,regions,fea)] = corr(score(find(label_flag>1)),flag_data(find(label_flag>1)));
            end
        end
    end
end

save('r_cli','r_cli')
save('p_cli','p_cli')
end

