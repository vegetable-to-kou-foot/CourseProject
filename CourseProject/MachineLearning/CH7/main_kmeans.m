clear
clc
X = load('watermelon4.txt');
X = X(:,2:3)';
% �������ĵ�
% center = [0.3,0.15;0.7,0.15]';
% center = [0.48,0.3;0.52,0.3]';
% center = [0.28,0.45;0.32,0.45]';
% center = [0.3,0.15;0.7,0.15;0.5,0.45]';
% center = [0.48,0.3;0.5,0.3;0.52,0.3]';
% center = [0.28,0.45;0.3,0.45;0.32,0.45]';
% center = [0.3,0.15;0.7,0.15;0.3,0.4;0.7,0.4]';
% center = [0.48,0.3;0.5,0.35;0.5,0.25;0.52,0.3]';
center = [0.28,0.45;0.3,0.48;0.3,0.42;0.32,0.45]';
k = length(center);
% ����������
max_iter = 50;
% ����Ծ���ľ���
fdist = @(X,Y)sqrt(sum(X.^2,1)'+sum(Y.^2,1)-2*X'*Y+1e-10);
figure(1);
hold on
plot(center(1,1),center(2,1),'r^','MarkerSize',7);
plot(center(1,2),center(2,2),'g^','MarkerSize',7);
plot(center(1,3),center(2,3),'b^','MarkerSize',7);
plot(center(1,4),center(2,4),'k^','MarkerSize',7);
for i=1:max_iter
    % �����
    dist = fdist(X,center);
    % ��������
    [~,label] = min(dist,[],2);
    % ���¾�������
    for j = 1:k
        center(:,j) = mean(X(:,label == j),2);
    end
end

mask = label == 1;
plot(X(1,mask),X(2,mask),'r+');
plot(center(1,1),center(2,1),'ro','MarkerSize',7);
mask = label == 2;
plot(X(1,mask),X(2,mask),'g+');
plot(center(1,2),center(2,2),'go','MarkerSize',7);
mask = label == 3;
plot(X(1,mask),X(2,mask),'b+');
plot(center(1,3),center(2,3),'bo','MarkerSize',7);
mask = label == 4;
plot(X(1,mask),X(2,mask),'k+');
plot(center(1,4),center(2,4),'ko','MarkerSize',7);
title('K-means������','FontSize',20);
xlabel('�ܶ�','FontSize',15);
ylabel('������','FontSize',15);
