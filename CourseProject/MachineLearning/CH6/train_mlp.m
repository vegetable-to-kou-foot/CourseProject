function [w,v] = train_mlp(data,label,epochs,patch_size,alpha)
%TRAIN_MLP 训练一个3-3-1网络，并返回权重
N = length(label);
data = [data';-1*ones(1,N)];
% 随机初始化权重
w = 2*rand(4,3)-1;
v = 2*rand(4,1)-1;

for i = 1:epochs
    for j = 1:floor(N/patch_size)
        data_tmp = data(:,(j-1)*patch_size+1:j*patch_size);
        label_tmp = label((j-1)*patch_size+1:j*patch_size);
        [h,y] = forward(data_tmp,w,v);
        [w,v] = backward(data_tmp,label_tmp,h,y,w,v,alpha);
    end
end
end


function [h,y] = forward(data,w,v)
[~,n] = size(data);
h = [sigmoid(w'*data);-1*ones(1,n)];
y = sigmoid(v'*h);
end

function [w,v] = backward(data,label,h,y,w,v,alpha)
n = length(label);
w_step = zeros(size(w));
v_step = zeros(size(v));
for i = 1:n
% sig_diff_v_h_v:4*1
sig_diff_v_h_v = sig_diff(v'*h(:,i))*v;
% sig_diff_w_x:3*1
sig_diff_w_x = sig_diff(w'*data(:,i));
w_step = w_step + 2*(y(i)-label(i))*data(:,i)*(sig_diff_v_h_v(1:3).*sig_diff_w_x)';

% sig_diff_v_h_h:4*1
sig_diff_v_h_h = sig_diff(v'*h(:,i))*h(:,i);
v_step = v_step + 2*(y(i)-label(i))*sig_diff_v_h_h;
end
w_step = w_step/n;
v_step = v_step/n;

w = w - alpha*w_step;
v = v - alpha*v_step;
end

