function Y = myPCA(X,dim)
data = X;
[~,n] = size(data);
% �����ݶ�����ԭ�㸽��
X = data-repmat(mean(data,2),1,n);
% C��Э�������
C = (X*X')/(n-1);
% SVD�ֽ��ȡǰdimά����������Ϣ����dimά
% ��ѹ����dimά
[U,S,V] = svd(C);
U_2 = U(:,1:dim);
% ��һ���������ı任
Y = U_2'*X;
end

