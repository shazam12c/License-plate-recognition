%清空命令窗口的所有输入和输出
close all
clc


%自动弹出提示框读入图像
%读入一个.jpg的图片的文件名和文件路径
[filename,filepath]=uigetfile('.jpg','请输入一个需要识别的车牌图像');
%使用strcat函数连接文件路径和文件名来得到完整的文件名
file=strcat(filepath,filename);
%读取图像
I0=imread(file);
%输入原始图像
%figure(1),imshow(I0);title('原始图像');




%将原始彩色图像转换为灰度图像
I1=rgb2gray(I0);
%展示灰度图像和灰度直方图
%figure(2),subplot(1,2,1),imshow(I1);title('灰度图像');
%figure(2),subplot(1,2,2),imhist(I1);title('灰度直方图');




%使用Roberts边缘检测算子来做边缘检测，方差为0.08
I2=edge(I1,'robert',0.08,'both');
%展示Robert算子边缘检测后的图像
%figure(3),imshow(I2);title('robert算子边缘检测');




%图像腐蚀，并展示腐蚀后的图像
%3x1矩阵的刷子
se=[1;1;1];
%进行图像腐蚀
I3=imerode(I2,se);
%展示腐蚀后的图像
%figure(4),imshow(I3);title('腐蚀后的图像');

%对图像进行平滑处理并展示平滑处理后的图像
%构造结构元素，用长方形构造一个se
se=strel('rectangle',[40,40]);
%对图像实现闭运算，闭运算也能平滑图像的轮廓，但是与开运算相反，它一般融合窄的缺口和细长的弯口，去掉小洞，填补轮廓上的缝隙
I4=imclose(I3,se);
%展示闭运算后的平滑图像的轮廓
%figure(5),imshow(I4);title('平滑处理后的图像');


%从二进制图像中移除所有少于2000像素的连接的组件
I5=bwareaopen(I4,2000);
%展示从图像中移除小对象后的图像
%figure(6),imshow(I5);title('从对象中移除小对象后的图像');


%将图像的尺寸存储到数组中
[y,x,z]=size(I5);
%将图像存储到I6矩阵中
I6=double(I5);
%开始横向扫描

%产生y*1的全0矩阵
Blue_y=zeros(y,1);

for i=1:y
    for j=1:x
        %如果I6(i,j,1)等于1，也就是说I6图像中坐标为(i,j)的点为蓝色，
        %则Blue_y的响应行的元素Blue_y(i,j)的值加1
        if(I6(i,j,1)==1)
            Blue_y(i,1)=Blue_y(i,1)+1;
        end
    end
end

%temp为向量Blue_y的元素中的最大值，MaxY为该值的索引
[temp MaxY]=max(Blue_y);

%找到车牌图像的左边界
PY1=MaxY;
while((Blue_y(PY1,1)>=120)&&(PY1>1))
    PY1=PY1-1;
end

%找到车牌图像的右边界
PY2=MaxY;
while((Blue_y(PY2,1)>=40)&&(PY2<y))
    PY2=PY2+1;
end

%IY为运势图像I0中截取的纵坐标在PY1和PY2之间的部分
IY=I0(PY1:PY2,:,:);

%至此，横向扫描结束

%展示行方向合理的区域
figure(7),imshow(IY);title('行方向合理区域');

%开始纵向扫描

%产生1*x的全0矩阵
Blue_x=zeros(1,x);

for j=1:x
    for i=PY1:PY2
        if(I6(i,j,1)==1)
            Blue_x(1,j)=Blue_x(1,j)+1;
        end
    end
end

PX1=1;
while((Blue_x(1,PX1)<3)&&(PX1<x))
    PX1=PX1+1;
end

PX2=x;
while((Blue_x(1,PX2)<3)&&(PX2>PX1))
    PX2=PX2-1;
end

%至此，结束纵向扫描

%对车牌区域的校正
%PX1=PX1;
%PX2=PX2;

%从原始车辆图像中截取出车牌图像
I7=I0(PY1:PY2-8,PX1:PX2,:);


%figure(7),subplot(1,2,1),imshow(IY);title('行方向合理的区域');
%figure(7),subplot(1,2,2),imshow(I7);title('定位后的车牌图像');

file=strcat(filepath,'02定位后的车牌图像.jpg');

imwrite(I7,file);

figure(7),imshow(I7);title('定位后的车牌图像');