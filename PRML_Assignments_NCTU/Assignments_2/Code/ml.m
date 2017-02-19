function [class, class_test] = ml(x_train, y_train, x_test, y_test)
N(1) = sum(y_train==1);
N(2) = sum(y_train==2);
N(3) = sum(y_train==3);

pi = zeros(1);
pi(1) = N(1)/sum(N);
pi(2) = N(2)/sum(N);
pi(3) = N(3)/sum(N);

[~,tag] = size(x_train);
miu = zeros(3,tag);
for i=1:120
    miu(y_train(i,1),:) = miu(y_train(i,1),:) + x_train(i,:);
end
for i=1:3
    miu(i,:) = miu(i,:)/N(i);
end

S = zeros(1);
for i=1:120
    S = S + (x_train(i,:)-miu(y_train(i),:))'*(x_train(i,:)-miu(y_train(i),:));
end
S = S/sum(N);

for i=1:3
    w0(i)=-0.5*miu(i,:)*inv(S)*miu(i,:)'+log(pi(i));
end
w1 = inv(S)*miu(1,:)';
w2 = inv(S)*miu(2,:)';
w3 = inv(S)*miu(3,:)';

for i=1:120
    a1(i) = w1'*x_train(i,:)'+w0(1);
    a2(i) = w2'*x_train(i,:)'+w0(2);
    a3(i) = w3'*x_train(i,:)'+w0(3);
end

for i=1:120
	p_posterior(i,1) = exp(a1(i))/(exp(a1(i))+exp(a2(i))+exp(a3(i)));
    p_posterior(i,2) = exp(a2(i))/(exp(a1(i))+exp(a2(i))+exp(a3(i)));
    p_posterior(i,3) = exp(a3(i))/(exp(a1(i))+exp(a2(i))+exp(a3(i)));
end
for i=1:120
    [~,result(i,1)] = max(p_posterior(i,:));
end
for i=1:3
    N_true(i) = sum(result==i);
end
class = zeros(3);
for i=1:120
    if y_train(i)==1 && result(i)==1
        class(1,1) = class(1,1)+1;
    elseif y_train(i)==1 && result(i)==2
        class(1,2) = class(1,2)+1;
    elseif y_train(i)==1 && result(i)==3
        class(1,3) = class(1,3)+1;
    elseif y_train(i)==2 && result(i)==1
        class(2,1) = class(2,1)+1;
    elseif y_train(i)==2 && result(i)==2
        class(2,2) = class(2,2)+1;
    elseif y_train(i)==2 && result(i)==3
        class(2,3) = class(2,3)+1;
    elseif y_train(i)==3 && result(i)==1
        class(3,1) = class(3,1)+1;
    elseif y_train(i)==3 && result(i)==2
        class(3,2) = class(3,2)+1;
    elseif y_train(i)==3 && result(i)==3
        class(3,3) = class(3,3)+1;
    end
end


% Test set
for i=1:30
    a1_test(i) = w1'*x_test(i,:)'+w0(1);
    a2_test(i) = w2'*x_test(i,:)'+w0(2);
    a3_test(i) = w3'*x_test(i,:)'+w0(3);
end

for i=1:30
	p_posterior_test(i,1) = exp(a1_test(i))/(exp(a1_test(i))+exp(a2_test(i))+exp(a3_test(i)));
    p_posterior_test(i,2) = exp(a2_test(i))/(exp(a1_test(i))+exp(a2_test(i))+exp(a3_test(i)));
    p_posterior_test(i,3) = exp(a3_test(i))/(exp(a1_test(i))+exp(a2_test(i))+exp(a3_test(i)));
end
for i=1:30
    [~,result_test(i,1)] = max(p_posterior_test(i,:));
end
for i=1:3
    N_true_test(i) = sum(result_test==i);
end
class_test = zeros(3);
for i=1:30
    if y_test(i)==1 && result_test(i)==1
        class_test(1,1) = class_test(1,1)+1;
    elseif y_test(i)==1 && result_test(i)==2
        class_test(1,2) = class_test(1,2)+1;
    elseif y_test(i)==1 && result_test(i)==3
        class_test(1,3) = class_test(1,3)+1;
    elseif y_test(i)==2 && result_test(i)==1
        class_test(2,1) = class_test(2,1)+1;
    elseif y_test(i)==2 && result_test(i)==2
        class_test(2,2) = class_test(2,2)+1;
    elseif y_test(i)==2 && result_test(i)==3
        class_test(2,3) = class_test(2,3)+1;
    elseif y_test(i)==3 && result_test(i)==1
        class_test(3,1) = class_test(3,1)+1;
    elseif y_test(i)==3 && result_test(i)==2
        class_test(3,2) = class_test(3,2)+1;
    elseif y_test(i)==3 && result_test(i)==3
        class_test(3,3) = class_test(3,3)+1;
    end
end
