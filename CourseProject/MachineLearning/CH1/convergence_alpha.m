function iter = convergence_alpha(sigma)
pos = [normrnd(1,sqrt(sigma),[300,1]),normrnd(1,sqrt(sigma),[300,1])];
neg = [
    normrnd(0,sqrt(sigma),[100,1]),normrnd(0,sqrt(sigma),[100,1]);
    normrnd(0,sqrt(sigma),[100,1]),normrnd(1,sqrt(sigma),[100,1]);
    normrnd(1,sqrt(sigma),[100,1]),normrnd(0,sqrt(sigma),[100,1])
    ];
X = [ones(300,1),pos;ones(300,1),neg]';
y = [ones(300,1);zeros(300,1)];

m = size(X,2);
iter = [];
for alpha = 0.01:0.03:1
    alpha
    theta = [0 0 0]';
    J = loss(X,y,theta);
    J_last = 0;
    J_his = [];
    while abs(J-J_last) >= 1e-6
        J_last = J;
        theta = theta - alpha*X*(sigmoid(X,theta)-y)/m;
        J = loss(X,y,theta);
        J_his = [J_his;J];
    end
    iter = [iter;length(J_his)];
end
iter(iter>=100000) = 100000;
plot(1:length(iter),iter,'b-');
xlabel('\alpha','Fontsize',15);
ylabel('迭代次数','Fontsize',15);
title('收敛速度','Fontsize',20);
end