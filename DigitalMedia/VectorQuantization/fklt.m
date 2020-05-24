function [ data_2,label_2,center_2 ] = fklt( data,label,center,dim,num )
%FKLT 将data降维到dim维，并抽取其中num个数据
[~,n] = size(data);
[~,n_2] = size(center);
data_tmp = [data,center];
X = data_tmp-repmat(mean(data_tmp,2),1,n+n_2);
C = (X*X')/(n+n_2-1);
[U,~,~] = svd(C);
U_2 = U(:,1:dim);
Y = U_2'*X;
center_2 = Y(:,end-n_2+1:end);
data = Y(:,1:end-n_2);
tmp = randperm(n);
data_2 = data(:,tmp(1:num));
label_2 = label(tmp(1:num));
end

