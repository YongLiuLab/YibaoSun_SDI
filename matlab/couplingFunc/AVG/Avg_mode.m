function [AVG_mode_1] = Avg_mode(ts_cd)
%AVG_MODE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
AVG_mode_1 = cell(3,1);
ROI = 246;
for i = 1:7
    for j = 1:3
        num_group = size(ts_cd{i,j});
        for mode = 1:num_group(2)
            mean_temp = mean(ts_cd{i,j}{mode},3);
            AVG_mode_1{j}(mode,:) = squeeze(mean(mean_temp,2));
            
        end
    end
end

end

