N = 34;
edge = load('AdjMat.txt');
% �����ڽӾ��󣬶Խ���ҪΪ1��һ����Ϊֱ�����Լ����Լ�����ͨ�ģ�������Ϊ����Q_his(1)��С��0
adjmat = diag(ones(1,34));
for i = 1:length(edge)
    adjmat(edge(i,1),edge(i,2)) = 1;
    adjmat(edge(i,2),edge(i,1)) = 1;
end
path_nums = load('path_nums.mat');
% ��������֮��ȡ��������Ϊ����̫���ˣ���״ͼû����
path_nums = log10(path_nums.path_nums+0.1);
% ���ຯ������þ���������ʷQֵ����ʷ������
[cluster_tree,Q_his,cluster_his] = clustering(path_nums,adjmat);
% ����״ͼ
figure(1);
dendrogram(cluster_tree(N+1:end,:),0);
title('��ξ�����״ͼ');
xlabel('�ڵ�');
ylabel('���ƶȶ�����ȡ������');
[~,idx] = max(Q_his);
% ��Qֵ����λ�ýض�
cluster_tree_ans = cluster_tree(1:N+idx,:);
cluster_ans = cluster_his(idx,:)';
figure(2);
plot(Q_his);
title('Qֵ��ʷ�仯���');
xlabel('iteration');
ylabel('Q');