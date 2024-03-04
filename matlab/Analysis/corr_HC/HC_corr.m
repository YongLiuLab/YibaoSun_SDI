data = SDIHC22q11DS;

SDI_NC = squeeze(mean(SDI_list(:,sub_info(:,1) ==1, :),2));

SDI_AD = squeeze(mean(SDI_list(:,sub_info(:,1) ==3, :),2));
SDI_mode = squeeze(mean(SDI_list(:,sub_info(:,1) ==1, :),2));

[r,p] = corr(data, SDI_NC(1,1:245)')
scatter(data, SDI_NC(1,1:245)')

[r,p] = corr(Z_SDI(:,3), Z_SDI(:,1))
[r,p] = corr(SDI_NC(1,:)', SDI_AD(1,:)')

