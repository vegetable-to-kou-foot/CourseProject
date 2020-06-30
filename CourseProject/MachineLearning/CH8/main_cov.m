mu1 = [0 0];
sigma1 = [1 1 ; 1 4];
% sigma1 = [1 2 ; 2 4];
r1 = mvnrnd(mu1,sigma1,1000);
scatter(r1(:,1),r1(:,2),'r+');
title('二维高斯分布','FontSize',20);
xlabel('x','FontSize',15);
ylabel('y','FontSize',15);