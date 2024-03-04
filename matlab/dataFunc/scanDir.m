
function [ files ] = scanDir( root_dir ,creat_dir,find_str)
if 1
    creat_dir = root_dir;
end

files={};
if root_dir(end)~='\'
    root_dir=[root_dir,'\'];
end
if creat_dir(end)~='\'
    creat_dir=[creat_dir,'\'];
end
fileList=dir(root_dir);  %À©Õ¹Ãû
n=length(fileList);

for i=1:n
    if strcmp(fileList(i).name,'.')==1||strcmp(fileList(i).name,'..')==1
        continue;
    else
        fileList(i).name;
        if ~fileList(i).isdir  
            full_name=[root_dir,fileList(i).name];
            a= fileList(i);
            %if strfind(fileList(i).name,find_str)
            if strfind(fileList(i).name,find_str)
                
                a = length(files);
                files(length(files)+1)={full_name};
            end
        else
            creat_temp = [creat_dir , fileList(i).name ];
            if ~exist(creat_temp,'dir')
                mkdir(creat_temp);
            end
            files=[files,scanDir([root_dir,fileList(i).name], creat_temp,find_str)];
        end
    end
end
end

