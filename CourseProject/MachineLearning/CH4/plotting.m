% 需要先执行main.m，获得w和v作为权重
data = [0,0,0;0,0,1;0,1,0;0,1,1;1,0,0;1,0,1;1,1,0;1,1,1]';
label = [1 0 0 1 0 1 1 0];

x = -1:0.05:2;
y = -1:0.05:2;
z = -1:0.05:2;
[X,Y,Z] = meshgrid(x,y,z);

f = forward(X,Y,Z,w,v);
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
mask = label == 1;
scatter3(data(1,mask),data(2,mask),data(3,mask),'ro');
mask = label == 0;
scatter3(data(1,mask),data(2,mask),data(3,mask),'go');
xlabel('x'); ylabel('y'); zlabel('z');



function f = forward(X,Y,Z,w,v)
[s1,s2,s3] = size(X);
n = s1*s2*s3;
data = [X(:),Y(:),Z(:),-1*ones(n,1)]';
h = [sigmoid(w'*data);-1*ones(1,n)];
y = sigmoid(v'*h);
f = reshape(y',s1,s2,s3);
end
