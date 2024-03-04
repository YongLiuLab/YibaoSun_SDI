
%[T_res] = Ttest_22(SDI_cov_sub);
[T_mode_th,P_mode_th] = cal_T_P_th(T_res);
function [T_mode,P_mode] = cal_T_P_th(T_res)
%统计T检验的结果
P_mode = cell(6,3);
T_mode = cell(6,3);
for mode = 1:3
    for t_count = 1:3
        for cite = 1:7 
            p_value_AD_MC(:,cite) = T_res{cite,mode}(t_count,:,5);
            t_value_AD_MC(:,cite) = T_res{cite,mode}(t_count,:,3);
            
            p_05 = p_value_AD_MC;
            t_05 = t_value_AD_MC;
            t_05(p_05>0.05) =0;
            p_05(p_05>0.05) =0;
            
        end     
    P_mode{mode,t_count} = p_05;
    T_mode{mode,t_count} = t_05;
    end
end
end