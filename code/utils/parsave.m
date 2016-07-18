function [ ] = parsave( filename, astruct )
%PARSAVE Summary of this function goes here
%   Use this function to save data from within a parallel for-loop
%   otherwise Matlab complains

fprintf('Now saving...%s\n', filename);
if exist(filename, 'file')
    save(filename, '-struct', 'astruct', '-append');
else
    save(filename, '-struct', 'astruct');
end
        
end

