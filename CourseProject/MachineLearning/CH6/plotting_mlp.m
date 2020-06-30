% 需要先执行main_mlp.m，获得w_1,v_1~w_3,v_3
data = [data_train;data_test];
label = [label_train;label_test];
[~,label_idx] = max(label,[],2);

% x = 3:0.1:9;
% y = 1:0.1:6;
% z = 0:0.1:8;
x = -5:0.1:15;
y = -5:0.1:15;
z = -5:0.1:15;
[X,Y,Z] = meshgrid(x,y,z);

f = predicting(X,Y,Z,w_1,v_1,w_2,v_2,w_3,v_3);
h = patch(isosurface(X, Y, Z, f, 0.5));
isonormals(X, Y, Z, f, h);

% 设置图像属性
h.FaceColor = 'blue';
h.EdgeColor = 'none';
alpha(1);
view([1, 1, 1]);
axis equal;
axis on;
grid on;
camlight('right');
lighting gouraud;
hold on;
mask = label_idx == 1;
scatter3(data(mask,1),data(mask,2),data(mask,3),'ro');
mask = label_idx == 2;
scatter3(data(mask,1),data(mask,2),data(mask,3),'go');
mask = label_idx == 3;
scatter3(data(mask,1),data(mask,2),data(mask,3),'mo');
xlabel('x'); ylabel('y'); zlabel('z');



function f = predicting(X,Y,Z,w_1,v_1,w_2,v_2,w_3,v_3)
[s1,s2,s3] = size(X);
data_test = [X(:),Y(:),Z(:)];
forward = @(data,w,v)sigmoid(v'*[sigmoid(w'*data);-1*ones(1,length(data))]);
N_test = length(data_test);
score_1 = forward([data_test';-1*ones(1,N_test)],w_1,v_1);
score_2 = forward([data_test';-1*ones(1,N_test)],w_2,v_2);
score_3 = forward([data_test';-1*ones(1,N_test)],w_3,v_3);
score_all = [score_1;score_2;score_3]';
pred_test = max(score_all,[],2);
f = reshape(pred_test,s1,s2,s3);
end
