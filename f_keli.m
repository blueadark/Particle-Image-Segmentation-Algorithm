function [output1] = f_keli(I,T,train)

%% 超像素一次分割

%设置超像素预分割块数
superpixel_number=2000;
%图像大小
image_pixels_number=size(I,1)*size(I,2);
%步长
seed_step=fix(sqrt(image_pixels_number/superpixel_number));

% 改进SLIC算法
addpath(genpath('SLIC_0'));
minsize_superpixel=50;
% [slic_labels]=SLIC_0410(I,superpixel_number,minsize_superpixel);
[slic_labels,~]=slic_m(I,superpixel_number,10,50,0.9,0.1);
%显示一次分割结果图
% B = boundarymask(slic_labels,4);
% figure,imshow(imoverlay(I,B,'red'),'InitialMagnification',100);
% title('超像素分割图');

%% 超像素一次识别

%设置参数T=1

[labels_idx,scores_1]=train(I,slic_labels,T);

result_idx1=labels_idx;
[~,unlabeled]=find(cell2mat(labels_idx(2,:))==0);
result_idx1(:,[unlabeled])=[];

%显示一次识别结果
grain_segment=zeros(size(I,1),size(I,2));
background_segment=zeros(size(I,1),size(I,2));
unlabeled_segment=zeros(size(I,1),size(I,2));
[~,grain_1]=find(cell2mat(labels_idx(2,:))==1);
for j=1:length(grain_1)
    label_1=cell2mat(labels_idx(1,grain_1(j)));
    grain_segment(label_1)=1;
end
[~,grain_2]=find(cell2mat(labels_idx(2,:))==-1);
for j=1:length(grain_2)
    label_2=cell2mat(labels_idx(1,grain_2(j)));
    background_segment(label_2)=1;
end
[~,grain_3]=find(cell2mat(labels_idx(2,:))==0);
for j=1:length(grain_3)
    label_3=cell2mat(labels_idx(1,grain_3(j)));
    unlabeled_segment(label_3)=1;
end
BW  = labeloverlay(I,grain_segment,'Colormap','autumn');
BW2 = labeloverlay(BW,background_segment,'Colormap','winter');
BW3 = labeloverlay(BW2,unlabeled_segment,'Colormap','white');

% figure,imshow(BW3);
% title('一次识别');
% figure,imshow(grain_segment);
%% 显示一次识别包围盒

box=zeros(length(unlabeled),7);%存放第一次最小包围盒特征
box_superpixel=[];%存放每个最小包围盒里的超像素块
% %显示全部最小包围盒
% I3=imoverlay(I,B,'red');
% figure,imshow(I3,'InitialMagnification',100);
% figure,imshow(BW3);
% title('最小包围盒图');
for k=1:length(unlabeled)
    
    un_idx=labels_idx{1,unlabeled(k)};
    box_superpixel=[box_superpixel;labels_idx(1,unlabeled(k))];
    [un_x,un_y]=ind2sub([size(I,1),size(I,2)],un_idx);
    %获取最小包围盒的坐标
    min_x=min(un_x);
    max_x=max(un_x);
    length_x=max_x-min_x;
    min_y=min(un_y);
    max_y=max(un_y);
    length_y=max_y-min_y;
    %显示最小包围盒
    box(k,:)=[min_x max_x min_y max_y length_x length_y (length_x+1)*(length_y+1)];
%     hold on;
%     rectangle('Position',[box(k,3) box(k,1) box(k,6) box(k,5)],'edgecolor','y','linewidth',2);
end


%% 确定交叉包围盒群 

%初始化参数
connect_box=[];%交叉包围盒群/超像素块号
tran_box=box(:,[3 1 6 5]);
judged_box=zeros(size(tran_box,1),1);%已确定包围盒
for k=1:size(tran_box,1)
    if judged_box(k)~=0
        continue;
    end
    bwcon=[k];
    connect=[];
    while ~isempty(bwcon)
        temp=bwcon(1);
        if judged_box(temp)==1
            bwcon(1)=[]; 
            continue;
        end
        connect=[connect temp];
        judged_box(temp)=1;
        bwcon(1)=[]; 
        area=rectint(tran_box(temp,:),tran_box(:,:));
        con=find(area>0);
        con_2=find(judged_box==0);
        bwcon=[bwcon intersect(con,con_2)'];

    end
    connect_box{1,end+1}=num2cell(connect);
    connect_box{2,end}=num2cell(unlabeled([connect]));
end
%% 二次分割包围盒及二次识别超像素
%超像素分割
result_idx2=[];
unlabeled_superpixels=[];
unlabeled_segment=zeros(size(I,1),size(I,2));
I2=zeros(size(I,1),size(I,2));

for i=1:size(connect_box,2)
        intersect_box=cell2mat(connect_box{1,i});
        [box_group,mark_max_size]=sortrows(box(intersect_box,:),7,'descend');%标记最大面积包围盒
%         begin_box=intersect_box(mark_max_size(1));
        while ~isempty(box_group)
            single_box=box_group(1,:);
            box_group(1,:)=[];
            min_x=single_box(1);
            max_x=single_box(2);
            min_y=single_box(3);
            max_y=single_box(4);
            length_x=single_box(5)+1;
            length_y=single_box(6)+1;
            %分割最小包围盒
            I_small=I(min_x:max_x,min_y:max_y,:);
           
            %步长按比例缩减，从而得到相应的分割块数
            seed_step_small_X=seed_step/2;
            seed_step_small_Y=seed_step/2;
            number_small=ceil(length_x/seed_step_small_X)*ceil(length_y/seed_step_small_Y);

            % 将去除一次识别结果的代码加入slic_m中
            I_small_g=grain_segment(min_x:max_x,min_y:max_y);
            I_small_b=background_segment(min_x:max_x,min_y:max_y);
            I_fore_box=I2(min_x:max_x,min_y:max_y);
            I_recog=(I_small_g+I_small_b)|I_fore_box;          
            [slic_labels_small,number_small]=slic_m_2(I_small,number_small,10,5,0.9,0.1,I_recog);
            if number_small==0 %代表该包围盒内已全部被识别过
                continue;
            end
            I2(min_x:max_x,min_y:max_y)=1;
           
            %识别最小包围盒内的超像素块
            [label_idx_small,scores_2]=train(I_small,slic_labels_small,T);
        
            %将子块坐标还原
            temp_result=[];
            for j=1:number_small
                [id_small_x,id_small_y]=re_back(label_idx_small{1,j},min_x,min_y,length_x,length_y);
                id_small = sub2ind([size(I,1),size(I,2)],id_small_x,id_small_y);
                temp_result=[temp_result [num2cell(id_small,1);label_idx_small(2,j)]];
            end
            %将第二次超像素识别的结果存储
            [~,grain_1]=find(cell2mat(temp_result(2,:))==1);
            for j=1:length(grain_1)
                result_idx2=[result_idx2 temp_result(:,grain_1(j))];
                label_1=cell2mat(temp_result(1,grain_1(j)));
                grain_segment(label_1)=1;
            end
            [~,grain_2]=find(cell2mat(temp_result(2,:))==-1);
            for j=1:length(grain_2)
                result_idx2=[result_idx2 temp_result(:,grain_2(j))];
                label_2=cell2mat(temp_result(1,grain_2(j)));
                background_segment(label_2)=1;
            end
            %将未识别的超像素块生成包围盒，并加入unlabeled_superpixels
            [~,grain_3]=find(cell2mat(temp_result(2,:))==0);
            for j=1:length(grain_3)
                label_3=cell2mat(temp_result(1,grain_3(j)));
                unlabeled_segment(label_3)=1;
                unlabeled_superpixels=[unlabeled_superpixels temp_result(1,grain_3(j))];
            end
        end
end
%% 二次识别结果图
% 
% BW4  = labeloverlay(I,grain_segment,'Colormap','autumn');
% BW5 = labeloverlay(BW4,background_segment,'Colormap','winter');
% BW6 = labeloverlay(BW5,unlabeled_segment,'Colormap','white');
% figure,imshow(BW6);
% title('二次识别');
% figure,imshow(grain_segment);
% title('二次识别,黑白图');

%% 采用集成训练法对剩余未识别的超像素块进行识别
if ~isempty(unlabeled_superpixels)
    unlabeled_superpixels(2,:)=num2cell(0);
    result_idx3=[result_idx1 result_idx2 unlabeled_superpixels];
    C_C=7;
    [result_idx3]=ensemble(result_idx3,C_C,I);

    %显示结果

    [~,grain_1]=find(cell2mat(result_idx3(2,:))==1);
    for j=1:length(grain_1)
        label_1=cell2mat(result_idx3(1,grain_1(j)));
        grain_segment(label_1)=1;
    end
    [~,grain_2]=find(cell2mat(result_idx3(2,:))==-1);
    for j=1:length(grain_2)
        label_2=cell2mat(result_idx3(1,grain_2(j)));
        background_segment(label_2)=1;
    end
end

output1=double(grain_segment);

%% 函数模块
% 子块坐标还原    
function [id_x,id_y]=re_back(idx_small,min_x,min_y,size_x,size_y)
    [id_x,id_y]=ind2sub([size_x size_y],idx_small);
    id_x(:,1)=id_x(:,1)-1+min_x;
    id_y(:,1)=id_y(:,1)-1+min_y;
end
    
end

