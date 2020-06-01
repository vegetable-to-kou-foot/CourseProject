clear
clc

tic;
% 平面数量
K = 10;
% 测试多少组
C = 10;
% 计算量统计
cnt = 0;

data = load('ColorHistogram.asc')';
data = data(2:end,:);
[m,n] = size(data);

% 平面的法向量
ae = rand(m,K*C)*2-1;

% size(hash_tab) == (K*C,n);
hash_tab = ae'*data;
hash_tab(hash_tab<=0) = 0;
hash_tab(hash_tab>0) = 1;
hash_tab = logical(hash_tab);

% 用来加速二进制矩阵转10进制矩阵的，先转字符串再转十进制太慢了，直接用矩阵乘法
% 准备阶段耗时19s --> 4s
my_pow2 = pow2(K-1:-1:0)';
my_bin2dec = @(x)x*my_pow2;

% hash_cnt是(C,pow2(K))的cell数组
% 每个cell内部是一个(1,t)的数组，元素含义为在第C组中放进key桶的元素有哪些
hash_cnt = cell(C,pow2(K));
for i = 1:C
    keys = round(my_bin2dec(hash_tab(K*(i-1)+1:K*i,:)')+1);
    for j = 1:n
        hash_cnt{i,keys(j)} = [hash_cnt{i,keys(j)} ; j];
    end
end
toc;
t_pre = toc;
fprintf('准备阶段耗时\t%.5f\n',t_pre);


tic;

ans_lsh = zeros(10,1000);
query = data(:,1:1000);
hash_q = ae'*query;
hash_q(hash_q<=0) = 0;
hash_q(hash_q>0) = 1;
hash_q = logical(hash_q);

for i = 1:1000
    % 支持加强匹配，但是效率极低，暂无改进方法，建议注释掉。
    % 统计每个元素与hq在同一个桶中多少次
%     all_pts = [];
%     for j = 1:C
%         key = round(bin2dec(num2str(hash_q(K*(j-1)+1:K*j,:)'))+1);
%         all_pts = [all_pts , hash_cnt{j,key}];
%     end
    
%     uni_pts = unique(all_pts);
%     cnt_pts = hist(all_pts,uni_pts);
%     
%     for dr = 10:-1:1
%         idxs = find(cnt_pts >= dr);
%         if length(idxs) >= 10
%             break;
%         end
%     end

    idxs = [];
    for j = 1:C
        key = round(my_bin2dec(hash_q(K*(j-1)+1:K*j,i)')+1);
        idxs = union(idxs,hash_cnt{j,key});
    end
    
    match = data(:,idxs);
    dis = sqrt(sum((match-data(:,i)).^2,1));
    for j = 0:10
        [~,idx] = min(dis);
        dis(idx) = inf;
        if j == 0
            continue;
        end
        ans_lsh(j,i) = idxs(idx);
    end
    
    cnt = cnt + length(idxs);
end
toc;
t_1 = toc;
fprintf('LSH查前1000个点的10近邻耗时\t%.5f\n',t_1);


tic;
% 计算参考答案
ans_L2 = zeros(10,1000);
for i = 1:1000
    query = data(:,i);
    dis = sqrt(sum((data-query).^2,1));
    for j = 0:10
        [~,idx] = min(dis);
        dis(idx) = inf;
        if j == 0
            continue;
        end
        ans_L2(j,i) = idx;
    end
end
toc;
t_2 = toc;
fprintf('BF查前1000个点的10近邻耗时\t%.5f\n',t_2);

correct = zeros(1,1000);
for i = 1:1000
    correct(i) = length(intersect(ans_lsh(:,i),ans_L2(:,i)));
end
TP = mean(correct);
rec = TP/10;
acc = 1+2*(TP-10)/n;
fprintf('召回率为\t%.5f%%（此题中精确率 = 召回率）\n',rec*100);
fprintf('准确率为\t%.5f%%\n',acc*100);
fprintf('计算量对比\tLSH : BF = \t%d : %d\n',cnt,1000*n);
fprintf('计算量减少\t%.5f%%\n',100*(1-cnt/(1000*n)));
fprintf('运行时间对比\tLSH : BF = \t%ds : %ds\n',t_1,t_2);
fprintf('运行时间减少\t%.5f%%\n',100*(1-t_1/t_2));
