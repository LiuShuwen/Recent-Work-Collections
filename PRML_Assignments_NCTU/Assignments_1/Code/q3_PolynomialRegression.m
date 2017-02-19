clc;
clear all;
% Read dataset
[data,~,raw]=xlsread('C:\Users\Shuwen Liu\Desktop\NCTU\Machine Learning\Assignments\Hw1\Data\data.xlsx');

x = data(:,1:4);
y = data(:,5);

phi = calculatePhi(x);

% Split training set & test set
x_train = x(1:400,:);
y_train = y(1:400,:);
x_test = x(401:500,:);
y_test = y(401:500,:);

% two dimension
phi2_train = phi(1:400,1:21);
phi2_test = phi(401:500,1:21);
w2 = pinv(phi2_train'*phi2_train)*phi2_train'*y_train;

y_train_pre2 = phi2_train * w2;
Erms_train2 = sqrt(sum((y_train_pre2 - y_train).^2)/400);

y_test_pre2 = phi2_test * w2;
Erms_test2 = sqrt(sum((y_test_pre2 - y_test).^2)/100);

% three dimension
phi3_train = phi(1:400,:);
phi3_test = phi(401:500,:);

w3 = pinv(phi3_train'*phi3_train)*phi3_train'*y_train;

y_train_pre3 = phi3_train * w3;
Erms_train3 = sqrt(sum((y_train_pre3 - y_train).^2)/400);

y_test_pre3 = phi3_test * w3;
Erms_test3 = sqrt(sum((y_test_pre3 - y_test).^2)/100);

% Select the most contributive attribute
[E_train_T, E_test_T] = IgnoreAttribute(data,[2,3,4]);
[E_train_V, E_test_V] = IgnoreAttribute(data,[1,3,4]);
[E_train_AP, E_test_AP] = IgnoreAttribute(data,[1,2,4]);
[E_train_RH, E_test_RH] = IgnoreAttribute(data,[1,2,3]);
