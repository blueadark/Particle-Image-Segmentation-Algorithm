function [slic_result2,num_superpixel] = slic_m(I,num_superpixel,n_iter,minsize_superpixel,w1,w2)
%SLIC_M 此处显示有关此函数的摘要
%% 读取图像

size_I=size(I);
%rgb转lab
cform = makecform('srgb2lab'); 
lab = applycform(I, cform);
L=double(lab(:,:,1));
A=double(lab(:,:,2));
B=double(lab(:,:,3));
%% 参数设置
%设置分割超像素块个数 num_superpixel=1000
%设置最小的超像素大小 minsize_superpixel
%设置循环次数 n_iter=10
%w1代表颜色距离的比例 
%w2代表空间距离的比例 
%% 初始化种子点

image_pixels_number=size_I(1)*size_I(2);
seed_step=fix(sqrt(image_pixels_number/num_superpixel));
seed_step_half=fix(seed_step/2);
%定义种子点变量，存放五个特征
seed_coordinate=zeros(num_superpixel,5);

acc_n=0;
for i=seed_step_half:seed_step:size_I(1)
     for j=seed_step_half:seed_step:size_I(2)
         acc_n=acc_n+1;
         seed_coordinate(acc_n,1)=i;
         seed_coordinate(acc_n,2)=j;
         seed_coordinate(acc_n,3)=L(i,j);
         seed_coordinate(acc_n,4)=A(i,j);
         seed_coordinate(acc_n,5)=B(i,j);
     end
end

% 获取真实种子个数
num_superpixel=acc_n;

%% 种子转移
% 更正种子点坐标
s=1;
% 计算n*n邻域内所有像素点的梯度值，将种子点移到该邻域内梯度最小的地方,一般取n=3
for k=1:num_superpixel
    min_gradient=20000;
    temp_x=seed_coordinate(k,1);
    temp_y=seed_coordinate(k,2);
    for i=(-1*s):s
        for j=(-1*s):s
            x = seed_coordinate(k,1)+ i;
            y = seed_coordinate(k,2)+ j;
            if x>1 && x<size_I(1) && y>1 && y<size_I(2)
                dx=(L(x-1,y)-L(x+1,y))*(L(x-1,y)-L(x+1,y))+(A(x-1,y)-A(x+1,y))*(A(x-1,y)-A(x+1,y))+(B(x-1,y)-B(x+1,y))*(B(x-1,y)-B(x+1,y));
                dy=(L(x,y-1)-L(x,y+1))*(L(x,y-1)-L(x,y+1))+(A(x,y-1)-A(x,y+1))*(A(x,y-1)-A(x,y+1))+(B(x,y-1)-B(x,y+1))*(B(x,y-1)-B(x,y+1));
                gradient=dx+dy;
                if gradient<min_gradient
                    min_gradient=gradient;   
                    temp_x=x;
                    temp_y=y;
                end
            end
        end
    end
    seed_coordinate(k,1)=temp_x;
    seed_coordinate(k,2)=temp_y;
    seed_coordinate(k,3)=L(temp_x,temp_y);
    seed_coordinate(k,4)=A(temp_x,temp_y);
    seed_coordinate(k,5)=B(temp_x,temp_y);    
end

%修正种子点
seed_coordinate(all(seed_coordinate == 0 ,2),:)=[];
seed_coordinate=unique(seed_coordinate,'rows');

% %显示种子位置
% I_gray=rgb2gray(I);
% figure,imshow(I_gray);
% hold on;
% plot(seed_coordinate(:,2),seed_coordinate(:,1),'r.');


%% 循环运行，分配各像素点


num_superpixel=size(seed_coordinate,1);
Ns=2*(seed_step^2);
Nc=(max(max(L))-min(min(L)))^2+(max(max(A))-min(min(A)))^2+(max(max(B))-min(min(B)))^2;
for iter=1:n_iter
    slic_result=zeros(size_I(1),size_I(2));
    min_distance=ones(size_I(1),size_I(2))*500000;
    for k=1:num_superpixel
        center_x=seed_coordinate(k,1);
        center_y=seed_coordinate(k,2);
        slic_result(center_x,center_y)=k;
        min_distance(center_x,center_y)=-1;
        for i=-seed_step:seed_step
            for j=-seed_step:seed_step
                if i==0 && j==0
                    continue;
                end
                current_x=center_x+i;
                current_y=center_y+j;
                if current_x>=1 && current_x<=size_I(1) && current_y>=1 ...
                                && current_y<=size_I(2) ...
                                && min_distance(current_x,current_y)>0
                    dc=  (L(current_x,current_y)-seed_coordinate(k,3))^2 + ...
                         (A(current_x,current_y)-seed_coordinate(k,4))^2 + ...
                         (B(current_x,current_y)-seed_coordinate(k,5))^2  ;
                    ds=  (i)^2 + (j)^2 ;
                    D=w1*dc/Nc+w2*ds/Ns;
                    if D<=min_distance(current_x,current_y)
                        slic_result(current_x,current_y) = k;
                        min_distance(current_x,current_y) = D;
                    end
                end
            end
        end
    end
    seed_coordinate=zeros(num_superpixel,6);
    for i=1:size_I(1)
        for j=1:size_I(2)
            mid1=slic_result(i,j);
            if mid1~=0
                seed_coordinate(mid1,1)=seed_coordinate(mid1,1)+i;
                seed_coordinate(mid1,2)=seed_coordinate(mid1,2)+j;
                seed_coordinate(mid1,3)=seed_coordinate(mid1,3)+L(i,j);
                seed_coordinate(mid1,4)=seed_coordinate(mid1,4)+A(i,j);
                seed_coordinate(mid1,5)=seed_coordinate(mid1,5)+B(i,j);
                seed_coordinate(mid1,6)=seed_coordinate(mid1,6)+1;
            end
        end
    end

    for i=1:5
        seed_coordinate(:,i)=fix(seed_coordinate(:,i)./seed_coordinate(:,6));
    end

end
%对剩余的未分配的像素进行分配
unlocated_label=find(slic_result==0);
if ~isempty(unlocated_label)
    unlocated_metrx=zeros(size_I(1),size_I(2));
    unlocated_metrx(unlocated_label)=1;
    BB=bwconncomp(unlocated_metrx);
    for kk=1:BB.NumObjects
        slic_result(BB.PixelIdxList{kk})=max(max(slic_result))+1;
    end
end
%显示初步分割结果
% BW = boundarymask(slic_result,4);
% figure,imshow(imoverlay(I,BW,'red'),'InitialMagnification',100);
% title('初步分割结果');


%% 删除过小的超像素,同时重新编号

%slic_result2存放处理结果
slic_result2=zeros(size_I(1),size_I(2))-1;
%nn重新编号
nn=0;
for i=1:size_I(1)
    for j=1:size_I(2)
        % adj_label记录前一个相连的超像素的slic_result2标号
        adj_label=[];
        if slic_result2(i,j)==-1
            adjacent=[];
            if i>1 && slic_result2(i-1,j)>0
                adjacent=[adjacent slic_result2(i-1,j)];
            end
            if i<size_I(1) && slic_result2(i+1,j)>0
                adjacent=[adjacent slic_result2(i+1,j)];
            end
            if j>1 && slic_result2(i,j-1)>0
                adjacent=[adjacent slic_result2(i,j-1)];
            end
            if j<size_I(2) && slic_result2(i,j+1)>0
                adjacent=[adjacent slic_result2(i,j+1)];
            end
            if ~isempty(adjacent)
                adj_label=mode(adjacent);
            end

            %扩展当前超像素
            stack1(1,1)=i;
            stack1(1,2)=j;
            total=1;
            mark=10000000;%标记已经访问的像素点
            slic_result2(i,j)=mark;
            while ~isempty(stack1)
                x=stack1(1,1);
                y=stack1(1,2);
                stack1(1,:)=[];
                if x>1 && slic_result(x-1,y)==slic_result(x,y)...
                       && slic_result2(x-1,y)==-1
                    stack1=[stack1;[x-1,y]]; 
                    slic_result2(x-1,y)=mark;
                    total=total+1;
                end
                if x<size_I(1) && slic_result(x+1,y)==slic_result(x,y)...
                               && slic_result2(x+1,y)==-1
                    stack1=[stack1;[x+1,y]]; 
                    slic_result2(x+1,y)=mark;
                    total=total+1;
                end
                if y>1 && slic_result(x,y-1)==slic_result(x,y)...
                       && slic_result2(x,y-1)==-1
                    stack1=[stack1;[x,y-1]]; 
                    slic_result2(x,y-1)=mark;
                    total=total+1;
                end
                if y<size_I(2) && slic_result(x,y+1)==slic_result(x,y)...
                               && slic_result2(x,y+1)==-1
                    stack1=[stack1;[x,y+1]]; 
                    slic_result2(x,y+1)=mark;
                    total=total+1;
                end
            end
            if slic_result(i,j)~=0
                if total<minsize_superpixel && ~isempty(adj_label)
                    slic_result2(slic_result2==mark)=adj_label;
                else
                    nn=nn+1;
                    slic_result2(slic_result2==mark)=nn;
                end
            else
                slic_result2(slic_result2==mark)=0;
            end
        end
    end
end

% 重新编号
max_label=max(max(slic_result2));
each_num_superpixel=zeros(max_label,1);
for i=1:max_label
    t_label=find(slic_result2==i);
    each_num_superpixel(i)=length(t_label);
end
t_top=1;
t_bottom=max_label;
while t_top<t_bottom
    if ~each_num_superpixel(t_top) && each_num_superpixel(t_bottom)
        slic_result2(slic_result2==t_bottom) = t_top;
        t_top = t_top +1;
        t_bottom = t_bottom -1;
    else
        if ~each_num_superpixel(t_top) && ~each_num_superpixel(t_bottom)
            t_bottom = t_bottom -1;
        else
            if each_num_superpixel(t_top)
                t_top = t_top +1;
            end
        end
    end   
end


%显示最终结果
num_superpixel=max(max(slic_result2));
fprintf('superpixel num: %d, mean size: %f (step: %d)\n', num_superpixel, (image_pixels_number/num_superpixel), seed_step);


% BW2 = boundarymask(slic_result2,4);
% figure,imshow(imoverlay(I,BW2,'red'),'InitialMagnification',100);
% title('结果图');

end

