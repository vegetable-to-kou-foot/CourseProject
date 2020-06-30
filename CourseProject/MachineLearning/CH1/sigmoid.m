function y = sigmoid(X,theta)
y = 1./(1+exp(-X'*theta));
end