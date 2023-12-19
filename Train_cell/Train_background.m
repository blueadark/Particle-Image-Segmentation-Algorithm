%% 建立背景高斯模型，计算背景相关参数
%使用数据集自带的训练集中的人工标记
% 背景相关参数
%% 参数如下
%m=[1.4197;5.3108]; %均值
%C1=[0.3038,-0.0863;-0.0863,0.0332]; %逆协方差矩阵
%%
m2=[5.3108;3.8921];
C2=[0.1644,-0.2175;-0.2175,0.3038];
%% 1，2，4，5，9
m2=[5.8803;4.1583];
C2=[0.1740,-0.2344;-0.2344,0.3298];
%% code
clc;clear all;close all;
image_path='training_fore_picture_2\';


k=0;
X=zeros(2,1);%X存放训练样本，每个样本为列向量

%读取第一幅图像
image=strcat(image_path,'tr1.jpg');
I=imread(image);
I_ann=strcat(image_path,'tr_ann1');
I1=readmatrix(I_ann);
I=double(I);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,3)-I(:,:,1);
lab(:,:,3)=I(:,:,3)-I(:,:,2);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j)==0
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第一幅图像

%读取第二幅图像
image=strcat(image_path,'tr2.jpg');
I=imread(image);
I_ann=strcat(image_path,'tr_ann2');
I1=readmatrix(I_ann);
I=double(I);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,3)-I(:,:,1);
lab(:,:,3)=I(:,:,3)-I(:,:,2);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j)==0
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第二幅图像
% 
% %读取第三幅图像
% image=strcat(image_path,'tr3.jpg');
% I=imread(image);
% I_ann=strcat(image_path,'tr_ann3');
% I1=readmatrix(I_ann);
% I=double(I);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,3)-I(:,:,1);
% lab(:,:,3)=I(:,:,3)-I(:,:,2);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j)==0
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第三幅图像

%读取第四幅图像
image=strcat(image_path,'tr4.jpg');
I=imread(image);
I_ann=strcat(image_path,'tr_ann4');
I1=readmatrix(I_ann);
I=double(I);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,3)-I(:,:,1);
lab(:,:,3)=I(:,:,3)-I(:,:,2);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j)==0
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第四幅图像

%读取第五幅图像
image=strcat(image_path,'tr5.jpg');
I=imread(image);
I_ann=strcat(image_path,'tr_ann5');
I1=readmatrix(I_ann);
I=double(I);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,3)-I(:,:,1);
lab(:,:,3)=I(:,:,3)-I(:,:,2);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j)==0
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第五幅图像
% 
% %读取第六幅图像
% image=strcat(image_path,'tr6.jpg');
% I=imread(image);
% I_ann=strcat(image_path,'tr_ann6');
% I1=readmatrix(I_ann);
% I=double(I);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,3)-I(:,:,1);
% lab(:,:,3)=I(:,:,3)-I(:,:,2);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j)==0
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第六幅图像
% 
% %读取第七幅图像
% image=strcat(image_path,'tr7.jpg');
% I=imread(image);
% I_ann=strcat(image_path,'tr_ann7');
% I1=readmatrix(I_ann);
% I=double(I);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,3)-I(:,:,1);
% lab(:,:,3)=I(:,:,3)-I(:,:,2);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j)==0
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第七幅图像
% 
% %读取第八幅图像
% image=strcat(image_path,'tr8.jpg');
% I=imread(image);
% I_ann=strcat(image_path,'tr_ann8');
% I1=readmatrix(I_ann);
% I=double(I);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,3)-I(:,:,1);
% lab(:,:,3)=I(:,:,3)-I(:,:,2);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j)==0
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% %the end 读取第八幅图像

%读取第九幅图像
image=strcat(image_path,'tr9.jpg');
I=imread(image);
I_ann=strcat(image_path,'tr_ann9');
I1=readmatrix(I_ann);
I=double(I);
size1=size(I);
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
lab(:,:,2)=I(:,:,3)-I(:,:,1);
lab(:,:,3)=I(:,:,3)-I(:,:,2);
for i=1:size1(1)
    for j=1:size1(2)
       if  I1(i,j)==0
           k=k+1;
           X(1,k)=lab(i,j,2);
           X(2,k)=lab(i,j,3);
       end
    end
end
%the end 读取第九幅图像
% 
% % %读取第十幅图像
% image=strcat(image_path,'tr10.jpg');
% I=imread(image);
% I_ann=strcat(image_path,'tr_ann10');
% I1=readmatrix(I_ann);
% I=double(I);
% size1=size(I);
% cform = makecform('srgb2lab'); 
% lab = applycform(I, cform);
% lab(:,:,2)=I(:,:,3)-I(:,:,1);
% lab(:,:,3)=I(:,:,3)-I(:,:,2);
% for i=1:size1(1)
%     for j=1:size1(2)
%        if  I1(i,j)==0
%            k=k+1;
%            X(1,k)=lab(i,j,2);
%            X(2,k)=lab(i,j,3);
%        end
%     end
% end
% % %the end 读取第十幅图像

m=zeros(2,1);%定义平均向量
m(1)=mean(X(1,:));
m(2)=mean(X(2,:));
X(1,:)=X(1,:)-m(1);
X(2,:)=X(2,:)-m(2);%将样本向量减去均值向量
C=(X*X')/k;%得到协方差矩阵
C1=inv(C);