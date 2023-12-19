function [ slic_label2 ] = SLIC_0410(I,num_superpixel,minsize_superpixel)
% SLIC : estimate the Std Dev on the linear path between cluster center and each pixel 

%% no_size 为对图像进行缩放处理
%% preparation
% pic
I_rgb_or = I;
% I_rgb = imresize(I_rgb_or,[no_size (no_size*size(I_rgb_or,2)/size(I_rgb_or,1))]);
I_rgb=I_rgb_or;
size_I = size(I_rgb);
fprintf('pic size:[%d,%d]->[%d,%d]\n', size(I_rgb_or,1), size(I_rgb_or,2), size_I(1), size_I(2) );

% rgb 转 lab
cform = makecform('srgb2lab'); 
lab = applycform(I_rgb, cform);
L = double(lab(:,:,1));
A = double(lab(:,:,2));
B = double(lab(:,:,3));

% gradient
[ gradient_I ] = gradient_computition( I_rgb, L, A, B );
max_g = max(max(gradient_I));


disp('1) an initialization step...')
%% an initialization step 
%% where k(num_superpixel) initial cluster centers are sampled on a regular grid spaced S(seed_step) pixels apart.
pixel_number_I = size_I(1)*size_I(2);


% initial cluster center(均分超像素块的中心)
center_coordinate = zeros(num_superpixel+10, 5);
seed_step = fix( sqrt(pixel_number_I/num_superpixel ));
seed_step_half = fix( seed_step/2 );

acc_n=0;
for i = seed_step_half : seed_step : size_I(1)
    for j = seed_step_half : seed_step : size_I(2)
        acc_n=acc_n+1;
        center_coordinate(acc_n, 1) = i;
        center_coordinate(acc_n, 2) = j;
        center_coordinate(acc_n, 3) = L(i,j);
        center_coordinate(acc_n, 4) = A(i,j);
        center_coordinate(acc_n, 5) = B(i,j);
    end
end
num_superpixel = acc_n;  
fprintf('superpixel num: %d, mean size: %f (step: %d), minimum size: %d; \n', num_superpixel, (pixel_number_I/num_superpixel), seed_step, minsize_superpixel);

% updata initial cluster center(move to seed locations corresponding to the lowest gradient position in a 3 × 3 neighborhood)
[ center_coordinate ] = correct_center_coordinate(center_coordinate, num_superpixel, 2);
   


disp('2) an assignment step...')
%% the assignment step
%% where each pixel i is associated with the nearest cluster center whose search region overlaps its location
Ns = sqrt( 2*(2*seed_step)^2 );
Nc = zeros(size_I(1), size_I(2));
Ng = zeros(size_I(1), size_I(2));
for i=1:size_I(1)
    for j=1:size_I(2)
        [Nc(i,j), Ng(i,j)] = compute_NcNg(i, j, seed_step);
    end
end

w1= 0.2;  % color weight
w2= 0.2;  % spatial distance weight
w3= 0.6;  % gradient weight


%iter 4
n_iter = 4;
for iter= 1:n_iter
    fprintf('%d,', (n_iter-iter+1) );
    slic_label = zeros( size_I(1), size_I(2) );
    % assign pixels
    min_distance = ones( size_I(1), size_I(2) )*5000000;
    for k = 1:num_superpixel
        center_x = center_coordinate(k,1);
        center_y = center_coordinate(k,2);
        slic_label(center_x, center_y) = k;
        min_distance(center_x, center_y) = -1;
        
        
        for i= -seed_step : seed_step
            for j= -seed_step : seed_step
                if i==0 && j==0
                    continue;
                end
                    
                current_x= center_x+i;
                current_y= center_y+j;
                if current_x>=1 && current_x<=size_I(1) && current_y>=1 && current_y<=size_I(2) && min_distance(current_x,current_y)>0
                    dc = sqrt( (L(current_x,current_y)-center_coordinate(k,3))^2 + (A(current_x,current_y)-center_coordinate(k,4))^2 + (B(current_x,current_y)-center_coordinate(k,5))^2  );
                    ds = sqrt( (i)^2 + (j)^2 );
                    
                    [ pathx, pathy ] = find_linear_path( [center_x,center_y], [current_x,current_y] );
                    gras = zeros(numel(pathx), 1);
                    for tt = 1:numel(pathx)
                        gras(tt) = gradient_I(pathx(tt), pathy(tt));
                    end
                    gra= (std(gras))^2;
                   
                    D = w1*(dc/Nc(current_x,current_y)) + w2*(ds/Ns) + w3*(gra/(Ng(current_x,current_y)^2));
                    if D<=min_distance(current_x,current_y)
                        slic_label(current_x,current_y) = k;
                        min_distance(current_x,current_y) = D;
                    end
                end
            end
        end
        
        
        if ~mod((num_superpixel-k),1000)
            fprintf('(%d)', (num_superpixel-k) );       
        end
    end
    num_no_label = numel(find(slic_label==0));       
        
    % update seed_coordinate
    center_coordinate =zeros(num_superpixel, 6);
    for i= 1:size_I(1)
        for j= 1:size_I(2)
            temp_label= slic_label(i,j);
            if temp_label
                center_coordinate(temp_label,1)= center_coordinate(temp_label,1) +i;
                center_coordinate(temp_label,2)= center_coordinate(temp_label,2) +j;
                center_coordinate(temp_label,3)= center_coordinate(temp_label,3) +L(i,j);
                center_coordinate(temp_label,4)= center_coordinate(temp_label,4) +A(i,j);
                center_coordinate(temp_label,5)= center_coordinate(temp_label,5) +B(i,j);
                center_coordinate(temp_label,6)= center_coordinate(temp_label,6) +1;
            end
        end
    end
    
    empty_sp = [];
    for k=1:num_superpixel
        pn = center_coordinate(k, 6);
        if pn<=1
            empty_sp = [empty_sp k];
            continue;
        end
            
        center_coordinate(k, 1)= fix(center_coordinate(k, 1)/pn);
        center_coordinate(k, 2)= fix(center_coordinate(k, 2)/pn);
        center_coordinate(k, 3)= (center_coordinate(k, 3)/pn);
        center_coordinate(k, 4)= (center_coordinate(k, 4)/pn);
        center_coordinate(k, 5)= (center_coordinate(k, 5)/pn);      
    end
    center_coordinate(empty_sp, :) = [];
    num_superpixel = num_superpixel - numel(empty_sp);
    center_coordinate(:,6) = [];
    center_coordinate = correct_center_coordinate(center_coordinate, num_superpixel, 1);
end



if ismember(0, slic_label)
    slic_label(slic_label==0) = max(max(slic_label))+1; 
end
% tt = slic_label;


fprintf('\n');disp('3) post-processing...')
%% Post-processing
%删除过小的超像素
slic_label2 = ones( size_I(1), size_I(2) )*(-1);

k = 1;
small_regions = [];
for i= 1:size_I(1)
    for j= 1:size_I(2)
        if slic_label2(i,j)==-1
            
            temp_label= 2000000;
            slic_label2(i,j)= temp_label;
            stack1= zeros(num_superpixel,2);
            stack1(1,1)= i;
            stack1(1,2)= j;
            acc_pixel=1;            
            
            flag= 1;
            while flag>=1
                current_x= stack1(flag,1);
                current_y= stack1(flag,2);
                flag=flag-1;
                
                if (current_x-1)>=1 && (current_x-1)<=size_I(1) && current_y>=1 && current_y<=size_I(2)
                    if slic_label(current_x-1,current_y)==slic_label(current_x,current_y) && slic_label2(current_x-1,current_y)~=temp_label 
                        flag=flag+1;
                        stack1(flag,1)=current_x-1;
                        stack1(flag,2)=current_y;
                        slic_label2(current_x-1,current_y)=temp_label;
                        acc_pixel=acc_pixel+1;
                    end
                end
                if (current_x+1)>=1 && (current_x+1)<=size_I(1) && current_y>=1 && current_y<=size_I(2)
                    if slic_label(current_x+1,current_y)==slic_label(current_x,current_y) && slic_label2(current_x+1,current_y)~=temp_label 
                        flag=flag+1;
                        stack1(flag,1)=current_x+1;
                        stack1(flag,2)=current_y;
                        slic_label2(current_x+1,current_y)=temp_label;
                        acc_pixel=acc_pixel+1;
                    end
                end      
                if current_x>=1 && current_x<=size_I(1) && (current_y-1)>=1 && (current_y-1)<=size_I(2)
                    if slic_label(current_x,current_y-1)==slic_label(current_x,current_y)  && slic_label2(current_x,current_y-1)~=temp_label
                        flag=flag+1;
                        stack1(flag,1)=current_x;
                        stack1(flag,2)=current_y-1;
                        slic_label2(current_x,current_y-1)=temp_label;
                        acc_pixel=acc_pixel+1;
                    end
                end
                if current_x>=1 && current_x<=size_I(1) && (current_y+1)>=1 && (current_y+1)<=size_I(2)
                    if slic_label(current_x,current_y+1)==slic_label(current_x,current_y)  && slic_label2(current_x,current_y+1)~=temp_label
                        flag=flag+1;
                        stack1(flag,1)=current_x;
                        stack1(flag,2)=current_y+1;
                        slic_label2(current_x,current_y+1)=temp_label;
                        acc_pixel=acc_pixel+1;
                    end
                end
            end
            slic_label2(slic_label2==temp_label)= k;
            if acc_pixel<minsize_superpixel
                small_regions = [small_regions k ];
            end
            k=k+1;
        end
    end
end
fprintf('small_regions amount:[%d]\n', numel(small_regions) );

            
for k = small_regions
    [is, js] = find(slic_label2==k);
    if numel(is)<minsize_superpixel
    
    adjacents = [];
    for v = 1:numel(is)
        i = is(v);
        j = js(v);       
        
        if i==1 && j==1
            if slic_label2(i,j) ~= slic_label2(i+1,j)  adjacents = [adjacents slic_label2(i+1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j+1)  adjacents = [adjacents slic_label2(i,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j+1)  adjacents = [adjacents slic_label2(i+1,j+1)];   end
        end
        if i==1 && j==size_I(2)
            if slic_label2(i,j) ~= slic_label2(i+1,j)  adjacents = [adjacents slic_label2(i+1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j-1)  adjacents = [adjacents slic_label2(i,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j-1)  adjacents = [adjacents slic_label2(i+1,j-1)];   end
        end
        if i==size_I(1) && j==1
            if slic_label2(i,j) ~= slic_label2(i-1,j)  adjacents = [adjacents slic_label2(i-1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j+1)  adjacents = [adjacents slic_label2(i,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j+1)  adjacents = [adjacents slic_label2(i-1,j+1)];   end
        end
        if i==size_I(1) && j==size_I(2)
            if slic_label2(i,j) ~= slic_label2(i-1,j)  adjacents = [adjacents slic_label2(i-1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j-1)  adjacents = [adjacents slic_label2(i,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j-1)  adjacents = [adjacents slic_label2(i-1,j-1)];   end
        end

        if i==1 && j>1 && j<size_I(2)
            if slic_label2(i,j) ~= slic_label2(i+1,j)  adjacents = [adjacents slic_label2(i+1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j-1)  adjacents = [adjacents slic_label2(i,j-1)];   end
            if slic_label2(i,j) ~= slic_label2(i,j+1)  adjacents = [adjacents slic_label2(i,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j-1)  adjacents = [adjacents slic_label2(i+1,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j+1)  adjacents = [adjacents slic_label2(i+1,j+1)];   end
        end
        if i>1 && i<size_I(1) && j==1
            if slic_label2(i,j) ~= slic_label2(i-1,j)  adjacents = [adjacents slic_label2(i-1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i+1,j)  adjacents = [adjacents slic_label2(i+1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j+1)  adjacents = [adjacents slic_label2(i,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j+1)  adjacents = [adjacents slic_label2(i-1,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j+1)  adjacents = [adjacents slic_label2(i+1,j+1)];   end
        end
        if i==size_I(1) && j>1 && j<size_I(2)
            if slic_label2(i,j) ~= slic_label2(i-1,j)  adjacents = [adjacents slic_label2(i-1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j-1)  adjacents = [adjacents slic_label2(i,j-1)];   end
            if slic_label2(i,j) ~= slic_label2(i,j+1)  adjacents = [adjacents slic_label2(i,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j-1)  adjacents = [adjacents slic_label2(i-1,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j+1)  adjacents = [adjacents slic_label2(i-1,j+1)];   end
        end
        if i>1 && i<size_I(1) && j==size_I(2)
            if slic_label2(i,j) ~= slic_label2(i-1,j)  adjacents = [adjacents slic_label2(i-1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i+1,j)  adjacents = [adjacents slic_label2(i+1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j-1)  adjacents = [adjacents slic_label2(i,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j-1)  adjacents = [adjacents slic_label2(i-1,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j-1)  adjacents = [adjacents slic_label2(i+1,j-1)];   end
        end
      
        if i>1 && i<size_I(1) && j>1 && j<size_I(2)
            if slic_label2(i,j) ~= slic_label2(i-1,j)  adjacents = [adjacents slic_label2(i-1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i+1,j)  adjacents = [adjacents slic_label2(i+1,j)];   end
            if slic_label2(i,j) ~= slic_label2(i,j-1)  adjacents = [adjacents slic_label2(i,j-1)];   end
            if slic_label2(i,j) ~= slic_label2(i,j+1)  adjacents = [adjacents slic_label2(i,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j-1)  adjacents = [adjacents slic_label2(i-1,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j-1)  adjacents = [adjacents slic_label2(i+1,j-1)];   end
%             if slic_label2(i,j) ~= slic_label2(i-1,j+1)  adjacents = [adjacents slic_label2(i-1,j+1)];   end
%             if slic_label2(i,j) ~= slic_label2(i+1,j+1)  adjacents = [adjacents slic_label2(i+1,j+1)];   end
        end 
    end
    [adjacent] = find_adjacent(slic_label2(i,j), unique(adjacents), slic_label2);
    slic_label2(slic_label2==k) = adjacent; 
    
    end               
end



%对超像素块重新编号
disp('重新编号...')
if ismember(-1, slic_label2)
    slic_label2 = slic_label2+2;
end
max_label= max(max(slic_label2));
num_eachlabel = zeros(max_label,1);
for i= 1:size_I(1)
    for j= 1:size_I(2)
        num_eachlabel( slic_label2(i,j) ) = num_eachlabel( slic_label2(i,j) )+1;
    end
end
t_top = 1;
t_bottom = max_label;
while t_top<t_bottom
    if ~num_eachlabel(t_top) && num_eachlabel(t_bottom)
        slic_label2(slic_label2==t_bottom) = t_top;
        t_top = t_top +1;
        t_bottom = t_bottom -1;
    else if ~num_eachlabel(t_top) && ~num_eachlabel(t_bottom)
            t_bottom = t_bottom -1;
        else if num_eachlabel(t_top)
                t_top = t_top +1;
            end
        end
    end   
end




    function [ center_coordinate ] = correct_center_coordinate(center_coordinate, num_superpixel, s)
        for k = 1:num_superpixel
            min_gra = max_g;
            for ii= (-1*s):s
                for jj = (-1*s):s
                    if ii==0&&jj==0 continue; end
                    c_x = center_coordinate(k,1)+ ii;
                    c_y = center_coordinate(k,2)+ jj;
                    if c_x>1 && c_x<size_I(1) && c_y>1 && c_y<size_I(2)
                        c_gra = gradient_I(c_x, c_y);
                        if c_gra<=min_gra
                            min_gra=c_gra;
                            center_coordinate(k, 1)=c_x;
                            center_coordinate(k, 2)=c_y;
                            center_coordinate(k, 3)=L(c_x,c_y);
                            center_coordinate(k, 4)=A(c_x,c_y);
                            center_coordinate(k, 5)=B(c_x,c_y);                
                        end
                    end
                end
            end
        end
    end

    function [Nc, Ng] = compute_NcNg(center_x, center_y, seed_step)
        si = max(1, center_x-seed_step);
        ei = min(size_I(1), center_x+seed_step);
        sj = max(1, center_y-seed_step);
        ej = min(size_I(2), center_y+seed_step);
        rL = L(si:ei, sj:ej);
        rA = A(si:ei, sj:ej);
        rB = B(si:ei, sj:ej);
        rG = gradient_I(si:ei, sj:ej);
        
        Nc = sqrt(  (max(max(rL))-min(min(rL)))^2 + (max(max(rA))-min(min(rA)))^2 + (max(max(rB))-min(min(rB)))^2   );
        Ng = (max(max(rG))-min(min(rG)));
        
        if Nc<=0 Nc=1; end
        if Ng<=0 Ng=1; end
    end

    function [adjacent] = find_adjacent(c_k, adjacents, slic_label2)
        c_is = find(slic_label2==c_k);
        c_linfo = [ sum(L(c_is))/numel(c_is), sum(A(c_is))/numel(c_is), sum(B(c_is))/numel(c_is) ];
        
        min_dc = 5000000;
        for a_a = adjacents            
            [a_is] = find(slic_label2==a_a);
            a_linfo = [ sum(L(a_is))/numel(a_is), sum(A(a_is))/numel(a_is), sum(B(a_is))/numel(a_is) ];
            cur_dc= (c_linfo(1)-a_linfo(1))^2 + (c_linfo(2)-a_linfo(2))^2 + (c_linfo(3)-a_linfo(3))^2;
            if cur_dc<min_dc
                min_dc = cur_dc;
                adjacent = a_a;
            end
        end
    end


end

