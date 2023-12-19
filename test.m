close all;
clear all;
clc;
%dataset1为谷粒图像
%dataset2为色母粒图像
%dataset3为细胞图像
%%  谷粒图像
image_path='dataset1\第五组\';
image_name='d1.jpg';
% 读取图像
image=strcat(image_path,image_name);
I=imread(image);
trans_size=1000;
I=imresize(I,[trans_size (trans_size*size(I,2)/size(I,1))]);
figure,imshow(I);
% 基于高斯模型与超像素的颗粒分割算法
[result_1]=f_keli(I,1,@train_grain);
figure,imshow(result_1);
imwrite(result_1,'Output\grain\d1.jpg');
%%  色母颗粒
image_path='dataset2\第一组\';
image_name='d1.jpg';
% 读取图像
image=strcat(image_path,image_name);
I=imread(image);
trans_size=1000;
I=imresize(I,[trans_size (trans_size*size(I,2)/size(I,1))]);
figure,imshow(I);
% 基于高斯模型与超像素的颗粒分割算法
[result_2]=f_keli(I,1,@train_master);
figure,imshow(result_2);
imwrite(result_2,'Output\master\d1.jpg');
%% 细胞图像
image_path='dataset3\NucleusSegData\Huh7TestSet\';
image_name='huh7_ts6.jpg';
image_anno='huh7_ts6_gold';
% 读取图像
image=strcat(image_path,image_name);
I=imread(image);
figure,imshow(I);
title('原图');
% 读取标签
anno=strcat(image_path,image_anno);
I_ann=readmatrix(anno);
figure,imshow(I_ann);
title('人工标记');
% 基于高斯模型与超像素的颗粒分割算法
[result_3]=f_keli(I,1,@train_cell);
figure,imshow(result_3);
imwrite(result_3,'Output\cell\huh7_ts6.jpg');
% 计算指标
[P_1,R_1,F_1,I_1]=f_index(result_3,I_ann);
index=[P_1 R_1 F_1 I_1];

