load fisheriris;
cls1_data=meas(1:50,1:2);
cls2_data=meas(51:100,1:2);
%����ͶӰǰ
plot(cls1_data(:,1),cls1_data(:,2),'.r');
hold on;
plot(cls2_data(:,1),cls2_data(:,2),'*b');
hold on;
W=FisherLDA(cls1_data,cls2_data);
%����ͶӰ��
new1=cls1_data*W;
new2=cls2_data*W;
k=W(2)/W(1);
plot([0,6],[0,6*k],'-k');
hold on;
 
%��������ͶӰ���ӿռ��
for i=1:4
    temp=cls1_data(i,:);
    newx=(temp(1)+k*temp(2))/(k*k+1);
    newy=k*newx;
    plot(newx,newy,'*r');
end
 
for i=1:3
    temp=cls2_data(i,:);
    newx=(temp(1)+k*temp(2))/(k*k+1);
    newy=k*newx;
    plot(newx,newy,'ob');
end

title('ԭʼ��������ͶӰ��������','FontSize',20);
xlabel('x_1','FontSize',15);
ylabel('x_2','FontSize',15);