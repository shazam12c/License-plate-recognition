%�������ڵ�������������
close all
clc


%�Զ�������ʾ�����ͼ��
%����һ��.jpg��ͼƬ���ļ������ļ�·��
[filename,filepath]=uigetfile('.jpg','������һ����Ҫʶ��ĳ���ͼ��');
%ʹ��strcat���������ļ�·�����ļ������õ��������ļ���
file=strcat(filepath,filename);
%��ȡͼ��
I0=imread(file);
%����ԭʼͼ��
%figure(1),imshow(I0);title('ԭʼͼ��');




%��ԭʼ��ɫͼ��ת��Ϊ�Ҷ�ͼ��
I1=rgb2gray(I0);
%չʾ�Ҷ�ͼ��ͻҶ�ֱ��ͼ
%figure(2),subplot(1,2,1),imshow(I1);title('�Ҷ�ͼ��');
%figure(2),subplot(1,2,2),imhist(I1);title('�Ҷ�ֱ��ͼ');




%ʹ��Roberts��Ե�������������Ե��⣬����Ϊ0.08
I2=edge(I1,'roberts',0.08,'both');
%չʾRobert���ӱ�Ե�����ͼ��
%figure(3),imshow(I2);title('robert���ӱ�Ե���');




%ͼ��ʴ����չʾ��ʴ���ͼ��
%3x1�����ˢ��
se=[1;1;1];
%����ͼ��ʴ
I3=imerode(I2,se);
%չʾ��ʴ���ͼ��
%figure(4),imshow(I3);title('��ʴ���ͼ��');

%��ͼ�����ƽ������չʾƽ��������ͼ��
%����ṹԪ�أ��ó����ι���һ��se
se=strel('rectangle',[40,40]);
%��ͼ��ʵ�ֱ����㣬������Ҳ��ƽ��ͼ��������������뿪�����෴����һ���ں�խ��ȱ�ں�ϸ������ڣ�ȥ��С����������ϵķ�϶
I4=imclose(I3,se);
%չʾ��������ƽ��ͼ�������
%figure(5),imshow(I4);title('ƽ��������ͼ��');


%�Ӷ�����ͼ�����Ƴ���������2000���ص����ӵ����
I5=bwareaopen(I4,2000);
%չʾ��ͼ�����Ƴ�С������ͼ��
%figure(6),imshow(I5);title('�Ӷ������Ƴ�С������ͼ��');


%��ͼ��ĳߴ�洢��������
[y,x,z]=size(I5);
%��ͼ��洢��I6������
I6=double(I5);
%��ʼ����ɨ��

%����y*1��ȫ0����
Blue_y=zeros(y,1);

for i=1:y
    for j=1:x
        %���I6(i,j,1)����1��Ҳ����˵I6ͼ��������Ϊ(i,j)�ĵ�Ϊ��ɫ��
        %��Blue_y����Ӧ�е�Ԫ��Blue_y(i,j)��ֵ��1
        if(I6(i,j,1)==1)
            Blue_y(i,1)=Blue_y(i,1)+1;
        end
    end
end

%tempΪ����Blue_y��Ԫ���е����ֵ��MaxYΪ��ֵ������
[temp MaxY]=max(Blue_y);

%�ҵ�����ͼ�����߽�
PY1=MaxY;
while((Blue_y(PY1,1)>=120)&&(PY1>1))
    PY1=PY1-1;
end

%�ҵ�����ͼ����ұ߽�
PY2=MaxY;
while((Blue_y(PY2,1)>=40)&&(PY2<y))
    PY2=PY2+1;
end

%IYΪ����ͼ��I0�н�ȡ����������PY1��PY2֮��Ĳ���
IY=I0(PY1:PY2,:,:);

%���ˣ�����ɨ�����

%չʾ�з�����������
figure(7),imshow(IY);title('�з����������');

%��ʼ����ɨ��

%����1*x��ȫ0����
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

%���ˣ���������ɨ��

%�Գ��������У��
%PX1=PX1;
%PX2=PX2;

%��ԭʼ����ͼ���н�ȡ������ͼ��
I7=I0(PY1:PY2-8,PX1:PX2,:);


%figure(7),subplot(1,2,1),imshow(IY);title('�з�����������');
%figure(7),subplot(1,2,2),imshow(I7);title('��λ��ĳ���ͼ��');

file=strcat(filepath,'02��λ��ĳ���ͼ��.jpg');

imwrite(I7,file);

figure(7),imshow(I7);title('��λ��ĳ���ͼ��');