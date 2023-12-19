%% 用来训练图像来计算背景相关参数

%沿用Train_1中的training1~training7
%training8为d5图像，training9为d6图像，training10为d23图像
%序列1
% m=[2.3856;2.4703]
% c1=[0.1071,-0.1358;-0.1358,0.2346]

%序列2
% m=[-4.1686;-2.2807]
% c1=[0.3256,-0.5670;-0.5670,1.3244]

clc;clear all;close all;

k=0;
X=zeros(2,1);%X存放训练样本，每个样本为列向量

%读取第一幅图像
I=imread('training_background_picture/序列1/training1.jpg');
I1=imread('training_background_picture/序列1/training1_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
I=imread('training_background_picture/序列1/training2.jpg');
I1=imread('training_background_picture/序列1/training2_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
I=imread('training_background_picture/序列1/training3.jpg');
I1=imread('training_background_picture/序列1/training3_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
I=imread('training_background_picture/序列1/training4.jpg');
I1=imread('training_background_picture/序列1/training4_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
I=imread('training_background_picture/序列1/training5.jpg');
I1=imread('training_background_picture/序列1/training5_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
I=imread('training_background_picture/序列1/training6.jpg');
I1=imread('training_background_picture/序列1/training6_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
I=imread('training_background_picture/序列1/training7.jpg');
I1=imread('training_background_picture/序列1/training7_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
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

%读取第八幅图像
I=imread('training_background_picture/序列1/training8.jpg');
I1=imread('training_background_picture/序列1/training8_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第八幅图像

%读取第九幅图像
I=imread('training_background_picture/序列1/training9.jpg');
I1=imread('training_background_picture/序列1/training9_label.jpg');
I=double(I);
I1=double(I1);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,1)-I(:,:,3);
lab(:,:,3)=I(:,:,2)-I(:,:,3);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j,1)>=250 && I1(i,j,2)<=2 && I1(i,j,3)<=2
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第九幅图像

% %读取第十幅图像
% I=imread('training_background_picture/序列1/training10.jpg');
% I1=imread('training_background_picture/序列1/training10_label.jpg');
% I=double(I);
% I1=double(I1);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,1)-I(:,:,3);
% lab(:,:,3)=I(:,:,2)-I(:,:,3);
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
p=zeros(size1(1),size1(2));
C1=inv(C);