function [K] = LinearKernel(x,xn)
    K = x*xn';