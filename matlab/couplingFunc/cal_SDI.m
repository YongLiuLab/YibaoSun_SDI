
function [SDI,N_c,N_d,SDI_list] = cal_SDI(d_res,c_res,n_sub)
%需要计算ts 的L2 范数得到结果
%
% SDI = cell(7,3) ;
% N_c = cell(7,3);
% N_d = cell(7,3);
%     
% for center = 1:7
%     for group = 1:3
%         SDI{center,group} =cell{1,3};
%         N_c{center,group} =cell{1,3};
%         N_d{center,group} =cell{1,3};
%     end
% end

ROI =90;

for center = 1:7
    for mode = 1:3
        size_c = size(c_res{center,mode});
        for num_roi = 1:size_c(1)
            for num_sub = 1:size_c(3)
                num_sub_true = num_sub;
                if num_sub > n_sub(center,1) + n_sub(center,2)
                    group =3;
                    num_sub_true = num_sub - n_sub(center,1) - n_sub(center,2);
                elseif num_sub > n_sub(center,1)
                    group =2;
                    num_sub_true = num_sub - n_sub(center,1) ;
                else
                    group =1;
                end
                N_c{mode}{center,group}(num_roi,num_sub_true) = norm(c_res{center,mode}(num_roi,:,num_sub));
                N_d{mode}{center,group}(num_roi,num_sub_true) = norm(d_res{center,mode}(num_roi,:,num_sub));
                SDI{mode}{center,group}(num_roi,num_sub_true) = N_d{mode}{center,group}(num_roi,num_sub_true)./ N_c{mode}{center,group}(num_roi,num_sub_true);
            end
        end
    end
end 



SDI_list = zeros(3,sum(n_sub,'all'),ROI);

for sc_mode=1:3
    num = 1
    for center=1:7
        for group=1:3
            size_1 = size(SDI{sc_mode}{center,group});
            b = SDI{sc_mode}{center,group}';
            SDI_list(sc_mode,num:num+size_1(2)-1,:) = SDI{sc_mode}{center,group}';
            num=num+size_1(2);  
        end
    end
end


end

function [SDI,N_c,N_d] = cal_SDI1(d_res,c_res)
%需要计算ts 的L2 范数得到结果
SDI = cell(1,3) ;
N_c = cell(1,3);
N_d = cell(1,3);

for center = 1:7
    for mode = 1:3
        size_c = size(c_res{center,mode});
        for num_roi = 1:size_c(1)
            for num_sub = 1:size_c(3)
                N_c{center,mode}(num_roi,num_sub) = norm(c_res{center,mode}(num_roi,:,num_sub));
                N_d{center,mode}(num_roi,num_sub) = norm(d_res{center,mode}(num_roi,:,num_sub));
                SDI{center,mode}(num_roi,num_sub) = N_d{center,mode}(num_roi,num_sub)./ N_c{center,mode}(num_roi,num_sub);
            end
        end
    end
end 
end

