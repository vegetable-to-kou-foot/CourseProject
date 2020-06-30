%% ѹ������
clear;
clc;
dim = 3;
% һ��һ�����ݵ㣬ÿ�����ݵ�mά��һ��n�����ݵ�
load fisheriris;
data = meas';
[m,n] = size(data);
% �����ݶ�����ԭ�㸽��
X = data-repmat(mean(data,2),1,n);
% C��Э�������
C = (X*X')/(n-1);
% SVD�ֽ��ȡǰdimά����������Ϣ����dimά
% ��ѹ����dimά
[U,S,V] = svd(C);
U_2 = U(:,1:dim);
S_2 = S(1:dim,1:dim);
V_2 = V(:,1:dim);
% ��һ���������ı任
Y = U_2'*X;

%D�ǶԽ����ҷ���D=PCP'��֤�������ȷ��P������ı任
D = (Y*Y')/(n-1);
D_test = U_2'*C*U_2;

%% ���ӻ�
figure(1);
x = Y(1,:);
y = Y(2,:);
z = Y(3,:);
mask1 = 1:50;
mask2 = 51:100;
mask3 = 101:150;
plot3(x(mask1),y(mask1),z(mask1),'ro',x(mask2),y(mask2),z(mask2),'go',...
    x(mask3),y(mask3),z(mask3),'bo','MarkerSize',5,'LineWidth',1);
title('PCAӦ����iris��','FontSize',20);
xlabel('x_1','FontSize',15);
ylabel('x_2','FontSize',15);
zlabel('x_3','FontSize',15);
grid on
hold on
