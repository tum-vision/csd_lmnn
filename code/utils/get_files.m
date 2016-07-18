function [ f ] = get_files( adir, filetype, idx )
%GET_FILES Summary of this function goes here
%   Get all file names of a specific filetype extension in a given
%   directory. Optionally get files by indeces.
%
%   adir        - directory full path
%   filetype    - extension (default is '*.mat')
%   idx         - indices of files (default is none)


if nargin < 2 || isempty(filetype)
    filetype = '*.mat';
end


f = dir(fullfile(adir, filetype));
f = {f.name};

if nargin == 3
    f = f(idx);
end

f = cellfun(@(x) fullfile(adir, x), f, 'UniformOutput', 0)';

if length(f) == 1
    f = f{1};
end

end

