% 需要先执行main_svm_c62.m，获得svm_1
data = data_train;
label = label_train;

x = 3:0.1:9;
y = 1:0.1:6;
z = 0:0.1:8;
[X,Y] = meshgrid(x,y);

f = forward(X,Y,Z,svm_1,svm_2,svm_3);
h = patch(isosurface(X, Y, Z, f, 0));
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



function f = forward(X,Y,Z,svm_1,svm_2,svm_3)
[s1,s2,s3] = size(X);
n = s1*s2*s3;
data_test = [X(:),Y(:),Z(:)];
[~,score_1] = predict(svm_1, data_test);
[~,score_2] = predict(svm_2, data_test);
[~,score_3] = predict(svm_3, data_test);
score_all = [score_1(:,2),score_2(:,2),score_3(:,2)];
pred_test = max(score_all,[],2);
f = reshape(pred_test,s1,s2,s3);
end
