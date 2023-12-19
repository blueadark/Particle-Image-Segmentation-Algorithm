function [label_idx,scores] = train_cell(img_name,slic,T)

%% 细胞图像参数设置
m1=[141.3735;84.9490];
C1=[0.0045,-0.0061;-0.0061,0.0090];
m2=[5.3108;3.8921];
C2=[0.1644,-0.2175;-0.2175,0.3038];

%% 读取图像
    I=double(img_name);
    num_pixels=max(max(slic));%返回分块数量
    
%% 分别计算每个像素的属于前景概率和背景的概率
    
    x1=zeros(2,1);
    x2=zeros(2,1);
    size1=size(I);
    lab=zeros(size1(1),size1(2),3);
    lab(:,:,2)=I(:,:,3)-I(:,:,1);
    lab(:,:,3)=I(:,:,3)-I(:,:,2);
    p1=zeros(size1(1),size1(2));
    p2=zeros(size1(1),size1(2));
    for i=1:size1(1)
        for j=1:size1(2)
            %计算各点属于谷粒的概率
            x1(1)=lab(i,j,2)-m1(1);
            x1(2)=lab(i,j,3)-m1(2);
            temp=-0.5*x1'*C1*x1;
            p1(i,j)=exp(temp);
            %计算各点属于背景的概率
            x2(1)=lab(i,j,2)-m2(1);
            x2(2)=lab(i,j,3)-m2(2);
            temp=-0.5*x2'*C2*x2;
            p2(i,j)=exp(temp);
        end
    end

%% 超像素分类

    %将标签矩阵L描述的区域转换为线性索引
    idx = label2idx(slic);
    numRows = size(I,1);
    numCols = size(I,2);
    % 对背景区域块和前景区域块进行标注
    classifier1=zeros(numRows,numCols);%标记前景块
    classifier2=zeros(numRows,numCols);%标记背景块
    label=zeros(num_pixels,1);
    temp=zeros(num_pixels,4);
    for labelVal=1:num_pixels
        count=idx{labelVal};
        temp(labelVal,1)=sum(p1(count));
        temp(labelVal,2)=sum(p2(count));
        temp(labelVal,3)=size(count,1);
        temp(labelVal,4)=temp(labelVal,1)/size(count,1);
        temp(labelVal,5)=temp(labelVal,2)/size(count,1);
        temp_max=max(temp(labelVal,4),temp(labelVal,5));
        temp_min=min(temp(labelVal,4),temp(labelVal,5));
        temp(labelVal,6)=temp_max*(1+log(temp_max/temp_min));

        if temp(labelVal,4)>temp(labelVal,5) && temp(labelVal,6)>T
           classifier1(count)=1;
           label(labelVal)=1;
        elseif temp(labelVal,5)>temp(labelVal,4) && temp(labelVal,6)>T
           classifier2(count)=1;
           label(labelVal)=-1;
        else
           continue; 
        end

    end
    
    scores=temp;
    label=num2cell(label);
    label_idx=[idx;label'];


end

