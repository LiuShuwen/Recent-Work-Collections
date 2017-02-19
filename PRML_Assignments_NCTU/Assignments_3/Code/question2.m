clear;
clc;
load('Iris.mat')

% Linear Kernel
tic
[y_pre_train,y_pre_test, alpha, bias] = SVM(trainLabel,trainFeature,testFeature,'Linear');
accu_train_linear = accuracy(y_pre_train,trainLabel);
accu_test_linear = accuracy(y_pre_test, testLabel);
toc

% plot
figure(1);
% Decision Boundry
xrange = [4 8];
yrange = [2 4.5];
% step size for how finely you want to visualize the decision boundary.
inc = 0.01;
% generate grid coordinates. this will be the basis of the decision
% boundary visualization.
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2));
% size of the (x, y) image, which will also be the size of the 
% decision boundary image that is used as the plot background.
image_size = size(x);
 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
xy = [reshape(x, image_size(1)*image_size(2),1) reshape(y, image_size(1)*image_size(2),1)];

[~,idx,~,~] = SVM(trainLabel,trainFeature,xy,'Linear');
% reshape the idx (which contains the class label) into an image.
decisionmap = reshape(idx, image_size);
 
%show the image
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
 
% colormap for the classes:
% class 1 = light red, 2 = light green, 3 = light blue
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1];
colormap(cmap);
 plot(trainFeature(1:40,1),trainFeature(1:40,2),['x','red']);
hold on;
plot(trainFeature(41:80,1),trainFeature(41:80,2),['+','green']);

plot(trainFeature(81:120,1),trainFeature(81:120,2),['*','blue']);

index = zeros(120,1);

cnt = 1;
for i=1:120
    if max(alpha(i,:))~=0
        index(i,1)=1;
        supportVector(cnt,1:2) = trainFeature(i,1:2);
        cnt=cnt+1;
    end
end

plot(supportVector(:,1),supportVector(:,2),['o','black']);
 
% include legend
legend('Class 1', 'Class 2', 'Class 3','Location','NorthOutside', ...
    'Orientation', 'horizontal');
 
% label the axes.
xlabel('Sepal Length');
ylabel('Sepal Width');
print('-r300','-djpeg','Q2_Linear.jpg');

% Polynomial (homogeneous) kernel of degree 2
tic
[y_pre_train,y_pre_test, alpha, bias] = SVM(trainLabel,trainFeature,testFeature,'Polynomial');
accu_train_ploynomial = accuracy(y_pre_train,trainLabel);
accu_test_ploynomial = accuracy(y_pre_test, testLabel);
toc

% plot
figure(2);
% Decision Boundry
xrange = [4 8];
yrange = [2 4.5];
% step size for how finely you want to visualize the decision boundary.
inc = 0.01;
% generate grid coordinates. this will be the basis of the decision
% boundary visualization.
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2));
% size of the (x, y) image, which will also be the size of the 
% decision boundary image that is used as the plot background.
image_size = size(x);
 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
xy = [reshape(x, image_size(1)*image_size(2),1) reshape(y, image_size(1)*image_size(2),1)];

[~,idx,~,~] = SVM(trainLabel,trainFeature,xy,'Polynomial');
% reshape the idx (which contains the class label) into an image.
decisionmap = reshape(idx, image_size);
 
%show the image
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
 
% colormap for the classes:
% class 1 = light red, 2 = light green, 3 = light blue
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1];
colormap(cmap);

plot(trainFeature(1:40,1),trainFeature(1:40,2),['x','red']);
hold on;
plot(trainFeature(41:80,1),trainFeature(41:80,2),['+','green']);

plot(trainFeature(81:120,1),trainFeature(81:120,2),['*','blue']);

index = zeros(120,1);

cnt = 1;
for i=1:120
    if max(alpha(i,:))~=0
        index(i,1)=1;
        supportVector(cnt,1:2) = trainFeature(i,1:2);
        cnt=cnt+1;
    end
end

plot(supportVector(:,1),supportVector(:,2),['o','black']);
 
% include legend
legend('Class 1', 'Class 2', 'Class 3','Location','NorthOutside', ...
    'Orientation', 'horizontal');
 
% label the axes.
xlabel('Sepal Length');
ylabel('Sepal Width');

print('-r300','-djpeg','Q2_Polynomial.jpg');