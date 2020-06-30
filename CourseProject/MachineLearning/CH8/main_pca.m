%% 压缩数据
clear;
clc;
dim = 3;
% 一列一个数据点，每个数据点m维，一共n个数据点
load fisheriris;
data = meas';
[m,n] = size(data);
% 将数据都移至原点附近
X = data-repmat(mean(data,2),1,n);
% C是协方差矩阵
C = (X*X')/(n-1);
% SVD分解后取前dim维，即保留信息最多的dim维
% 即压缩至dim维
[U,S,V] = svd(C);
U_2 = U(:,1:dim);
S_2 = S(1:dim,1:dim);
V_2 = V(:,1:dim);
% 做一个基向量的变换
Y = U_2'*X;

%D是对角阵，且符合D=PCP'，证明结果正确，P是所求的变换
D = (Y*Y')/(n-1);
D_test = U_2'*C*U_2;

%% 可视化
figure(1);
x = Y(1,:);
y = Y(2,:);
z = Y(3,:);
mask1 = 1:50;
mask2 = 51:100;
mask3 = 101:150;
plot3(x(mask1),y(mask1),z(mask1),'ro',x(mask2),y(mask2),z(mask2),'go',...
    x(mask3),y(mask3),z(mask3),'bo','MarkerSize',5,'LineWidth',1);
title('PCA应用于iris上','FontSize',20);
xlabel('x_1','FontSize',15);
ylabel('x_2','FontSize',15);
zlabel('x_3','FontSize',15);
grid on
hold on
