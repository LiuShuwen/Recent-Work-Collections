clc;
clear;
[X, y, data] = xlsread('./Data/Irisdat.xls');
y(strcmp('SETOSA', y)) = {'1'};
y(strcmp('VIRGINIC', y)) = {'2'};
y(strcmp('VERSICOL', y)) = {'3'};
y = cellfun(@str2num, y(2:151,5));

x_train = X(1:120,:);
y_train = y(1:120,:);
x_test = X(121:150,:);
y_test = y(121:150,:);


% q(1)
[class, class_test] = ml(x_train, y_train, x_test, y_test);

% PCA - 3d
[V,D] = eig(X'*X);
T3 = X * V(:,2:4);
[class_3pca, class_test_3pca] = ml(T3(1:120,:), y_train, T3(121:150,:), y_test);
% split data - class
tag1 = 1; tag2 = 1; tag3 = 1;
for i=1:150
   if y(i)==1
       class1(tag1,:)=T3(i,:);
       tag1 = tag1+1;
   elseif y(i)==2
       class2(tag2,:)=T3(i,:);
       tag2=tag2+1;
   else
       class3(tag3,:)=T3(i,:);
       tag3=tag3+1;
   end
end
% plot3
figure(1);
plot3(class1(:,1),class1(:,2),class1(:,3),['o','b'],class2(:,1),class2(:,2),class2(:,3),['o','g'],class3(:,1),class3(:,2),class3(:,3),['o','r']);
title('PCA');
print('-r300','-djpeg','PCA.jpg');

% PCAΩµŒ¨÷¡2Œ¨
[V,D] = eig(x_train'*x_train);
T2 = X * V(:,3:4);
[class_2pca, class_test_2pca] = ml(T2(1:120,:), y_train, T2(121:150,:), y_test);

% PCAΩµŒ¨÷¡1Œ¨
[V,D] = eig(x_train'*x_train);
T1 = X * V(:,4);
[class_1pca, class_test_1pca] = ml(T1(1:120,:), y_train, T1(121:150,:), y_test);

% LDA - 3d
N(1) = sum(y==1);   N(2) = sum(y==2);   N(3) = sum(y==3);
[~,tag] = size(X);
miu = zeros(3,tag);
for i=1:150
    miu(y(i,1),:) = miu(y(i,1),:) + X(i,:);
end
for i=1:3
    miu(i,:) = miu(i,:)/N(i);
end
m = 1/sum(N) * (N(1)*miu(1,:)+N(2)*miu(2,:)+N(3)*miu(3,:));
S = zeros(1);
SB = zeros(1);
for i=1:150
    S = S + (X(i,:)-miu(y(i),:))'*(X(i,:)-miu(y(i),:));
    SB = SB + N(1)*(miu(1,:)-m)'*(miu(1,:)-m) + N(2)*(miu(2,:)-m)'*(miu(2,:)-m) + N(3)*(miu(3,:)-m)'*(miu(3,:)-m);
end

[V,D] = eig(S\SB);
T3 = X * V(:,[1 2 4]);
[class_3lda, class_test_3lda] = ml(T3(1:120,:), y_train, T3(121:150,:), y_test);
% split data - class
tag1 = 1; tag2 = 1; tag3 = 1;
for i=1:150
   if y(i)==1
       class1(tag1,:)=T3(i,:);
       tag1 = tag1+1;
   elseif y(i)==2
       class2(tag2,:)=T3(i,:);
       tag2=tag2+1;
   else
       class3(tag3,:)=T3(i,:);
       tag3=tag3+1;
   end
end
% plot3
figure(2);
plot3(class1(:,1),class1(:,2),class1(:,3),['o','b'],class2(:,1),class2(:,2),class2(:,3),['o','g'],class3(:,1),class3(:,2),class3(:,3),['o','r']);
title('LDA');
print('-r300','-djpeg','LDA.jpg');


% LDA - 2d
[V,D] = eig(S\SB);
T2 = X * V(:,[1 2]);
[class_2lda, class_test_2lda] = ml(T2(1:120,:), y_train, T2(121:150,:), y_test);

% LDA - 1d
[V,D] = eig(S\SB);
T1 = X * V(:,1);
[class_1lda, class_test_1lda] = ml(T1(1:120,:), y_train, T1(121:150,:), y_test);