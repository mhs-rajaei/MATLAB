clear all
close all
RGB_Image = im2double(imread('peppers.png'));



% Normalize the Image:
myRange = getrangefromclass(RGB_Image(1));
newMax = myRange(2);
newMin = myRange(1);
RGB_Image_Norm = (RGB_Image - min(RGB_Image(:)))*(newMax - newMin)/(max(RGB_Image(:)) - min(RGB_Image(:))) + newMin;

RGB_Image_Norm_Resized = imresize(RGB_Image_Norm, [480 480]) ;

%%

% imshow(Red);
% t_img(:,:,1) = Red;
% t_img(:,:,2) = Green;
% t_img(:,:,3) = Blue;
% red_pca = PCA_(Red, 0);



% %%
% % imshow(RGB_Image_Norm_Resized);
% % Convert 3-dimensional array array to 2D, where each row is a pixel (RGB)
% X = reshape(RGB_Image_Norm_Resized, [], 3);
% N = size(X,1); % N is the number of pixels
% 
Red = RGB_Image_Norm_Resized(:,:,1);
Green = RGB_Image_Norm_Resized(:,:,2);
Blue = RGB_Image_Norm_Resized(:,:,3);
% figure(10)
% imshow(Red);
[red_eigvector , red_eigvalue] = PCA_(Red, 480);
[blue_eigvector , blue_eigvalue] = PCA_(Blue, 3);
[green_eigvector , green_eigvalue] = PCA_(Green, 3);

 %%
% 
% 
% %
% % imshow(RGB_Image_Norm_Resized);
% % Convert 3-dimensional array array to 2D, where each row is a pixel (RGB)
X = reshape(RGB_Image_Norm_Resized, [], 3);
N = size(X,1); % N is the number of pixels

% 
% % Get mean and covariance
mx = mean(X);
Cx = cov(X);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Get eigenvalues and eigenvectors of Cx.
% % Produces V,D such that Cx*V = V*D.
% % So the eigenvectors are the columns of V.
[V,D] = eig(Cx);
e1 = V(:,3);
% % disp('Eigenvector e1:'), disp(e1);
e2 = V(:,2);
% % disp('Eigenvector e2:'), disp(e2);
e3 = V(:,1);
% % disp('Eigenvector e3:'), disp(e3);
% % d1 = D(3,3);
% % disp('Eigenvalue d1:'), disp(d1);
% % d2 = D(2,2);
% % disp('Eigenvalue d2:'), disp(d2);
% % d3 = D(1,1);
% % disp('Eigenvalue d3:'), disp(d3);
% 
% % Construct matrix A such that the 1st row of A is the eigenvector 
% % corresponding to the largest eigenvalue, the 2nd row is the eigenvector 
% % corresponding to the second largest eigenvalue, etc.
A = [e1'; e2'; e3'];
% % Project input vectors x onto eigenvectors.  For each (column) vector x,
% % we will use the equation y = A*(x - mx).
% % To explain the Matlab commands below:
% %   X is our (N,3) array of vectors; each row is a vector.
% %   mx is the mean of the vectors, size (1,3).
% %   We first subtract off the mean using X - repmat(mx,N,1).
% %   We then transpose that result so that each vector is a column.
% %  We then apply our transform A to each column. 
Y = A*(X - repmat(mx,N,1))';    % Y has size 3xN
% 

% % Display y vectors as images
[height,width,depth] = size(RGB_Image_Norm_Resized);
Y1 = reshape(Y(1,:), height, width); 
Y2 = reshape(Y(2,:), height, width);
Y3 = reshape(Y(3,:), height, width);
% %
t_img(:,:,1) = Y1;
t_img(:,:,2) = Y2;
t_img(:,:,3) = Y3;
% 
% % imshow(t_img);
% 
% % % If im is your image
% % d=linspace(min(t_img(:)),max(t_img(:)),256);
% % im1=uint8(arrayfun(@(x) find(abs(d(:)-x)==min(abs(d(:)-x))),t_img));
% % imshow(im1);
% 
% 
image8Bit = uint8(255 * mat2gray(t_img));
imshow(image8Bit);
%
% I = imread('2.jpg');
% figure
% imshow(I)
% a = zeros(size(I),'uint8'); % Or, a = zeros(size(I),class(I));
% a(:,:,1) = I(:,:,1);
% a(:,:,2) = I(:,:,2);
% a(:,:,3) = I(:,:,3);

%%
% [rows, columns, numberOfColorBands] = size(RGB_Image_Norm_Resized);
% % Call rgb2ind
% [indexedImage, customizedColorMap] = rgb2ind(RGB_Image_Norm_Resized,numberOfColorBands);
% imshow(indexedImage, []);

%%
% figure;
% subplot(1,3,1), imshow(Y1,[]);
% subplot(1,3,2), imshow(Y2,[]);
% subplot(1,3,3), imshow(Y3,[]);

