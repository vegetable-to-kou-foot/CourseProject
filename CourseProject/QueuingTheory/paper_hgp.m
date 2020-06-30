max_test = 10000;
lambda_his = zeros(max_test,1);
k_his = zeros(max_test,1);
for t = 1:max_test
max_iter = 50;
a = gen_rand();
[V,D] = eig(a');
if (V(1,1)<0)
    V(:,1) = -V(:,1);
end
eps = 1e-5;
k_tmp = 0;
for i=1:max_iter
    if k_tmp == 0
        a_i = a^i;
        if abs(det(a_i)) < eps
            k_tmp = i;
        end
    end
end
% MATLAB会将有一些矩阵的1特征值放到错误的位置，这里做纠正
D = sort(max(abs(D)));
lambda_his(t) = ceil(log(eps)/log(abs(D(2))+eps));
k_his(t) = k_tmp;
end

fit_y = zeros(max(k_his)-min(k_his)+1,1);
fit_x = zeros(max(k_his)-min(k_his)+1,1);
for i = min(k_his):max(k_his)
    fit_x(i) = i;
    % 这一步执行不过去就多跑几次
    fit_y(i) = min(lambda_his(k_his==i));
end


kb  = polyfit(fit_x,fit_y,1);

figure(1);
x = 1:0.1:max(fit_x)+1;
plot(lambda_his,k_his,'b+', kb(1)*x+kb(2),x,'r-');
legend('(lambdaPred,k)','回归直线');
title('k-lambdaPred散点图','FontSize',20);
xlabel('lambdaPred','FontSize',15);
ylabel('k','FontSize',15);


function A = gen_rand()
% 目前仅支持3维
base = rand(3,2);
for i=1:3
    if base(i,1)<=1/2^0.5 && base(i,2)>base(i,1)*3^0.5
        base(i,1) = 1/2^0.5 - base(i,1);
        base(i,2) = 6^0.5/2 - base(i,2);
    elseif base(i,1)>1/2^0.5 && base(i,2)>6^0.5-base(i,1)*3^0.5
        base(i,1) = 3/2^0.5 - base(i,1);
        base(i,2) = 6^0.5/2 - base(i,2);
    end
end
A = zeros(3,3);
A(:,1) = 1-base(:,1)/2^0.5-base(:,2)/6^0.5;
A(:,2) = base(:,1)/2^0.5-base(:,2)/6^0.5;
A(:,3) = 2*base(:,2)/6^0.5;
end