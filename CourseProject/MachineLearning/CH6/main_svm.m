clear;
clc;
% data_train:size(0.7*N,4); label_train:size(0.7*N,3)
% data_train:size(0.3*N,4); label_train:size(0.3*N,3)
[data_train, label_train, data_test, label_test] = load_data([1,2,3]);
% SVM分类
svm_1 = fitcsvm(data_train,label_train(:,1),'ClassNames',{'0','1'},'KernelFunction','rbf');
svm_2 = fitcsvm(data_train,label_train(:,2),'ClassNames',{'0','1'},'KernelFunction','rbf');
svm_3 = fitcsvm(data_train,label_train(:,3),'ClassNames',{'0','1'},'KernelFunction','rbf');
[~,score_1] = predict(svm_1, data_test);
[~,score_2] = predict(svm_2, data_test);
[~,score_3] = predict(svm_3, data_test);
% 求出测试集分类结果
%   对label=1的概率的评估分数
score_all = [score_1(:,2),score_2(:,2),score_3(:,2)];
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
