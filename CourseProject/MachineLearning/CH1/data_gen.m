sigma = 0.01;
pos = [normrnd(1,sqrt(sigma),[300,1]),normrnd(1,sqrt(sigma),[300,1])];
neg = [
    normrnd(0,sqrt(sigma),[100,1]),normrnd(0,sqrt(sigma),[100,1]);
    normrnd(0,sqrt(sigma),[100,1]),normrnd(1,sqrt(sigma),[100,1]);
    normrnd(1,sqrt(sigma),[100,1]),normrnd(0,sqrt(sigma),[100,1])
    ];

figure(1);
plot(pos(:,1),pos(:,2),'ro');
hold on;
plot(neg(:,1),neg(:,2),'go');
hold on;
xlabel('x','Fontsize',15);
ylabel('y','Fontsize',15);
title('随机生成原始数据','Fontsize',20);
grid on;