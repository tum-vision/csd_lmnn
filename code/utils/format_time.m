function str = format_time(sec, fmt)

sec = round(sec);
d = floor(sec/3600/24);
h = floor(mod(sec, 3600*24) / 3600);
m = floor(mod(sec, 3600) / 60);
s = mod(sec, 60);

if nargin == 2 && strcmpi(fmt, 'short')
    if sec < 3600*24,
        str = sprintf('%02d:%02d:%02d', h, m, s);
    else
        str = sprintf('%dd %02d:%02d:%02d', d, h, m, s);
    end    
else
    if sec < 60,
        str = sprintf('%ds', s);
    elseif sec < 3600,
        str = sprintf('%dm %ds', m, s);
    elseif sec < 3600*24,
        str = sprintf('%dh %dm %ds', h, m, s);
    else
        str = sprintf('%dd %dh %dm %ds', d, h, m, s);
    end
end
