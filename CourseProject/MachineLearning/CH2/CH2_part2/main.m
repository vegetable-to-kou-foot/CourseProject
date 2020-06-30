data = [0 0 1 1;0 1 0 1;0 0 0 1];
gen_max = 1000;
[theta_his,loss_his] = logistic_regression(data,gen_max);
figure(1);
plot(loss_his);
xlabel('迭代次数','FontSize',15);
ylabel('损失','FontSize',15);
title('损失-迭代次数','FontSize',20);

figure(2);
mask = data(3,:) == 0;
plot(data(1,mask),data(2,mask),'go');
hold on;
plot(data(1,~mask),data(2,~mask),'ro');
t = -1:0.1:3;
theta = theta_his(:,end);
plot(t,(-theta(1)-theta(2)*t)/theta(3),'b-');
xlabel('x_1','FontSize',15);
ylabel('x_2','FontSize',15);