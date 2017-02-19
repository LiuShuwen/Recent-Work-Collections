function [K] = PolynomialKernel(x,xn)
[s, ~] = size(x);
phi(1:s,1) = x(:,1).*x(:,1);
phi(1:s,2) = sqrt(2).*x(:,1).*x(:,2);
phi(1:s,3) = x(:,2).*x(:,2);

[s2,~]=size(xn);
phin(1:s2,1) = xn(:,1).*xn(:,1);
phin(1:s2,2) = sqrt(2).*xn(:,1).*xn(:,2);
phin(1:s2,3) = xn(:,2).*xn(:,2);
K = phi*phin';