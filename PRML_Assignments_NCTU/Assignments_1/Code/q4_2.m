clc;
clear all;
% Read dataset
load('.\Hw1\Data\t3.mat');
load('.\Hw1\Data\x3.mat');

M=9;

x_train = x3_v2.train_x;
x_test = x3_v2.test_x;
y_train = t3_v2.train_y;
y_test = t3_v2.test_y;
x(1:15,1)=x_train;
x(16:25,1)=x_test;

phi(1:25,1)=1;
for j=1:25
	for i=2:M+1
        phi(j,i)=x(j,1).^(i-1); 
	end
end

for p = -20:5
    phi_train = phi(1:15,:);
    phi_test = phi(16:25,:);
    w = (exp(p)*eye(10) + phi_train'*phi_train)\phi_train'*y_train;
    y_train_pre = phi_train * w;
    Erms_train(p+21) = sqrt(sum((y_train_pre - y_train).^2)/15);
    y_test_pre = phi_test * w;
    Erms_test(p+21) = sqrt(sum((y_test_pre - y_test).^2)/10);
end

plot([Erms_train' Erms_test']);
xlabel('ln{\lambda}');
ylabel('E_{rms}');
legend('Training Set','Testing Set');
print('-r300','-djpeg','Q4_22.jpg');