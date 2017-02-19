clc;
clear;
data_train = csvread('./Data/kdd99_training_data.csv',1,0);
data_test = csvread('./Data/kdd99_testing_data.csv',1,0);



% split dataset
x_train = data_train(:,1:10);
y_train = data_train(:,11);
x_test = data_test(:,1:10);
y_test = data_test(:,11);
for i=1:200
    y_train(i)=y_train(i)+1;
end
for i=1:50
    y_test(i)=y_test(i)+1; 
end


w = zeros(5,10);
iter = 0;
while iter < 398
    iter = iter+1;
    for i=1:200
        for j=1:5
            a(i,j) = w(j,:) * x_train(i,:)';
        end
    end

    for i=1:200
        for j=1:5
            p(i,j) = exp(a(i,j))/sum(exp(a(i,:)));
        end
    end
    t = [0];
    for i=1:200
        if y_train(i) == 1
            t(i,1)=1;   t(i,2:5)=0;
        elseif y_train(i) == 2
            t(i,2)=1;   t(i,[1 3 4 5])=0;
        elseif y_train(i) == 3
            t(i,3)=1;   t(i,[1 2 4 5])=0;
        elseif y_train(i) == 4
            t(i,4)=1;   t(i,[1 2 3 5])=0;
        elseif y_train(i) == 5
            t(i,5)=1;   t(i,1:4)=0;
        end
    end

    E(iter) = zeros(1);
    for i=1:200
        for j=1:5
            E(iter) = E(iter) + t(i,j)*log(p(i,j));
        end
    end
    E(iter) = -E(iter);
    gradE = zeros(5,10);

    for i=1:5
        for j = 1:200
            gradE(i,:) = gradE(i,:) + (p(j,i)-t(j,i))*x_train(j,:);
        end
    end
    
    gra2E1 = zeros(10); gra2E2 = zeros(10); 
    gra2E3 = zeros(10); gra2E4 = zeros(10); gra2E5 = zeros(10);
	for n=1:200
        gra2E1 = gra2E1 + p(n,1)*(1-p(n,1))*x_train(n,:)'*x_train(n,:);
        gra2E2 = gra2E2 + p(n,2)*(1-p(n,2))*x_train(n,:)'*x_train(n,:);
        gra2E3 = gra2E3 + p(n,3)*(1-p(n,3))*x_train(n,:)'*x_train(n,:);
        gra2E4 = gra2E4 + p(n,4)*(1-p(n,4))*x_train(n,:)'*x_train(n,:);
        gra2E5 = gra2E5 + p(n,5)*(1-p(n,5))*x_train(n,:)'*x_train(n,:);
	end

    eta = 0.01;

    w(1,:) = (w(1,:)' -  eta * inv(gra2E1) * gradE(1,:)')';
    w(2,:) = (w(2,:)' -  eta * inv(gra2E2) * gradE(2,:)')';
    w(3,:) = (w(3,:)' -  eta * inv(gra2E3) * gradE(3,:)')';
    w(4,:) = (w(4,:)' -  eta * inv(gra2E4) * gradE(4,:)')';
    w(5,:) = (w(5,:)' -  eta * inv(gra2E5) * gradE(5,:)')';
    
end

% test
for i=1:50
    for j=1:5
        a_test(i,j) = w(j,:) * x_test(i,:)';
    end
end
for i=1:50
    for j=1:5
        p_test(i,j) = exp(a_test(i,j))/sum(exp(a_test(i,:)));
    end
end
miss = 0;
for i=1:50
    [~,result_test(i)]=max(p_test(i,:));
    if result_test(i) ~= y_test(i)
        miss = miss+1;
    end
end
missrate = miss/50

figure(1);
plot([1:398],E);
title('cross entropy');
xlabel('iteration');
print('-r300','-djpeg','crossentropy2.jpg');