

function [z_th_05,z_score,pval_Stouffer_wei] = cal_Z(SDI,n_sub)
%meta分析，计算Z值，

ROI = 246;
ROI = 90;
[T_res] = Ttest_22(SDI);

[T_mode,P_mode] = cal_T_P(T_res);
[pval_Stouffer_wei, z_score] = p_fusion22(P_mode, T_mode, n_sub);
for mode = 1:3
    for t_count =1:3
    pval_fdr(mode,t_count,:) = mafdr(squeeze(pval_Stouffer_wei(mode,t_count,:)), 'BHFDR', true);
    end
end
 
%fdr校验
% z_th_05 = z_score;
% z_th_01 = z_score;
% z_th_001 = z_score;
% 
% z_th_05((pval_fdr'> 0.05/ROI)) = 0;
% z_th_01((pval_fdr'> 0.01/ROI)) = 0;
% z_th_001((pval_fdr'> 0.001/ROI)) = 0;

%正常校验
z_th_05 = z_score;
z_th_01 = z_score;
z_th_001 = z_score;

z_th_05((pval_Stouffer_wei> 0.05/ROI)) = 0;
z_th_01((pval_Stouffer_wei> 0.01/ROI)) = 0;
z_th_001((pval_Stouffer_wei> 0.001/ROI)) = 0;

end
