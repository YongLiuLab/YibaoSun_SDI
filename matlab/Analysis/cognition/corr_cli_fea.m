 %%计算去除协变量的结果，临床量表的显著性。
 %自带fdr矫正
[r_cliNotsite,p_cliNotsite] = corr_cli_fea_NotCenter(SDI_cov_sub,n_sub,sub_info,sub_info_text);
[th_05_fdf,p_log_05] = analysis_cor(r_cliNotsite,p_cliNotsite);
mmse_p = [p_log_05{1}(1,:);p_log_05{2}(1,:);p_log_05{3}(1,:)]'
mmse_r = [th_05_fdf{1}(1,:);th_05_fdf{2}(1,:);th_05_fdf{3}(1,:)]'




function [th_05_fdf,p_log_05] = analysis_cor(r_cli,p_cli_fdr)
for mode = 1:3
    ROI = 246;
    
    r_th_05 = r_cli{mode};
    a= p_cli_fdr{mode};
    
    r_th_05((p_cli_fdr{mode}> 0.05)) = 0;
    
    th_05_fdf{mode} = r_th_05;
    
    p_log = -log10(p_cli_fdr{mode});
    
    p_log_re = zeros(29,246);
    %a= p_log> -log10(0.001);
    %p_log_re(p_log> -log10(0.001)) = p_log(p_log> -log10(0.001));
    p_log_re(r_th_05>0) = p_log(r_th_05>0);
    p_log_re(r_th_05<0) = -p_log(r_th_05<0);
    
    p_log_05{mode} = p_log_re;
    
end
end

function [r_cli,p_cli_fdr] = corr_cli_fea_NotCenter(SDI,n_sub,sub_info,sub_info_text)


%讲SDI整合为3*（246*793）
all_sdi = cell(1,3);
for mode = 1:3
    n_sub_list = [0];
    for center = 1:7
        
        for group = 1:3
            n_sub_list((center-1)*3 + group+1) = n_sub_list((center-1)*3 + group) + n_sub(center,group);
            a= SDI{mode}{center,group};
            all_sdi{mode}( n_sub_list((center-1)*3 + group)+1 : n_sub_list((center-1)*3 + group+1),: ) = SDI{mode}{center,group}';
        end
    end
end

label = sub_info(:,find(strcmp(sub_info_text,'Group')));
center = sub_info(:,find(strcmp(sub_info_text,'center')));
Gender = sub_info(:,find(strcmp(sub_info_text,'Gender')));
Age = sub_info(:,find(strcmp(sub_info_text,'Age')));
a= (label==1);
for i = 1:3
    label_3(:,i)= (label ==i)
end

cli= sub_info(:,5:33);
Covariant_info = [Age,Gender,label_3];
%讲SDI整合为3*（246*793）

for mode = 1:3

    size_cli =size(cli);
    for cli_num = 1:size_cli(2)
        cli_flag =  cli(:,cli_num);

        %去除nan
        indx = (~isnan(cli_flag));
        if length(indx) == 0
            continue
        end
        indx_mcad = sub_info(:,1)~=1;
        
        indx = (indx&indx_mcad);
        data_used = all_sdi{mode}(indx,:);
        cli_flagNan = cli_flag(indx);
        CovariantNan = Covariant_info(indx,:);
        %临床数据去除协变量
        %[B,BINT,score,RINT] = regress(cli_flagNan,CovariantNan);
        score = cli_flagNan;
        if cli_num == 10
            a=1;
        end
        for regions=1:246
            flag_data = squeeze(data_used(:,regions));
            %临床相关性
            
            [r_cli{mode}(cli_num,regions),p_cli{mode}(cli_num,regions)] = corr(score,flag_data);
            
        end
        %fprintf('center is %d, mode is %d,  cli is %d\n',center,mode,cli_num);
        a = p_cli{mode}(cli_num,:);
        b = mafdr(p_cli{mode}(cli_num,:), 'BHFDR', true);
        
        
        p_cli_fdr{mode}(cli_num,:) = mafdr(p_cli{mode}(cli_num,:), 'BHFDR', true);
    end    
end


end


function [r_cli,p_cli] = corr_cli_fea_center(SDI,n_sub,sub_info,sub_info_text)
%测试n_sub序列统计的算法,按中心计算相关
n_sub_list = [0];
for center = 1:7
    for group = 1:3
        n_sub_list((center-1)*3+group+1) = n_sub_list((center-1)*3+group) + n_sub(center,group);
    end
end

label = sub_info(:,find(strcmp(sub_info_text,'Group')));
center = sub_info(:,find(strcmp(sub_info_text,'center')));
Gender = sub_info(:,find(strcmp(sub_info_text,'Gender')));
Age = sub_info(:,find(strcmp(sub_info_text,'Age')));

cli= sub_info(:,5:33);
Covariant_info = [Age,Gender,label];

all_sdi = cell(7,3);
for mode = 1:3
    n_sub_center = [0]
    for center = 1:7
        n_sub_list = [0];
        for group = 1:3
            n_sub_list(group+1) = n_sub_list(group) + n_sub(center,group);
            all_sdi{center,mode}(:, n_sub_list(group)+1 : n_sub_list(group+1) ) = SDI{mode}{center,group};
        end
        n_sub_center(center+1) = n_sub_center(center) + n_sub_list(4);
        size_cli =size(cli);
        for cli_num = 1:size_cli(2)
            cli_flag =  cli(n_sub_center(center)+1 : n_sub_center(center+1),cli_num);
            if center ==2
                a=1;
            end
            %去除nan
            indx = find(~isnan(cli_flag));
            
            if length(indx) == 0
                continue
            end
            data_used = all_sdi{center,mode}(:,indx);
            cli_flagNan = cli_flag(indx);
            CovariantNan = Covariant_info(indx,:);
            %临床数据去除协变量
            [B,BINT,score,RINT] = regress(cli_flagNan,CovariantNan);
            for regions=1:246
                flag_data = squeeze(data_used(regions,:))';
                %临床相关性
                
                [r_cli{mode,cli_num}(center,regions),p_cli{mode,cli_num}(center,regions)] = corr(score,flag_data);
                
            end
            %fprintf('center is %d, mode is %d,  cli is %d\n',center,mode,cli_num);
        end
        
    end
end

% save('r_cli','r_cli')
% save('p_cli','p_cli')
end