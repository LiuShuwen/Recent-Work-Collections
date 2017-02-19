clc;
clear all;
% Read dataset
load('.\Hw1\Data\t3.mat');
load('.\Hw1\Data\x3.mat');

x_train = x3_v2.train_x;
x_test = x3_v2.test_x;
y_train = t3_v2.train_y;
y_test = t3_v2.test_y;
x(1:15,1)=x_train;
x(16:25,1)=x_test;

Erms_test = zeros(3);
Erms_train = zeros(3);
w = {};
for M=1:9
    [Erms_train(M,1), Erms_train(M,2), Erms_train(M,3), w{M,1}, w{M,2}, w{M,3}, Erms_test(M,1), Erms_test(M,2), Erms_test(M,3),phi] = train(M,x,y_train);
    [~,y] = min(Erms_test(M,1:3));
    best_w{M,1} = w{M,y};
    y_test_pre = phi(16:25,1:M+1) * best_w{M,1};
    Erms(M,2) = sqrt(sum((y_test_pre - y_test).^2)/10);
    %y_train_pre = phi(1:15,1:M+1) * best_w{M,1};
    %Erms(M,1) = sqrt(sum((y_train_pre - y_train).^2)/15);
    Erms(M,1) = Erms_train(y);
end

figure(1);
plot([1:M],Erms);
title('The Training and Testing Error of Different Orders');
xlabel('Order');
ylabel('Erms');
legend('Training Set','Testing Set');
print('-r300','-djpeg','Q4_1.jpg');


