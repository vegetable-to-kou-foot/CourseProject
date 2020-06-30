function [ wx,wy ] = wrong_classified( a )
global X y
[m,~] = size(X);
wx = [];wy = [];
for i=1:m
    if act(X(i,:)*a') ~= y(i)
        wx = [wx;X(i,:)];
        wy = [wy;y(i)];
    end
end
end

