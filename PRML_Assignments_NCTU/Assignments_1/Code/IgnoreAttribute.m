function [E_train, E_test] = IgnoreAttribute(data, columns)
x = data(:,columns);
y = data(:,5);
phi = calculatePhi(x);
y_train = y(1:400,:);
y_test = y(401:500,:);

phi3_train = phi(1:400,:);
phi3_test = phi(401:500,:);

w3 = pinv(phi3_train'*phi3_train)*phi3_train'*y_train;

y_train_pre3 = phi3_train * w3;
E_train = sqrt(sum((y_train_pre3 - y_train).^2)/400);

y_test_pre3 = phi3_test * w3;
E_test = sqrt(sum((y_test_pre3 - y_test).^2)/100);