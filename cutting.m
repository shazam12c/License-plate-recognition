%清空命令窗口的所有输入和输出
close all
clc

%读取一个定位后的车牌图像
[filename,filepath]=uigetfile('.jpg','请输入一个定位后的车牌图像');
%拼接filepath和filename得到完整的文件名
file=strcat(filepath,filename);


%读取车牌图像
a=imread(file);
%显示原始的车牌图像
%figure(1),subplot(3,2,1),imshow(a);title('原始定位后的车牌图像');


%将彩色图像转换为灰度图像
b=rgb2gray(a);
%展示车牌灰度图像
%figure(1),imshow(b);title('车牌灰度图像');


%将灰度图像转换为二值图像
g_max=double(max(max(b)));
g_min=double(min(min(b)));
%T表示二值化的阈值
T=round(g_max-(g_max-g_min)/3);
%将I1的尺寸信息存储到m和n中，m表示行数，n表示列数
[m.n]=size(b);
%灰度图像的二值化
c=(double(b)>=T);
%显示车牌图像的均值滤波前的二值图像
%figure(1),imshow(c);title('均值滤波前的二值图像');

%对二值图像进行均值滤波
%滤波算子，average为算子的类型，3为对应的参数
h=fspecial('average',3);
%进行均值滤波
d=im2bw(round(filter2(h,c)));
%显示车牌图像的均值滤波后的二值图像
%figure(1),imshow(d);title('均值滤波后的二值图像');


% 对图像进行膨胀或腐蚀操作单位矩阵
se=eye(2); 
%将I3的尺寸信息存储到m和n中，m表示行数，n表示列数
[m,n]=size(d);
%计算二值图像的总面积
if bwarea(d)/m/n>=0.365
    %腐蚀图像
    I3=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    %膨胀图像
    I3=imdilate(d,se);
end
%展示膨胀或腐蚀后的图像
%figure(1),imshow(d);title('膨胀或腐蚀处理后的图像');

%字符切割
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割
d=qiege(d);
%将I1的尺寸信息存储到m和n中，m表示行数，n表示列数
[m,n]=size(d);
%figure(2),subplot(2,1,1),imshow(d),title(n)
k1=1;
k2=1;
s=sum(d);
j=1;
while j~=n
    while s(j)==0
        j=j+1;
    end
    k1=j;
    while s(j)~=0 && j<=n-1
        j=j+1;
    end
    k2=j-1;
    if k2-k1>=round(n/6.5)
        [val,num]=min(sum(d(:,[k1+5:k2-5])));
        % 分割
        d(:,k1+num+5)=0;  
    end
end


% 再切割
d=qiege(d);
% 切割出 7 个字符
y1=10;
y2=0.25;
flag=0;
word1=[];
while flag==0
    [m,n]=size(d);
    left=1;
    wide=0;
    while sum(d(:,wide+1))~=0
        wide=wide+1;
    end
    if wide<y1   % 认为是左侧干扰
        d(:,1:wide)=0;
        d=qiege(d);
    else
        temp=qiege(imcrop(d,[1 1 wide m]));
        [m,n]=size(temp);
        all=sum(sum(temp));
        two_thirds=sum(sum(temp(round(m/3):2*round(m/3),:)));
        if two_thirds/all>y2
            flag=1;word1=temp;   % WORD 1
        end
        d(:,1:wide)=0;
        d=qiege(d);
    end
end


% 分割出第二个字符
[word2,d]=getword(d);
% 分割出第三个字符
[word3,d]=getword(d);
% 分割出第四个字符
[word4,d]=getword(d);
% 分割出第五个字符
[word5,d]=getword(d);
% 分割出第六个字符
[word6,d]=getword(d);
% 分割出第七个字符
[word7,d]=getword(d);



%subplot(5,7,1),imshow(word1),title('1');
%subplot(5,7,2),imshow(word2),title('2');
%subplot(5,7,3),imshow(word3),title('3');
%subplot(5,7,4),imshow(word4),title('4');
%subplot(5,7,5),imshow(word5),title('5');
%subplot(5,7,6),imshow(word6),title('6');
%subplot(5,7,7),imshow(word7),title('7');

%进行车牌字符的归一化处理
% 归一化大小为 40*20
word1=imresize(word1,[40 20]);
word2=imresize(word2,[40 20]);
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);

file1=strcat(filepath,'字符1.jpg');
imwrite(word1,file1);
file2=strcat(filepath,'字符2.jpg');
imwrite(word2,file2);
file3=strcat(filepath,'字符3.jpg');
imwrite(word3,file3);
file4=strcat(filepath,'字符4.jpg');
imwrite(word4,file4);
file5=strcat(filepath,'字符5.jpg');
imwrite(word5,file5);
file6=strcat(filepath,'字符6.jpg');
imwrite(word6,file6);
file7=strcat(filepath,'字符7.jpg');
imwrite(word7,file7);

subplot(5,7,15),imshow(word1),title('1');
subplot(5,7,16),imshow(word2),title('2');
subplot(5,7,17),imshow(word3),title('3');
subplot(5,7,18),imshow(word4),title('4');
subplot(5,7,19),imshow(word5),title('5');
subplot(5,7,20),imshow(word6),title('6');
subplot(5,7,21),imshow(word7),title('7');