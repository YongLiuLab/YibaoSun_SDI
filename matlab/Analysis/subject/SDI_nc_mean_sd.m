SDI_nc = squeeze(SDI_list(:,sub_info(:,1) ==1,:));

SDI_nc_1 = squeeze(mean(SDI_nc,3));
SDI_nc_mean = squeeze(mean(SDI_nc_1,2));
for i = 1:3
    SDI_nc_std(i) = std(SDI_nc_1(i,:));
end
a = SDI_nc_1(1,:);
[h,p,ci,stats] = ttest(SDI_nc_1(1,:),SDI_nc_1(3,:));