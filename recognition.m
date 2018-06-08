%清空命令窗口的所有输入和输出
close all
clc

%读取一个定位后的车牌图像
[filename,filepath]=uigetfile('.jpg','请输入一个定位后的车牌图像');
%拼接filepath和filename得到完整的文件名
file=strcat(filepath,filename);
dw=imread(file);

liccode=char(['0':'9' 'A':'Z' '苏豫陕鲁']);  %建立自动识别字符代码表  
SubBw2=zeros(40,20);
l=1;
for I=1:7
      ii=int2str(I);
      prefix=strcat(filepath,'字符');
      ii=strcat(prefix,ii);
      ii=strcat(ii,'.jpg');
      t=imread(ii);
      SegBw2=imresize(t,[40 20],'nearest');
        if l==1                 %第一位汉字识别
            kmin=37;
            kmax=40;
        elseif l==2             %第二位 A~Z 字母识别
            kmin=11;
            kmax=36;
        else l>=3               %第三位以后是字母或数字识别
            kmin=1;
            kmax=36;
        
        end
        
        for k2=kmin:kmax
            fname=strcat('字符模板\',liccode(k2),'.jpg');
            SamBw2 = imread(fname);
            for  i=1:40
                for j=1:20
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                end
            end
           % 以上相当于两幅图相减得到第三幅图
            Dmax=0;
            for k1=1:40
                for l1=1:20
                    if  ( SubBw2(k1,l1) > 0 | SubBw2(k1,l1) <0 )
                        Dmax=Dmax+1;
                    end
                end
            end
            Error(k2)=Dmax;
        end
        Error1=Error(kmin:kmax);
        MinError=min(Error1);
        findc=find(Error1==MinError);
        Code(l*2-1)=liccode(findc(1)+kmin-1);
        Code(l*2)=' ';
        l=l+1;
end
figure(1),imshow(dw),title (['车牌号码:', Code],'Color','b');