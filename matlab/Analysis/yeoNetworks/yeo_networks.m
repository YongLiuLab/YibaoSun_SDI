
[SDI_yeo7,SDI_yeo17]  = SDI2yeo(SDI_list,3);

SDI_avg_yeo7 = squeeze(mean(SDI_yeo7,2));
SDI_avg_yeo17 = squeeze(mean(SDI_yeo17,2));

function [SDI_yeo7,SDI_yeo17] = SDI2yeo(res,dim )
path_file = 'F:\Code\coupling\matlab\file\raw\subregion_func_network_Yeo.csv';
region_data= importdata(path_file);
region_2 = region_data.data;

SDI_yeo7 = zeros(3,793,7);
SDI_yeo17 = zeros(3,793,17);
for i = 1:17
    if i <8
        index= (region_2(:,2) == i)
        a = mean(res(:,:,index),3);
        SDI_yeo7(:,:,i) = squeeze(mean(res(:,:,index),3));
    end
    index= (region_2(:,3) == i)
    SDI_yeo17(:,:,i) = squeeze(mean(res(:,:,index),3));
end

a=1
end

    
