function [Erms_train1, Erms_train2, Erms_train3, w1, w2, w3, Erms_test1, Erms_test2, Erms_test3,phi] = train(M,x,y_train)
phi(1:25,1)=1;
for j=1:25
	for i=2:M+1
        phi(j,i)=x(j,1).^(i-1); 
	end
end

phi_train1 = phi(1:10,:);
phi_test1 = phi(11:15,:);
w1 = (phi_train1'*phi_train1)\phi_train1'*y_train(1:10);
y_train_pre1 = phi_train1 * w1;
Erms_train1 = sqrt(sum((y_train_pre1 - y_train(1:10)).^2)/10);
y_test_pre1 = phi_test1 * w1;
Erms_test1 = sqrt(sum((y_test_pre1 - y_train(11:15)).^2)/5);

phi_train2 = phi(6:15,:);
phi_test2 = phi(1:5,:);
w2 = (phi_train2'*phi_train2)\phi_train2'*y_train(6:15);
y_train_pre2 = phi_train2 * w2;
Erms_train2 = sqrt(sum((y_train_pre2 - y_train(6:15)).^2)/10);
y_test_pre2 = phi_test2 * w2;
Erms_test2 = sqrt(sum((y_test_pre2 - y_train(1:5)).^2)/5);

phi_train3 = phi([1:5, 11:15],:);
phi_test3 = phi(6:10,:);
w3 = (phi_train3'*phi_train3)\phi_train3'*y_train([1:5,11:15]);
y_train_pre3 = phi_train3 * w3;
Erms_train3 = sqrt(sum((y_train_pre3 - y_train([1:5,11:15])).^2)/10);
y_test_pre3 = phi_test3 * w3;
Erms_test3 = sqrt(sum((y_test_pre3 - y_train(6:10)).^2)/5);