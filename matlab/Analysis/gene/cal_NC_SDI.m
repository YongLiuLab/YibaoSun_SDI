nc_index = sub_info(:,1)==1;
SDI_NC_avg = squeeze(mean(SDI_list(:,nc_index,:),2));

grad_NC_avg = zeros(246);
for center = 1:7
    grad_NC_avg(:,center) = alignGrad{center};
end
grad_NC_avg = mean(grad_NC_avg,2);

for mode = 1:3
    a = SDI_NC_avg(mode,:)
    [r(mode),p(mode)] = corr(grad_NC_avg,SDI_NC_avg(mode,:)');
end

writematrix(SDI_NC_avg,'F:\Code\coupling\matlab\file\sub\surface\SDI\SDI_avg_nc.csv');
writematrix(squeeze(Z_SDI_3(:,1,:)),'F:\Code\coupling\matlab\file\sub\surface\SDI_dif\SDI_dif_NC_AD.csv');
writematrix(squeeze(Z_SDI_3(:,2,:)),'F:\Code\coupling\matlab\file\sub\surface\SDI_dif\SDI_dif_MC_AD.csv');
writematrix(squeeze(Z_SDI_3(:,3,:)),'F:\Code\coupling\matlab\file\sub\surface\SDI_dif\SDI_dif_NC_MC.csv');
    


