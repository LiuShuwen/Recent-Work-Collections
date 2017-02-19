clc;
clear;
data = csvread('gp_data.csv',1,0);

X_train = data(1:1200,1:2);
X_test = data(1201:1600,1:2);
y_train = data(1:1200,3);
y_test = data(1201:1600,3);


t = y_train;
K = kernel(X_train,X_test);
k = kernel(X_train,X_train);

C = k + 0.01 * eye(1200);
m = K'* inv(C) * t;

Erms = sqrt(2*sum((m-y_test).^2)/400);

figure(1);
plot3(X_test(:,1),X_test(:,2),m,'*','DisplayName','Regression Output');
hold on;
plot3(X_test(:,1),X_test(:,2),y_test,'o','DisplayName','Ground Truth');
xlabel('x1(attribute1)');
ylabel('x2(attribute2)');
zlabel('y');
legend('show')

print('-r300','-djpeg','Q1_a.jpg');