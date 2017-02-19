clc;
clear;
data = csvread('hiv_data.csv',1,0);

X_train = data(1:2000,1:8);
X_test = data(2001:2720,1:8);
y_train = data(1:2000,9);
y_test = data(2001:2720,9);
tic
an = zeros(2000,1);

theta_0 = 1;
theta_1 = 0.5;

k = zeros(2000,2000);
for n=1:2000
    k(1:2000,n) = theta_0 * exp(-0.5*sum((X_train-X_train(n,:)).^2,2))+theta_1;
end

Cn = k + 0.01 * eye(2000);


for i=1:100
	Wn = diag(sig(an).*(1-sig(an)));
	an = Cn*inv(eye(2000)+Wn*Cn)*(y_train-sig(an)+Wn*an); 
end
toc

y_train_pre = sig(an);
y_train_pre(y_train_pre>=0.5)=1;
y_train_pre(y_train_pre<0.5)=0;
accu_train = sum(y_train_pre==y_train)/2000;
Wn
% Test

K = zeros(2000,720);
for n=1:720
    K(:,n) = theta_0 * exp(-0.5*sum((X_train-X_test(n,:)).^2,2))+theta_1;
end

E = K'*(y_train-sig(an));
y_test_pre = sig(E);
y_test_pre(y_test_pre>=0.5)=1;
y_test_pre(y_test_pre<0.5)=0;
accu_test = sum(y_test_pre==y_test)/720;