N = 34;
edge = load('AdjMat.txt');
% 生成邻接矩阵，对角线要为1，一是因为直觉上自己与自己是相通的，二是因为否则Q_his(1)会小于0
adjmat = diag(ones(1,34));
for i = 1:length(edge)
    adjmat(edge(i,1),edge(i,2)) = 1;
    adjmat(edge(i,2),edge(i,1)) = 1;
end
path_nums = load('path_nums.mat');
% 加载数据之后取对数，因为数据太大了，树状图没法看
path_nums = log10(path_nums.path_nums+0.1);
% 聚类函数，获得聚类树、历史Q值、历史聚类结果
[cluster_tree,Q_his,cluster_his] = clustering(path_nums,adjmat);
% 画树状图
figure(1);
dendrogram(cluster_tree(N+1:end,:),0);
title('层次聚类树状图');
xlabel('节点');
ylabel('相似度度量（取对数）');
[~,idx] = max(Q_his);
% 在Q值最大的位置截断
cluster_tree_ans = cluster_tree(1:N+idx,:);
cluster_ans = cluster_his(idx,:)';
figure(2);
plot(Q_his);
title('Q值历史变化情况');
xlabel('iteration');
ylabel('Q');