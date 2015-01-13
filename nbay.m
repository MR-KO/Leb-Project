function prop = nbay(data,class,val)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
            classvector =(data(:,2) == class);
            valuevector = (data(:,1) == val);
            m = length(data(:,1));
            propc = sum(classvector) / m;
            propx = sum(classvector & valuevector);
            prop = propc * propx;            
end

