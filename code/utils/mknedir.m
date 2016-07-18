function [ ] = mknedir( dirpath )
%MKDIR2 Summary of this function goes here
%   Creates directory if it does not already exist 


if ~exist(dirpath, 'dir')
    mkdir(dirpath);
end


end

