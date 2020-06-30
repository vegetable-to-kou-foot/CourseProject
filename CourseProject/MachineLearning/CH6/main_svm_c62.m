clear;
clc;
X = [0.697	0.46;0.774	0.376;0.634	0.264;0.608	0.318;0.556	0.215;...
0.403	0.237;0.481	0.149;0.437	0.211;0.666	0.091;0.243	0.267;0.245	0.057;...
0.343	0.099;0.639	0.161;0.657	0.198;0.36	0.37;0.593	0.042;0.719	0.103];
X = (X-mean(X,1))./std(X,1);
y = [ones(8,1);zeros(9,1)];

SVMModel = fitcsvm(X,y,'KernelFunction','linear');
svIdx = SVMModel.IsSupportVector;
h = 0.01; % Mesh grid step size
[X1,X2] = meshgrid(min(X(:,1))-0.05:h:max(X(:,1))+0.05,...
    min(X(:,2))-0.05:h:max(X(:,2))+0.05);
% X1 = (X1-mean(X1(:)))./std(X1(:));
% X2 = (X2-mean(X2(:)))./std(X2(:));
[~,score] = predict(SVMModel,[X1(:),X2(:)]);
score = max(score,[],2);
scoreGrid = reshape(score,size(X1));

figure(1);
mask = y == 0;
plot(X(mask,1),X(mask,2),'b+','LineWidth',2)
hold on
mask = y == 1;
plot(X(mask,1),X(mask,2),'r+','LineWidth',2)
plot(X(svIdx,1),X(svIdx,2),'bo','MarkerSize',10,'LineWidth',2)
contour(X1,X2,scoreGrid,'ShowText','on');
title('线性核SVM等高线图')
xlabel('密度')
ylabel('含糖率')
hold off
