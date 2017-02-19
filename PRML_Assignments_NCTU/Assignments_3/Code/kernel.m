function [k] = kernel(xn,xm)

theta_0 = 1;
theta_1 = 0.5;

[s,~] = size(xm);

k = zeros(1200,400);
for n=1:s
    k(:,n) = theta_0 * exp(-0.5*sum((xn-xm(n,:)).^2,2))+theta_1;
end