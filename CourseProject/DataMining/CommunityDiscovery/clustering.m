function [cluster_tree,Q_his,cluster_his] = clustering(corr,adjmat)
%CLUSTERING �������ƶȾ��󷵻ز�ξ�����
% corr:N*N,����Ծ���
% adjmat:N*N,�ڽӾ���
N = length(corr);
% ������
cluster_tree = zeros(N,3);
% ��¼��ǰ������Щ��
now_nodes = 1:N;
% ÿ��������ţ������ڱȽ������Ƿ�����ͬһ�ࣩ
cluster_ans = 1:N;
% ÿ��ѭ��ʱ���ݾ����������µĽڵ����ӵ�����Ҷ�ӽڵ��cluster_ans����ǳ����ֵ
cluster_now = N+1;
% ��¼��ʷ
cluster_his = zeros(N-1,N);
Q_his = zeros(N-1,1);
for level = 1:N-1
    min_corr = inf;
    M = length(now_nodes);
    % ��֮�����������
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
    % ���������ᵽ�ı��������ݹ�������������Ĵ�����������
    cluster_tree(end+1,:) = [now_nodes(x),now_nodes(y),min_corr];
    % ɾ��������Ľڵ㣬�����½ڵ�
    new_node = length(cluster_tree);
    now_nodes([x,y]) = [];
    now_nodes(end+1) = new_node;
    % �����µĽڵ������Ҷ�ӽڵ㶼��ǳ�����µ�����
    cluster_ans = get_cluster_ans(cluster_ans,cluster_now,cluster_tree,N,new_node);
    cluster_his(level,:) = cluster_ans;
    Q_his(level) = get_Q(cluster_ans,adjmat);
    % ÿ��ѭ�����Ŷ�+1����������
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