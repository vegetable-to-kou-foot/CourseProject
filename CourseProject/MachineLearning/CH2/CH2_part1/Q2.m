global X y
X = [0 0 1;0 1 1;1 0 1;1 1 1];
y = [0 1 1 1];
a = [1 1 -1.1];
alpha = 0.3;
theta = 1e-7*ones(1,3);
a_last = 0;
while 1
    eps = 0.1;
    a_last = a;
    a = a - alpha*(J_fun(a+eps*ones(1,3))-J_fun(a))/eps;
    if abs(a-a_last) < 1e-7
        break;
    end
end
figure(1);
%mask = (y == 0);
%plot(X(mask,1),X(mask,2),'go');
plot(0,0,'go');
hold on;
%plot(X(~mask,1),X(~mask,2),'ro');
plot(1,0,'ro');
hold on;
x = -1:0.1:2;
plot(0.5,-2:0.01:2,'b-');
hold off;
