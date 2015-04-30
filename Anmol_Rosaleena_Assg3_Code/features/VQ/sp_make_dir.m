function [ ] = sp_make_dir( filePath )

[dirPath fileName] = fileparts(filePath);
if(isdir(dirPath)==0)
    mkdir(dirPath);
end

end
