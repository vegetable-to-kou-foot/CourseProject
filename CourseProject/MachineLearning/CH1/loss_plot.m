data_gen;
X = [ones(300,1),pos;ones(300,1),neg]';
y = [ones(300,1);zeros(300,1)];
m = size(X,2);
theta = [0 0 0]';
alpha = 0.3;
J = loss(X,y,theta);
J_last = 0;
J_his = [];
theta_his = [];
while abs(J-J_last) >= 1e-6
    J_last = J;
    theta = theta - alpha*X*(sigmoid(X,theta)-y)/m;
    J = loss(X,y,theta);
    J_his = [J_his;J];
    theta_his = [theta_his,theta];
end


temp = -1:0.1:2;
plot(temp,(-theta(1)-theta(2)*temp)/theta(3),'b-');
figure(2);
step = 1.5;
for w0 = -20:step:0
[A,B] = meshgrid(-20:step:20,-20:step:20);
C = zeros(size(A));
for i = 1:size(A,1)
    for j = 1:size(A,2)
        C(i,j) = loss(X,y,[w0,A(i,j),B(i,j)]');
    end
end
scatter3(w0*ones(size(A(:))),A(:),B(:),15,C(:),'filled');
hold on
end

mask = 1:100:size(theta_his,2);
scatter3(theta_his(1,mask),theta_his(2,mask),theta_his(3,mask),40,'k^');
xlabel('\theta_0','Fontsize',15);
ylabel('\theta_1','Fontsize',15);
zlabel('\theta_2','Fontsize',15);
title('损失函数及梯度下降路径','Fontsize',20);