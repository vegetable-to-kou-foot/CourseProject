function [ answer ] = J_fun( a )
[wx,~] = wrong_classified(a);
answer = 0;
m = size(wx,1);
for i=1:m
    answer = answer + abs(wx(i,:)*a');
end
end