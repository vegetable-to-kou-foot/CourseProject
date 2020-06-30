function J = loss(X,y,theta)
h = sigmoid(X,theta);
J = -mean(y.*log(h)+(1-y).*log(1-h));
end