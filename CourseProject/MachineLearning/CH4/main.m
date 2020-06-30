data = [0,0,0;0,0,1;0,1,0;0,1,1;1,0,0;1,0,1;1,1,0;1,1,1]';
data = [data;-1*ones(1,8)];
label = [1 0 0 1 0 1 1 0];
% 随机初始化权重
w = 2*rand(4,3)-1;
v = 2*rand(4,1)-1;

epochs = 1000;
alpha = 10;
for i = 1:epochs
        % h:4*8; y:1*8
        [h,y] = forward(data,w,v);
        [w,v] = backward(data,label,h,y,w,v,alpha);
end
[~,y] = forward(data,w,v);
fprintf('预测结果：%s\n',num2str(y > 0.5));
fprintf('实际标签：%s\n',num2str(label));


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