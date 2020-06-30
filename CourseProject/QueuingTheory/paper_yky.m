max_test = 10000;
det_his = zeros(max_test,1);
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
det_his(t) = abs(det(a));
k_his(t) = k_tmp;
end

kb  = polyfit(k_his,det_his,1);
% myf = @(beta,x)1./(beta(1)+beta(2).*exp(-x));
% beta0 = [0.2,0.2]';
% beta = nlinfit(k_his,det_his,myf,beta0);

figure(1);
x = 1:0.1:max(k_his)+1;
% plot(k_his,det_his,'b+', x,myf(beta,x),'r-');
plot(k_his,det_his,'b+', x,kb(1)*x+kb(2),'r-');
legend('(k,|p|)','回归直线');
title('|P|-k散点图','FontSize',20);
xlabel('k','FontSize',15);
ylabel('|P|','FontSize',15);


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