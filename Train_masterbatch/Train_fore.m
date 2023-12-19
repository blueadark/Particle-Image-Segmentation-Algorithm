%% 建立前景高斯模型，计算前景相关参数
close all;
clear all;
clc;
% 前景相关参数
%% 参数如下
% m1=[143.9074;122.4328]; %均值
% C1=[0.0330,-0.0332;-0.0332,0.0371]; %逆协方差矩阵
%% code
clc;clear all;close all;

k=0;
X=zeros(2,1);%X存放训练样本，每个样本为列向量

%读取第一幅图像
I=imread('training_fore_picture/tr1.jpg');
I1=imread('training_fore_picture/tr1_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第一幅图像

%读取第二幅图像
I=imread('training_fore_picture/tr2.jpg');
I1=imread('training_fore_picture/tr2_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第二幅图像

%读取第三幅图像
I=imread('training_fore_picture/tr3.jpg');
I1=imread('training_fore_picture/tr3_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第三幅图像

%读取第四幅图像
I=imread('training_fore_picture/tr4.jpg');
I1=imread('training_fore_picture/tr4_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第四幅图像

%读取第五幅图像
I=imread('training_fore_picture/tr5.jpg');
I1=imread('training_fore_picture/tr5_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第五幅图像

%读取第六幅图像
I=imread('training_fore_picture/tr6.jpg');
I1=imread('training_fore_picture/tr6_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第六幅图像

%读取第七幅图像
I=imread('training_fore_picture/tr7.jpg');
I1=imread('training_fore_picture/tr7_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,2);
lab(:,:,3)=I(:,:,1)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第七幅图像
% 
% %读取第八幅图像
% I=imread('training_fore_picture/tr8.jpg');
% I1=imread('training_fore_picture/tr8_label.jpg');
% I=double(I);
% I1=double(I1);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,1)-I(:,:,2);
% lab(:,:,3)=I(:,:,1)-I(:,:,3);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第八幅图像
% 
% %读取第九幅图像
% I=imread('training_fore_picture/tr9.jpg');
% I1=imread('training_fore_picture/tr9_label.jpg');
% I=double(I);
% I1=double(I1);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,1)-I(:,:,2);
% lab(:,:,3)=I(:,:,1)-I(:,:,3);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第九幅图像
% 
% %读取第十幅图像
% I=imread('training_fore_picture/tr10.jpg');
% I1=imread('training_fore_picture/tr10_label.jpg');
% I=double(I);
% I1=double(I1);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,1)-I(:,:,2);
% lab(:,:,3)=I(:,:,1)-I(:,:,3);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第十幅图像

m=zeros(2,1);%定义平均向量
m(1)=mean(X(1,:));
m(2)=mean(X(2,:));
X(1,:)=X(1,:)-m(1);
X(2,:)=X(2,:)-m(2);%将样本向量减去均值向量
C=(X*X')/k;%得到协方差矩阵
C1=inv(C);