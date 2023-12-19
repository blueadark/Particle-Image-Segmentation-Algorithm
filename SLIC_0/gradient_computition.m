function [ gradient ] = gradient_computition( img, L, A, B )
% based on sobel operator

% size
size_I = size(L);
img = rgb2gray(img);

% operator
Mx = [-1  0  1;
      -1  0  1;
      -1  0  1];
My = [1   1   1;
      0   0   0;
     -1  -1  -1;];

% dx
L_gra_x = zeros(size_I);
L_gra_x(2:end-1, 2:end-1) = conv2(L, rot90(Mx,2), 'valid');
L_gra_x(1,:) = L_gra_x(2,:);
L_gra_x(end,:) = L_gra_x(end-1,:);
L_gra_x(:,1) = L_gra_x(:,2);
L_gra_x(:,end) = L_gra_x(:,end-1); 

A_gra_x = zeros(size_I);
A_gra_x(2:end-1, 2:end-1) = conv2(A, rot90(Mx,2), 'valid');
A_gra_x(1,:) = A_gra_x(2,:);
A_gra_x(end,:) = A_gra_x(end-1,:);
A_gra_x(:,1) = A_gra_x(:,2);
A_gra_x(:,end) = A_gra_x(:,end-1);

B_gra_x = zeros(size_I);
B_gra_x(2:end-1, 2:end-1) = conv2(B, rot90(Mx,2), 'valid');
B_gra_x(1,:) = B_gra_x(2,:);
B_gra_x(end,:) = B_gra_x(end-1,:);
B_gra_x(:,1) = B_gra_x(:,2);
B_gra_x(:,end) = B_gra_x(:,end-1);

gra_dx = L_gra_x.^2 + A_gra_x.^2 + B_gra_x.^2;

% gra_x = zeros(size_I);
% gra_x(2:end-1, 2:end-1) = conv2(img, rot90(Mx,2), 'valid');
% gra_x(1,:) = gra_x(2,:);
% gra_x(end,:) = gra_x(end-1,:);
% gra_x(:,1) = gra_x(:,2);
% gra_x(:,end) = gra_x(:,end-1); 
% 
% gra_dx = gra_x.^2;

% dy
L_gra_y = zeros(size_I);
L_gra_y(2:end-1, 2:end-1) = conv2(L, rot90(My,2), 'valid');
L_gra_y(1,:) = L_gra_y(2,:);
L_gra_y(end,:) = L_gra_y(end-1,:);
L_gra_y(:,1) = L_gra_y(:,2);
L_gra_y(:,end) = L_gra_y(:,end-1); 

A_gra_y = zeros(size_I);
A_gra_y(2:end-1, 2:end-1) = conv2(A, rot90(My,2), 'valid');
A_gra_y(1,:) = A_gra_y(2,:);
A_gra_y(end,:) = A_gra_y(end-1,:);
A_gra_y(:,1) = A_gra_y(:,2);
A_gra_y(:,end) = A_gra_y(:,end-1);

B_gra_y = zeros(size_I);
B_gra_y(2:end-1, 2:end-1) = conv2(B, rot90(My,2), 'valid');
B_gra_y(1,:) = B_gra_y(2,:);
B_gra_y(end,:) = B_gra_y(end-1,:);
B_gra_y(:,1) = B_gra_y(:,2);
B_gra_y(:,end) = B_gra_y(:,end-1);

gra_dy = L_gra_y.^2 + A_gra_y.^2 + B_gra_y.^2;

% gra_y = zeros(size_I);
% gra_y(2:end-1, 2:end-1) = conv2(img, rot90(My,2), 'valid');
% gra_y(1,:) = gra_y(2,:);
% gra_y(end,:) = gra_y(end-1,:);
% gra_y(:,1) = gra_y(:,2);
% gra_y(:,end) = gra_y(:,end-1); 
% 
% gra_dy = gra_y.^2;


%gradient
gradient = sqrt(gra_dx + gra_dy);



end

