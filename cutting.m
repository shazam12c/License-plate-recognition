%�������ڵ�������������
close all
clc

%��ȡһ����λ��ĳ���ͼ��
[filename,filepath]=uigetfile('.jpg','������һ����λ��ĳ���ͼ��');
%ƴ��filepath��filename�õ��������ļ���
file=strcat(filepath,filename);


%��ȡ����ͼ��
a=imread(file);
%��ʾԭʼ�ĳ���ͼ��
%figure(1),subplot(3,2,1),imshow(a);title('ԭʼ��λ��ĳ���ͼ��');


%����ɫͼ��ת��Ϊ�Ҷ�ͼ��
b=rgb2gray(a);
%չʾ���ƻҶ�ͼ��
%figure(1),imshow(b);title('���ƻҶ�ͼ��');


%���Ҷ�ͼ��ת��Ϊ��ֵͼ��
g_max=double(max(max(b)));
g_min=double(min(min(b)));
%T��ʾ��ֵ������ֵ
T=round(g_max-(g_max-g_min)/3);
%��I1�ĳߴ���Ϣ�洢��m��n�У�m��ʾ������n��ʾ����
[m,n]=size(b);
%�Ҷ�ͼ��Ķ�ֵ��
c=(double(b)>=T);
%��ʾ����ͼ��ľ�ֵ�˲�ǰ�Ķ�ֵͼ��
%figure(1),imshow(c);title('��ֵ�˲�ǰ�Ķ�ֵͼ��');

%�Զ�ֵͼ����о�ֵ�˲�
%�˲����ӣ�averageΪ���ӵ����ͣ�3Ϊ��Ӧ�Ĳ���
h=fspecial('average',3);
%���о�ֵ�˲�
d=im2bw(round(filter2(h,c)));
%��ʾ����ͼ��ľ�ֵ�˲���Ķ�ֵͼ��
%figure(1),imshow(d);title('��ֵ�˲���Ķ�ֵͼ��');


% ��ͼ��������ͻ�ʴ������λ����
se=eye(2); 
%��I3�ĳߴ���Ϣ�洢��m��n�У�m��ʾ������n��ʾ����
[m,n]=size(d);
%�����ֵͼ��������
if bwarea(d)/m/n>=0.365
    %��ʴͼ��
    I3=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    %����ͼ��
    I3=imdilate(d,se);
end
%չʾ���ͻ�ʴ���ͼ��
%figure(1),imshow(d);title('���ͻ�ʴ������ͼ��');

%�ַ��и�
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�
d=qiege(d);
%��I1�ĳߴ���Ϣ�洢��m��n�У�m��ʾ������n��ʾ����
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
        % �ָ�
        d(:,k1+num+5)=0;  
    end
end


% ���и�
d=qiege(d);
% �и�� 7 ���ַ�
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
    if wide<y1   % ��Ϊ��������
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


% �ָ���ڶ����ַ�
[word2,d]=getword(d);
% �ָ���������ַ�
[word3,d]=getword(d);
% �ָ�����ĸ��ַ�
[word4,d]=getword(d);
% �ָ��������ַ�
[word5,d]=getword(d);
% �ָ���������ַ�
[word6,d]=getword(d);
% �ָ�����߸��ַ�
[word7,d]=getword(d);



%subplot(5,7,1),imshow(word1),title('1');
%subplot(5,7,2),imshow(word2),title('2');
%subplot(5,7,3),imshow(word3),title('3');
%subplot(5,7,4),imshow(word4),title('4');
%subplot(5,7,5),imshow(word5),title('5');
%subplot(5,7,6),imshow(word6),title('6');
%subplot(5,7,7),imshow(word7),title('7');

%���г����ַ��Ĺ�һ������
% ��һ����СΪ 40*20
word1=imresize(word1,[40 20]);
word2=imresize(word2,[40 20]);
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);

file1=strcat(filepath,'�ַ�1.jpg');
imwrite(word1,file1);
file2=strcat(filepath,'�ַ�2.jpg');
imwrite(word2,file2);
file3=strcat(filepath,'�ַ�3.jpg');
imwrite(word3,file3);
file4=strcat(filepath,'�ַ�4.jpg');
imwrite(word4,file4);
file5=strcat(filepath,'�ַ�5.jpg');
imwrite(word5,file5);
file6=strcat(filepath,'�ַ�6.jpg');
imwrite(word6,file6);
file7=strcat(filepath,'�ַ�7.jpg');
imwrite(word7,file7);

subplot(5,7,15),imshow(word1),title('1');
subplot(5,7,16),imshow(word2),title('2');
subplot(5,7,17),imshow(word3),title('3');
subplot(5,7,18),imshow(word4),title('4');
subplot(5,7,19),imshow(word5),title('5');
subplot(5,7,20),imshow(word6),title('6');
subplot(5,7,21),imshow(word7),title('7');