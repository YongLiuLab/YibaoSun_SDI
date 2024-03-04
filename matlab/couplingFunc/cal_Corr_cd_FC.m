function [corr_c,corr_de] = cal_Corr_cd_FC(c_res,de_res)
%CAL_DE_COUPLING 此处显示有关此函数的摘要
%   此处显示详细说明
addpath(genpath( 'D:\User\Desktop\coupling\matlab\utils\dataFunc' ));
addpath(genpath( 'D:\User\Desktop\coupling\matlab\utils\couplingFunc' ));

corr_c = cell(7,3);
corr_de = cell(7,3);

for center = 1:7
    for group = 1:3
        corr_c{center,group} = cell(1);
        corr_de{center,group} = cell(1);
        
        c_group = c_res{center,group};
        de_group = de_res{center,group};
        num_group = size(c_res{center,group});
        
        for mode = 1:num_group(1)
            for num_sub  = 1 : num_group(2)
                if [center, group, mode, num_sub] == [1,1,1,5]
                    a=1;
                end
                c_matrix = c_group{mode, num_sub};
                de_matrix = de_group{mode, num_sub};
                corr_sub = corr(c_matrix', 'type','pearson');
                corr_sub2 = corr(de_matrix', 'type','pearson');
                
                corr_c{center,group}{mode,num_sub} = corr(c_matrix', 'type','pearson');
                corr_de{center,group}{mode,num_sub} = corr(de_matrix', 'type','pearson');
            end
        end
        fprintf('center is %d, group is %d\n',center,group);
    end
end


