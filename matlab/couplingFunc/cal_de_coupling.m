

function [c_res,de_res,N_c,N_d,SDI,mean_SDI] = cal_de_coupling(TS_raw,AVG_sc,flag,AVG_sc_group)
%º∆À„de(coupling)
addpath(genpath( 'D:\User\Desktop\coupling\matlab\utils\dataFunc' ));
addpath(genpath( 'D:\User\Desktop\coupling\matlab\utils\couplingFunc' ));

c_res = cell(7,3);
de_res = cell(7,3);
SDI = cell(7,3);
N_c = cell(7,3);
N_d =cell(7,3);
mean_SDI =cell(7,3);
count_0_num = zeros(7,9);
for center = 1:7
    for group = 1:3
        c_res{center,group} = cell(1);
        de_res{center,group} = cell(1);
        for sc_count = 1:3
            if flag == 3
                count_useful = 1;
                
                for subnum = 1:length(AVG_sc{center,group})
                    sc_matrix = AVG_sc{center,group}{sc_count,subnum};
                    sc_mean = squeeze(mean(sc_matrix));
                    a = min(sc_mean);
                    [a1,a2]= sort(sc_mean);
                    %if min(sc_mean)  == 0
                    if 1
                        ratio = 0.5;
                        count_0_num(center,(group-1)*3+sc_count) = count_0_num(center,(group-1)*3+sc_count) +1;
                        sc_matrix = sc_matrix * ratio + AVG_sc_group{center,group}{sc_count} *(1-ratio);               
                    end
                    [X_c,X_d,N_c_1,N_d_1,SDI_1,mean_SDI_1] = LaplacianDecoupling(sc_matrix,TS_raw{center,group}(:,:,subnum));
                    c_res{center,group}{sc_count}(:,:,subnum) = X_c;
                    de_res{center,group}{sc_count}(:,:,subnum) = X_d;
                    N_c{center,group}{sc_count}(:,subnum) = N_c_1;
                    N_d{center,group}{sc_count}(:,subnum) = N_d_1;
                    SDI{center,group}{sc_count}(:,subnum) = SDI_1;
                    mean_SDI{center,group}{sc_count}(:,subnum) = mean_SDI_1;
                    
                end
                    
            else
                if flag ==1
                    sc_matrix = AVG_sc{center,group}{sc_count};
                elseif flag==2
                    sc_matrix = AVG_sc{center,sc_count};
                end

                [X_c,X_d,N_c_1,N_d_1,SDI_1,mean_SDI_1] = LaplacianDecoupling(sc_matrix,TS_raw{center,group});

                c_res{center,group}{sc_count} = X_c;
                de_res{center,group}{sc_count} = X_d;
                N_c{center,group}{sc_count} = N_c_1;
                N_d{center,group}{sc_count} = N_d_1;
                SDI{center,group}{sc_count} = SDI_1;
                mean_SDI{center,group}{sc_count} = mean_SDI_1;
            end
        end
        fprintf('center is %d, group is %d\n',center,group);
    end
    
end
end


