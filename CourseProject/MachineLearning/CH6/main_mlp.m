clear;
clc;
% data_train:size(0.7*N,4); label_train:size(0.7*N,3)
% data_train:size(0.3*N,4); label_train:size(0.3*N,3)
[data_train, label_train, data_test, label_test] = load_data([1,2,3]);
% MLP分类
% 参数分别为：data,label,epochs,patch_size,alpha
[w_1,v_1] = train_mlp(data_train,label_train(:,1),200,21,0.3);
[w_2,v_2] = train_mlp(data_train,label_train(:,2),200,21,0.3);
[w_3,v_3] = train_mlp(data_train,label_train(:,3),200,21,0.3);
forward = @(data,w,v)sigmoid(v'*[sigmoid(w'*data);-1*ones(1,length(data))]);
N_test = length(data_test);
score_1 = forward([data_test';-1*ones(1,N_test)],w_1,v_1);
score_2 = forward([data_test';-1*ones(1,N_test)],w_2,v_2);
score_3 = forward([data_test';-1*ones(1,N_test)],w_3,v_3);
% 求出测试集分类结果
%   对label=1的概率的评估分数
score_all = [score_1;score_2;score_3]';
%   最好是预测为正类，并且score很大。
%   极少数情况下3个SVM都认为是负类，则取score最大的一类
[~,pred_test_idx] = max(score_all,[],2);
%   以数字的形式给出分类编号，而不是以one-hot的形式
[~,label_test_idx] = max(label_test,[],2);
% 统计混淆矩阵
N = length(label_test_idx);
conf_mat = zeros(3,3);
for i = 1:N
    conf_mat( label_test_idx(i),pred_test_idx(i) ) = ...
            conf_mat( label_test_idx(i),pred_test_idx(i) )+1;
end
