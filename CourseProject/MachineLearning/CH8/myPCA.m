function Y = myPCA(X,dim)
data = X;
[~,n] = size(data);
% 将数据都移至原点附近
X = data-repmat(mean(data,2),1,n);
% C是协方差矩阵
C = (X*X')/(n-1);
% SVD分解后取前dim维，即保留信息最多的dim维
% 即压缩至dim维
[U,S,V] = svd(C);
U_2 = U(:,1:dim);
% 做一个基向量的变换
Y = U_2'*X;
end

