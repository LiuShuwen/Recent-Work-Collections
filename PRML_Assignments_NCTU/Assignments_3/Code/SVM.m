function [y_pre_train,y_pre_test, alpha, bias] = SVM(trainLabel,trainFeature,testFeature,Kernel)
% parameters
C = 1000;
tol = 0.001;
% Kernel function
if strcmp(Kernel,'Linear')
    K_train = LinearKernel(trainFeature,trainFeature);
    K_test = LinearKernel(testFeature,trainFeature);
elseif strcmp(Kernel, 'Polynomial')
    K_train = PolynomialKernel(trainFeature, trainFeature);
    K_test = PolynomialKernel(testFeature, trainFeature);
end
% training
[s,~] = size(testFeature);
for tag=1:3
    % One versus the rest
    y = OneVersusRest(trainLabel, tag);
    % SMO
    [alpha(1:120,tag),bias(tag)] = smo(K_train, y, C, tol);
    % predict
    score_train(1:120,tag) = 0;
    score_test(1:s,tag) = 0;
    score_train(:,tag) = sum(alpha(:,tag).*y'.*K_train)'+bias(tag);
    score_test(:,tag) = sum(alpha(:,tag).*y'.*K_test')'+bias(tag);
end

y_pre_train = zeros(120,1);
y_pre_test = zeros(s,1);
for i=1:120
    [~, y_pre_train(i,1)] = max(score_train(i,:));
end
for i=1:s
    [~, y_pre_test(i,1)] = max(score_test(i,:));
end
