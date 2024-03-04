aal_nii = load_nii('F:\Code\coupling\matlab\file\AAL\surface\SDI\nii\NUM_NC_SDI_AAL.nii.gz');
bn_nii = load_nii('F:\Code\coupling\matlab\file\sub\surface\SDI\nii\2-28_NUM_NC_SDI_avg_sub.nii');


img_1 = aal_nii.img;
img_2 = bn_nii.img;


size_img1 = size(img_1);
size_img2 = size(img_2);

img_common = zeros([1000000,2]);
commonNum = 1

img_2_resize = img_2(1:size_img1(1),1:size_img1(2),1:size_img1(3));


%img_all = img_2_resize .*size_img1;

%a = squeeze(img_all(100,:,:));


for i = 1:size_img1(1)
    for j = 1:size_img1(2)
        for k = 1:size_img1(3)
            if img_1(i,j,k) ~= 0 && img_2(i,j,k)~=0
                img_common(commonNum,:) = [img_1(i,j,k) , img_2(i,j,k)];
                commonNum = commonNum+1;
            end
        end
    end
end

[r,p] = corr(img_common)