function [SC_raw,FC_raw,TS_raw] = data2cell()
%从dataPath
dataPath = 'D:\User\Desktop\coupling\matlab\file\raw\sub_5.txt';
sublist = importdata(dataPath);

SC_raw = cell(7,3);
TS_raw = cell(7,3);
FC_raw = cell(7,3);
A_count = ones(7,3);
for i = 1:21
    SC_raw{mod(i,7) +1, ceil(i/7)} = cell(1);
%     FC_raw{mod(i,7) +1, ceil(i/7)} = cell(1);
%     TS_raw{mod(i,7) +1, ceil(i/7)} = cell(1);
end

for i = 1 : length(sublist)
    subdirPath = sublist{i};
    S = regexp(sublist{i}, '\', 'split');
    center = str2num(S{7}(3));
    if S{8} == 'NC'
        group = 1;
    end
    if S{8} == 'MC'
        group = 2;
    end
    if S{8} == 'AD'
        group = 3;
    end
    
    output = csv2data(subdirPath);
    for j = 1:length(output)
        if j <=3 
            SC_raw{center, group}{j,A_count(center,group)} = output{j};
        elseif j == 4
            FC_raw{center, group}(:,:,A_count(center,group)) = output{j};
        elseif j == 5
            TS_raw{center, group}(:,:,A_count(center,group)) = output{j};
        end
    end

    A_count(center,group) =  A_count(center,group) +1;
    if mod(i,100) == 0
        A_count-1 
    end
end
A_count-1 
end

