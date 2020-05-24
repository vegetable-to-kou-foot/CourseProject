clear;
clc;
class_num = 32;
eps = 0.05;
data = load('ColorHistogram.asc')';
disp('数据读取完成');
data = data(2:end,:);
[m,n] = size(data);
center = mean(data,2);
dis = inf(class_num,n);
class_now = zeros(1,n);
time = 0;

while pow2(time) < class_num
    %码矢分裂
    center_tmp = zeros(m,size(center,2)*2);
    for i=1:size(center,2)
        c = center(:,i);
        center_tmp(:,2*i-1) = c*(1+eps);
        center_tmp(:,2*i) = c*(1-eps);
    end
    center = center_tmp;
    % 将数据点分类进码矢的邻域
    for i=1:size(center,2)
        c = center(:,i);
        dis(i,:) = sum((data-repmat(c,1,n)).^2);
    end
    [~,class_now] = min(dis);
    % 码矢完成移动
    for i=1:size(center,2)
        center(:,i) = mean(data(:,class_now==i),2);
    end
    time = time+1;
end

label = class_now;
disp('数据计算完成');

dim = 3;
num = 10000;
[data_2,label_2,center_2] = fklt(data,label,center,dim,num);
colors = 'mgrk';
signs = 'doxs^v*+';
figure(1);
for i=1:length(colors)
    for j=1:length(signs)
        id = (i-1)*8+j;
        mask = label_2==id;
        fprintf('%d:%d\n',id,sum(mask));
        x = data_2(1,mask);
        y = data_2(2,mask);
        z = data_2(3,mask);
        plot3(x,y,z,[colors(i),signs(j)],'MarkerSize',5,'LineWidth',1);
        hold on
        c = center_2(:,id);
        plot3(c(1),c(2),c(3),[colors(i),signs(j)],'MarkerSize',20,'LineWidth',5);
    end
end
grid on
disp('数据可视化完成');
