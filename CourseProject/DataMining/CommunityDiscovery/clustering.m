function [cluster_tree,Q_his,cluster_his] = clustering(corr,adjmat)
%CLUSTERING 根据相似度矩阵返回层次聚类结果
% corr:N*N,相关性矩阵
% adjmat:N*N,邻接矩阵
N = length(corr);
% 聚类树
cluster_tree = zeros(N,3);
% 记录当前还有哪些簇
now_nodes = 1:N;
% 每个点的类标号（仅用于比较两点是否属于同一类）
cluster_ans = 1:N;
% 每次循环时根据聚类树将最新的节点链接的所有叶子节点的cluster_ans都标记成这个值
cluster_now = N+1;
% 记录历史
cluster_his = zeros(N-1,N);
Q_his = zeros(N-1,1);
for level = 1:N-1
    min_corr = inf;
    M = length(now_nodes);
    % 簇之间两两求距离
    for i = 1:M-1
        for j = i+1:M
            now_corr = get_corr(corr,cluster_tree,now_nodes(i),now_nodes(j));
            if min_corr > now_corr
                min_corr = now_corr;
                x = i;
                y = j;
            end
        end
    end
    % 更新上面提到的变量，根据功能描述，下面的代码很容易理解
    cluster_tree(end+1,:) = [now_nodes(x),now_nodes(y),min_corr];
    % 删除被聚类的节点，加入新节点
    new_node = length(cluster_tree);
    now_nodes([x,y]) = [];
    now_nodes(end+1) = new_node;
    % 将最新的节点的所有叶子节点都标记成这个新的类标号
    cluster_ans = get_cluster_ans(cluster_ans,cluster_now,cluster_tree,N,new_node);
    cluster_his(level,:) = cluster_ans;
    Q_his(level) = get_Q(cluster_ans,adjmat);
    % 每次循环类标号都+1，以做区分
    cluster_now = cluster_now+1;
end
end


function now_corr = get_corr(corr,cluster_tree,x,y)
N = length(corr);
if x <= N && y <= N
    now_corr = corr(x,y);
    return;
end
if x > y
    k=x;x=y;y=k;
end
if x <= N && y > N
    now_corr = max([get_corr(corr,cluster_tree,x,cluster_tree(y,1)),...
        get_corr(corr,cluster_tree,x,cluster_tree(y,2))]);
    return;
end
if x > N && y > N
    now_corr = max([get_corr(corr,cluster_tree,cluster_tree(x,1),cluster_tree(y,1)),...
        get_corr(corr,cluster_tree,cluster_tree(x,1),cluster_tree(y,2)),...
        get_corr(corr,cluster_tree,cluster_tree(x,2),cluster_tree(y,1)),...
        get_corr(corr,cluster_tree,cluster_tree(x,2),cluster_tree(y,2))]...
    );
    return;
end
end


function cluster_ans = get_cluster_ans(cluster_ans,cluster_now,cluster_tree,N,now_node)
x = cluster_tree(now_node,1);
y = cluster_tree(now_node,2);
if x <= N
    cluster_ans(x) = cluster_now;
else
    cluster_ans = get_cluster_ans(cluster_ans,cluster_now,cluster_tree,N,x);
end
if y <= N
    cluster_ans(y) = cluster_now;
else
    cluster_ans = get_cluster_ans(cluster_ans,cluster_now,cluster_tree,N,y);
end
end


function Q = get_Q(cluster_ans,adjmat)
N = length(cluster_ans);
m = sum(sum(adjmat));
k = sum(adjmat);
Q = 0;
for i = 1:N
    for j = 1:N
        if cluster_ans(i) == cluster_ans(j)
            Q = Q + adjmat(i,j) - k(i)*k(j)/(2*m);
        end
    end
end
Q = Q/(2*m);
end