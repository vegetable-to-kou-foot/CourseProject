max_iter = 20;
det_his = zeros(max_iter,1);
% a = [0.65,0.28,0.07;0.15,0.67,0.18;0.12,0.36,0.52];
% a = [1,0,0;0,0.4,0.6;0,0.6,0.4];
% a = rand(3);
% a = a./sum(a,2);
a = gen_rand();
[V,D] = eig(a');
if (V(1,1)<0)
    V(:,1) = -V(:,1);
end
figure(1);
a_i = eye(size(a));
for i=1:max_iter
    a_i = a_i*a;
    det_his(i) = abs(det(a_i));
    draw_mat_T(a_i,i,V);
end
figure(2);
plot(1:max_iter,det_his,'b-');
title('det(P^k)变化曲线','FontSize',20);
xlabel('k','FontSize',15);
ylabel('det(P^k)','FontSize',15);


function A = gen_rand()
% 目前仅支持3维
base = rand(3,2);
for i=1:3
    if base(i,1)<=1/2^0.5 && base(i,2)>base(i,1)*3^0.5
        base(i,1) = 1/2^0.5 - base(i,1);
        base(i,2) = 6^0.5/2 - base(i,2);
    elseif base(i,1)>1/2^0.5 && base(i,2)>6^0.5-base(i,1)*3^0.5
        base(i,1) = 3/2^0.5 - base(i,1);
        base(i,2) = 6^0.5/2 - base(i,2);
    end
end
A = zeros(3,3);
A(:,1) = 1-base(:,1)/2^0.5-base(:,2)/6^0.5;
A(:,2) = base(:,1)/2^0.5-base(:,2)/6^0.5;
A(:,3) = 2*base(:,2)/6^0.5;
end



function draw_mat_T(X,iter,V)
Z = [0,0,0];
A = X(1,:);
B = X(2,:);
C = X(3,:);
scale=1;
quiver3(Z(1),Z(2),Z(3),A(1)-Z(1),A(2)-Z(2),A(3)-Z(3),scale);
text(A(1),A(2),A(3),['A',num2str(iter)]);
axis([0,1,0,1,0,1]);
xlabel('x','FontSize',15);
ylabel('y','FontSize',15);
zlabel('z','FontSize',15);
title('矩阵P^k变化情况','FontSize',20);
grid on;
hold on;
quiver3(Z(1),Z(2),Z(3),B(1)-Z(1),B(2)-Z(2),B(3)-Z(3),scale);
text(B(1),B(2),B(3),['B',num2str(iter)]);
hold on;
quiver3(Z(1),Z(2),Z(3),C(1)-Z(1),C(2)-Z(2),C(3)-Z(3),scale);
text(C(1),C(2),C(3),['C',num2str(iter)]);
hold on;
quiver3(Z(1),Z(2),Z(3),V(1)-Z(1),V(2)-Z(2),V(3)-Z(3),1/sum(V(:,1).^2));
text(V(1),V(2),V(3),'特征向量');
end