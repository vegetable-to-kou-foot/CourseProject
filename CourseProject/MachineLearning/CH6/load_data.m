function [data_train, label_train, data_test, label_test] = load_data(D)
%LOAD_DATA ����iris����
%  D:��ʾ�����ļ�������
load fisheriris;
% �������� + ���� + 7:3����ѵ�����Ͳ��Լ�
N = 150;
% --��1��2��3�η���ʱʹ�õ�����
mask_all = randperm(N);
mask_train = mask_all(1:N*0.7);
mask_test = mask_all(N*0.7+1:N);
labels = zeros(N,3);
labels(1:N/3,1) = 1;
labels(N/3+1:2*N/3,2) = 1;
labels(2*N/3+1:N,3) = 1;
data_train = meas(mask_train,D);
label_train = labels(mask_train,:);
data_test = meas(mask_test,D);
label_test = labels(mask_test,:);
end

