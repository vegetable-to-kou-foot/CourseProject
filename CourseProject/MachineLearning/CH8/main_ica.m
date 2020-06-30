%% 执行ICA
clear
clc
load fisheriris;
X = myPCA(meas',3);
Y = myICA(X);
%% 可视化
figure(1);
a = X(1,:);
b = X(2,:);
c = X(3,:);
x = Y(1,:);
y = Y(2,:);
z = Y(3,:);
mask1 = 1:50;
mask2 = 51:100;
mask3 = 101:150;
plot3(a(mask1),b(mask1),c(mask1),'r^',a(mask2),b(mask2),c(mask2),'g^',...
    a(mask3),b(mask3),c(mask3),'b^','MarkerSize',5,'LineWidth',1);
hold on
plot3(x(mask1),y(mask1),z(mask1),'ro',x(mask2),y(mask2),z(mask2),'go',...
    x(mask3),y(mask3),z(mask3),'bo','MarkerSize',5,'LineWidth',1);
title('ICA应用于iris上','FontSize',20);
xlabel('x_1','FontSize',15);
ylabel('x_2','FontSize',15);
zlabel('x_3','FontSize',15);
grid on
hold on
