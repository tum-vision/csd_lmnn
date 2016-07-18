function [ y ] = isstrnumeric( x )
%ISSTRNUMERIC Summary of this function goes here
%   Detailed explanation goes here


y = all (x>='0' & x<='9');



end

