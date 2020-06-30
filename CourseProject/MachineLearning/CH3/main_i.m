delt = 1;
N = 500;
x_tmp = (rand(1,N)-0.5)*N;
y = x_tmp + delt*randn(size(x_tmp));
x = ones(2,N);
x(2,:) = x_tmp;

theta = rand(2,1)-0.5;
max_gen = 50;
alpha = 0.00003;
J_his = zeros(max_gen,1);
theta_his = zeros(2,max_gen);
for i = 1:max_gen
    J_his(i) = 0.5*mean((y-theta'*x).^2);
    theta_his(:,i) = theta;
    theta = theta + alpha*mean( repmat((y-theta'*x),2,1).*x ,2);
end
figure(1);
plot(J_his);
title('��ʧ�����仯����','FontSize',25);
xlabel('generation','FontSize',20);
ylabel('��ʧֵ','FontSize',20);
figure(2);
plot(x_tmp,y,'bo');
hold on;
plot(x_tmp,theta'*x,'r-');
title('ɢ��ͼ��ѧϰ���','FontSize',25);
xlabel('x','FontSize',20);
ylabel('y','FontSize',20);