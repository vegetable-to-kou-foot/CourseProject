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
plot(1:length(J_his),J_his,'b-');
xlabel('迭代次数','Fontsize',15);
ylabel('损失','Fontsize',15);
title('损失变化情况','Fontsize',20);
grid on;
