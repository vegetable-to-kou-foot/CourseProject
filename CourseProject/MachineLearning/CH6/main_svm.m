clear;
clc;
% data_train:size(0.7*N,4); label_train:size(0.7*N,3)
% data_train:size(0.3*N,4); label_train:size(0.3*N,3)
[data_train, label_train, data_test, label_test] = load_data([1,2,3]);
% SVM����
svm_1 = fitcsvm(data_train,label_train(:,1),'ClassNames',{'0','1'},'KernelFunction','rbf');
svm_2 = fitcsvm(data_train,label_train(:,2),'ClassNames',{'0','1'},'KernelFunction','rbf');
svm_3 = fitcsvm(data_train,label_train(:,3),'ClassNames',{'0','1'},'KernelFunction','rbf');
[~,score_1] = predict(svm_1, data_test);
[~,score_2] = predict(svm_2, data_test);
[~,score_3] = predict(svm_3, data_test);
% ������Լ�������
%   ��label=1�ĸ��ʵ���������
score_all = [score_1(:,2),score_2(:,2),score_3(:,2)];
%   �����Ԥ��Ϊ���࣬����score�ܴ�
%   �����������3��SVM����Ϊ�Ǹ��࣬��ȡscore����һ��
[~,pred_test_idx] = max(score_all,[],2);
%   �����ֵ���ʽ���������ţ���������one-hot����ʽ
[~,label_test_idx] = max(label_test,[],2);
% ͳ�ƻ�������
N = length(label_test_idx);
conf_mat = zeros(3,3);
for i = 1:N
    conf_mat( label_test_idx(i),pred_test_idx(i) ) = ...
            conf_mat( label_test_idx(i),pred_test_idx(i) )+1;
end
