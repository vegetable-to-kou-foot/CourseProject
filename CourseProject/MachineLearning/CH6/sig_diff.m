function out = sig_diff(z)
%SIG_DIFF ��sigmoid�ĵ�����
out = sigmoid(z).*(1-sigmoid(z));
end

