function [AVG_N,AVG_one] = avg_N(N_cd, flag)
%AVG_MODE 此处显示有关此函数的摘要
%   此处显示详细说明
AVG_N = cell(3,1);
ROI = 246;
for j = 1:3
    AVG_N{j} = zeros(3, ROI);
end
AVG_one = zeros(9, ROI);
    

for mode = 1:length(N_cd)
    for i = 1:7
        for j = 1:3
            if flag == 1 % N_c,N_d
                mean_temp = squeeze(mean(N_cd{mode}{i,j},2)) ./ (sqrt(ROI)*7);
            elseif flag == 2 
                mean_temp = squeeze(mean(N_cd{mode}{i,j},2)) ./ 7;
            end
            
            AVG_N{mode}(j,:) = AVG_N{mode}(j,:)+ mean_temp' ; 
            AVG_one((mode-1)*3+j,:) = AVG_one((mode-1)*3+j,:)+ mean_temp';
        end
    end
end

end
