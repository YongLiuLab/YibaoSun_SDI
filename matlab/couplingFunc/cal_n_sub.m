function  [n_sample] = cal_n_sub(SDI)
%统计样本数
n_sample = zeros(7,3);
for i = 1:7
    for j = 1:3
        a = size(SDI{i,j}{1});
        n_sample(i,j) = a(2);
    end
end
end
