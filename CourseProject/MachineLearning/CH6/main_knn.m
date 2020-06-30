clear
clc
load fisheriris;
meas = meas';
% �˴������Զ��㲥������Ҫrepmat
% ��һ��С������Ϊ�������ᵼ�½�����ָ���
fdist = @(X,Y)sqrt(sum(X.^2,1)' + sum(Y.^2,1) - 2*X'*Y + 1e-10);
dist = fdist(meas,meas);
% ���K���ڵ������
K = 5;
N = length(meas);
knn = zeros(length(meas),K);
for i = 0:K
    [~,min_dis_idx] = min(dist,[],2);
    for j = 1:N
        dist(j,min_dis_idx(j)) = inf;
    end
    if i == 0
        continue;
    end
    knn(:,i) = min_dis_idx;
end
% �ѽ��ڵ������ĳ�����
knn(min(knn>=1,knn<=50)) = 1;
knn(min(knn>=51,knn<=100)) = 2;
knn(min(knn>=101,knn<=150)) = 3;
% ������
pred = mode(knn,2);
% ������
label = [1*ones(N/3,1),2*ones(N/3,1),3*ones(N/3,1)];
% ���������
conf_mat = zeros(3,3);
for i = 1:N
    conf_mat( label(i),pred(i) ) = conf_mat( label(i),pred(i) )+1;
end