function  [output] = csv2data(path_subdir)
%从文件夹里遍历文件，读取矩阵
%返回一个cell 5*1
subdir = dir(path_subdir);
output = cell(5,1);
mode_list = {'sc_fa.csv', 'sc_md.csv','sc_num.csv' ,'corr.csv','ts.csv'};
for i = 1 : length( subdir )
    for j = 1:length(mode_list)
        if  strfind( subdir( i ).name , mode_list(j))   
            subdirpath = fullfile( path_subdir, subdir( i ).name );
            data_num = readmatrix(subdirpath);
            output{j} = data_num;
        end
    end
end
end