
nii_gene_map('a')

function  nii_gene_map(save_path)
data = importdata('F:\Code\coupling\matlab\utils\Analysis\gene\file\expression_xscore_0.csv');
SDI_dif = importdata('F:\Code\coupling\matlab\file\sub\surface\SDI_dif\SDI_dif_NC_AD.csv');
scoreData = data;
nii_246 = load_nii('F:\Code\coupling\matlab\file\raw\BN_Atlas_246_1mm.nii');
img = nii_246.img;
nii_246.filetype=16;
nii_246.hdr.dime.datatype=16;

size_img = size(img);
img_score = zeros(size_img);
img_dif = zeros(size_img);
for i = 1:size_img(1)
    for j = 1:size_img(2)
        for k = 1:size_img(3)
            if img(i,j,k) == 0
                img_score(i,j,k) = 0;
                img_dif(i,j,k) = 0;
            else
                roi = img(i,j,k)-1;
                x = find(scoreData(2,:)==roi);
                if x
                    img_score(i,j,k) = scoreData(3,x);
                    img_dif(i,j,k) = SDI_dif(1,roi+1);
                else 
                    img_score(i,j,k) = 0;
                    img_dif(i,j,k) = 0;
                end
            end
        end
    end
end
nii_new = nii_246;
nii_dif = nii_246;

nii_new.img = img_score;
nii_dif.img = img_dif;
%save_path = 'F:\Code\coupling\matlab\file\result\sub\plot\surface\SDI\nii\a.nii';
save_path = 'F:\Code\coupling\matlab\utils\Analysis\gene\file\score_0.nii.gz';
save_path_dif = 'F:\Code\coupling\matlab\utils\Analysis\gene\file\dif.nii.gz';
save_nii(nii_new,save_path);
save_nii(nii_dif,save_path_dif);
end