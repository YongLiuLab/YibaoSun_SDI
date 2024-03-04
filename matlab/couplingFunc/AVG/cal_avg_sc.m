function [AVG_group,AVG_sub] = cal_avg_sc(Data_sc)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
AVG_group = cell(7,3);
AVG_sub = cell(7,3);
ROI = 246;
ROI = 90;
for i = 1:7
    for j = 1:3
        num_group = size(Data_sc{i,j});
        group_cell = Data_sc{i,j};
        AVG_sub{i,j}= cell(1);
        for mode = 1:num_group(1)
            AVG_group{i,mode}= zeros(ROI);
            AVG_sub{i,j}{mode} = zeros(ROI);
            
            %对sub的结果加和，除以数目得到平均值
            for num  = 1 : num_group(2)
                AVG_sub{i,j}{mode} = AVG_sub{i,j}{mode} + group_cell{mode, num} ./ num_group(2) ;
            end
            
            AVG_group{i,mode} = AVG_group{i,mode} + AVG_sub{i,j}{mode}./num_group(1);
            
        end
    end
end


end

