function [m,b] = line_parameters(x1,x2,y1,y2)
    m = (y2 - y1) / (x2 - x1);
    b = (y1 * x2 - y2 * x1) / (x2 - x1);
end

