function [accu] = accuracy(y_pre,y_label)
    s = size(y_pre);
    accu = sum(y_pre == y_label)/s(1,1);