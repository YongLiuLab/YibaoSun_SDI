
function [AVG_mode,AVG_cite,AVG_sub,AVG_ts] = Cal_avg(Data)
%% 计算平局值，对sub进行平均，统计各个站点的平均值
AVG_mode = zeros([7,3,246,6]);
AVG_cite = cell(7,3);
AVG_sub = cell(7,3);
AVG_ts = cell(7,3);
ROI = 246;
for i = 1:7
    for j = 1:3
        num_group = size(Data{i,j});
        group_cell = Data{i,j};
        AVG_sub{i,j}= cell(1);
        AVG_ts{i,j}= cell(1);
        AVG_cite{i,j} = zeros(246,num_group(1));
        
        for mode = 1:num_group(1)
            AVG_ts{i,j}{mode,1} = zeros('like',group_cell{mode, 1});
            AVG_sub{i,j}{mode,1} = zeros(246,num_group(2));
            AVG_mode(i,j,: ,mode) = zeros(246,1);
            
            if i == 2 && j == 1
                continue
            end
            %对sub的结果加和，除以数目得到平均值
            for num  = 1 : num_group(2)
                AVG_ts{i,j}{mode,1} = AVG_ts{i,j}{mode,1} + group_cell{mode, num};
                
                AVG_sub{i,j}{mode,1}(:,num) = mean(group_cell{mode, num},2);
            end
            AVG_ts{i,j}{mode,1} = AVG_ts{i,j}{mode,1} ./ num_group(2);
            
            AVG_cite{i,j}(:,mode) = mean(AVG_ts{i,j}{mode,1},2);
            AVG_mode(i,j,: ,mode) = mean(AVG_ts{i,j}{mode,1},2);
            
            
        end
    end
end

AVG_mode = squeeze(mean(AVG_mode,1));
end

