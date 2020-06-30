clear
clc
max_iter = 30;
% a = [0.65,0.28,0.07;0.15,0.67,0.18;0.12,0.36,0.52];
% a = [1,0,0;0,0.4,0.6;0,0.6,0.4];
a = rand(5);
a = a./sum(a,2);
[V,D] = eig(a');
if (V(1,1)<0)
    V(:,1) = -V(:,1);
end
det_his = zeros(1,max_iter);
lambda_his = D(2,2).^(1:max_iter);
for i=1:max_iter
    det_his(i) = det(a^i);
end
eps = 1e-5;
fprintf('行列式在%d次迭代时达到精度要求\n',find(det_his<=eps,1));
fprintf('lambda在%d次迭代时达到精度要求\n',find(lambda_his<=eps,1));