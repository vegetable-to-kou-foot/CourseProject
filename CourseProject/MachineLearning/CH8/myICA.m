function S = myICA(X)
% ICA calculation
if ~ismatrix(X)
    error('Error!');
end
[n,m] = size(X);
S = zeros(n,m);
W_old = rand(n);
for row = 1:n
    W_old(row,:) = W_old(row,:)/sum(W_old(row,:));
end
delta = 0.001;
itera = 1000;
alfa = 0.01;
for T = 1:m
    for i = 1:itera
        weight = zeros(n,1);
        for line = 1:n
            weight(line) = 1-2*sigmoid(W_old(line,:)*X(:,T));
        end
        W_new = W_old+alfa*( (weight(line)*(X(:,T))')+ inv(W_old') );
        if sum(sum(abs(W_new-W_old))) <= delta
            break;
        else
            W_old = W_new;
        end
    end
    S(:,T) = W_new*X(:,T);
end
end

% sigmoid function
function g = sigmoid(x)
    g = 1/(1+exp(-x));
end