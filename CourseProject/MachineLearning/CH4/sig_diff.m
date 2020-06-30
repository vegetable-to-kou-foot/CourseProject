function out = sig_diff(z)
%SIG_DIFF 是sigmoid的导函数
out = sigmoid(z).*(1-sigmoid(z));
end

