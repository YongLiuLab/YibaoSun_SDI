

function [pval_Stouffer_wei, z_socre] = p_fusion22(P_mode, T_mode, n_sample)
ROI = 246;
ROI = 90;
pval_Stouffer_wei=zeros(3,3,ROI);
z_socre=zeros(3,3,ROI);
for mode = 1: 3
    
    for t_count = 1:3
        p_value = P_mode{mode,t_count};
        t_value = T_mode{mode,t_count};

        fc_p = p_value.*sign(t_value);

        % n_sample = [82,72,60,105,113,60];      %AD-NC
        % n_sample = [70,68,69,79,141,58];       %ad-mc
        %确定样本数量
        if t_count == 1
            n_sample_temp  = n_sample(:,1) + n_sample(:,3);       %mc-nc
        elseif t_count == 2
            n_sample_temp  = n_sample(:,2) + n_sample(:,3); 
        elseif t_count == 3
            n_sample_temp  = n_sample(:,1) + n_sample(:,2); 
        end
        
        %此处按照脑区做meta分析，融合七个中心的结果

        for i=1:length(fc_p)
            [pval_Stouffer_wei(mode,t_count ,i), z_socre(mode,t_count, i)] = meta_pval(fc_p(i,:), sign(fc_p(i,:)), n_sample_temp');
        end
    end
    
end
end




% save('E:\M_center\MCAD\Results_analysis\in-house\Difference_analysis\pval_Stouffer_wei_ad_mc','pval_Stouffer_wei');
% save('E:\M_center\MCAD\Results_analysis\in-house\Difference_analysis\z_socre_ad_mc','z_socre')
