clear;
clc;
% data_train:size(0.7*N,4); label_train:size(0.7*N,3)
% data_train:size(0.3*N,4); label_train:size(0.3*N,3)
[data_train, label_train, data_test, label_test] = load_data([1,2,3]);
% MLP����
% �����ֱ�Ϊ��data,label,epochs,patch_size,alpha
[w_1,v_1] = train_mlp(data_train,label_train(:,1),200,21,0.3);
[w_2,v_2] = train_mlp(data_train,label_train(:,2),200,21,0.3);
[w_3,v_3] = train_mlp(data_train,label_train(:,3),200,21,0.3);
forward = @(data,w,v)sigmoid(v'*[sigmoid(w'*data);-1*ones(1,length(data))]);
N_test = length(data_test);
score_1 = forward([data_test';-1*ones(1,N_test)],w_1,v_1);
score_2 = forward([data_test';-1*ones(1,N_test)],w_2,v_2);
score_3 = forward([data_test';-1*ones(1,N_test)],w_3,v_3);
% ������Լ�������
%   ��label=1�ĸ��ʵ���������
score_all = [score_1;score_2;score_3]';
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
