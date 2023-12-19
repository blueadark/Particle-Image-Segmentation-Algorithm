%% 用来训练图像来计算前景相关参数，
% Training1~training4图像分辨率高，清晰度高
% Training5~training7图像分辨率低，清晰度低
% Training5为d11图像，training6为d14图像，training7为d16图像
% 使用training1~training3,training5~trainging7

%序列1
%m=[77.1993;46.5755]
%c1=[0.0032,-0.0058;-0.0058,0.0228]

%序列2
%m=[93.0391;57.9434];
%c1=[0.0107,-0.0123;-0.0123,0.0284];
%序列1
%m=[147.36734;75.6487]
%c1=[0.0037,-0.0078;-0.0078,0.0189]

clc;clear all;close all;

k=0;
X=zeros(2,2);%X存放训练样本，每个样本为列向量
%读取第一幅图像
I=imread('training_fore_picture/序列1/training1.jpg');
I1=imread('training_fore_picture/序列1/training1_label.jpg');
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
I=imread('training_fore_picture/序列1/training2.jpg');
I1=imread('training_fore_picture/序列1/training2_label.jpg');
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
I=imread('training_fore_picture/序列1/training3.jpg');
I1=imread('training_fore_picture/序列1/training3_label.jpg');
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

% 读取第四幅图像
I=imread('training_fore_picture/序列1/training4.jpg');
I1=imread('training_fore_picture/序列1/training4_label.jpg');
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
% the end 读取第四幅图像

% %读取第五幅图像
I=imread('training_fore_picture/序列1/training5.jpg');
I1=imread('training_fore_picture/序列1/training5_label.jpg');
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
I=imread('training_fore_picture/序列1/training6.jpg');
I1=imread('training_fore_picture/序列1/training6_label.jpg');
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
I=imread('training_fore_picture/序列1/training7.jpg');
I1=imread('training_fore_picture/序列1/training7_label.jpg');
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

% %读取第八幅图像
% I=imread('training_fore_picture/序列1/training8.jpg');
% I1=imread('training_fore_picture/序列1/training8_label.jpg');
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
% %the end 读取第八幅图像
% 
% %读取第九幅图像
% I=imread('training_fore_picture/序列1/training9.jpg');
% I1=imread('training_fore_picture/序列1/training9_label.jpg');
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
% %the end 读取第九幅图像
% 
% %读取第十幅图像
% I=imread('training_fore_picture/序列1/training10.jpg');
% I1=imread('training_fore_picture/序列1/training10_label.jpg');
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

