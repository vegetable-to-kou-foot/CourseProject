clear;
clc;
dim = 3;
%data = load('toy_sample.txt')';
%data = load('toy_sample_2.txt')';
data = load('ColorHistogram.asc')';
data = data(2:end,:);
[m,n] = size(data);
X = data-repmat(mean(data,2),1,n);
C = (X*X')/(n-1);
[U,S,V] = svd(C);
U_2 = U(:,1:dim);
S_2 = S(1:dim,1:dim);
V_2 = V(:,1:dim);
Y = U_2'*X;

%D是对角阵，且符合D=PCP'，证明结果正确，P是所求的变换
D = (Y*Y')/(n-1);
D_test = U_2'*C*U_2;
