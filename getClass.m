function [prop,class] = getClass(data,value)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
            classvector = unique(data(:,end));
            r =  zeros(length(classvector),1);
            for step = 1 : length(classvector)
                r(step) = nbay(data,classvector(step),value);
            end
            prop = max(r);
            class = find(r == max(r));
end

