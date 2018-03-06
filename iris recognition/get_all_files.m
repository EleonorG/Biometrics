% 可以使用递归
function [ files ] = get_all_files( path )
listing=dir(path);
files={};
for i=1:length(listing)
    f=listing(i);
    if ~strcmp(f.name,'.') && ~strcmp(f.name,'..')
        if f.isdir
            files=[files;get_all_files(fullfile(path,f.name))];
        else
            files=[files;fullfile(path,f.name)];
        end
    end
end
end