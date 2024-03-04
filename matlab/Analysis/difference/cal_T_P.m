function [T_mode,P_mode] = cal_T_P(T_res)
%统计T检验的结果
P_mode = cell(6,3);
T_mode = cell(6,3);
for mode = 1:3
    for t_count = 1:3
        for cite = 1:7 
            p_value_AD_MC(:,cite) = T_res{cite,mode}(t_count,:,5);
            t_value_AD_MC(:,cite) = T_res{cite,mode}(t_count,:,3);

        end     
    P_mode{mode,t_count} = p_value_AD_MC;
    T_mode{mode,t_count} = t_value_AD_MC;
    end
end
end
