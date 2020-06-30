function [ theta_his,loss_his ] = logistic_regression( data,gen_max )
%LOGISTIC_REGRESSION 针对给定的数据进行逻辑回归，学习出参数
%  data:每一列是一个记录，最后一行是label
records = data(1:end-1,:);
labels = data(end,:);
[n,m] = size(records);
eps = 0.0001;
alpha = 3;
loss_last = inf;
loss_now = 0;
loss_his = [];
theta_his = [];
theta = rand(n+1,1)*2-1;
for gen = 1:gen_max
    out = forward(theta,[ones(1,m);records]);
    loss_now = loss(labels,out);
    if abs(loss_now-loss_last) <= eps
        break;
    end
    theta = step(theta,[ones(1,m);records],labels,out,alpha);
    loss_last = loss_now;
    loss_his = [loss_his,loss_last];
    theta_his = [theta_his,theta];
end
return;

end

function out = forward( theta,records )
out = 1./(1+exp(-sum(repmat(theta,1,size(records,2)).*records)));
end

function loss_now = loss(labels,out)
loss_now = mean(-labels.*log(out)-(1-labels).*log(1-out));
end

function theta = step(theta,records,labels,out,alpha)
theta = theta - alpha*mean(repmat(out-labels,size(records,1),1).*records,2);
end