clear all
close all

%%read images
Data = IO();
%%
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';
%%extract chaneles and eigs
%seprate chanels
for i=1:80
    Red = Data.train_image{i}(:,:,1);
    Green =  Data.train_image{i}(:,:,2);
    Blue = Data.train_image{i}(:,:,3);
    
    %claculte PCA eigvector and eigvalue for all chanels
    [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = PCA_(Red, 25);
    [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = PCA_(Green, 25);
    [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = PCA_(Blue, 25);
    
    %feature extarction
    Data.red_ytrn{i} = (Red*Data.red_eigvector{i} )';
    Data.green_ytrn{i} = (Green*Data.green_eigvector{i} )';
    Data.blue_ytrn{i} = (Blue*Data.blue_eigvector{i} )';
    
    
    t_img(:,:,1) = Red;
t_img(:,:,2) = Green;
t_img(:,:,3) = Blue;
Original_Image = uint8(255 * mat2gray(t_img));

K = 25;
%red
Z = projectData(Red,  Data.red_eigvector{i}, K);
t_img(:,:,1)  = recoverData(Z, Data.red_eigvector{i}, K);
%green
Z = projectData(Green,  Data.green_eigvector{i}, K);
t_img(:,:,2) = recoverData(Z, Data.green_eigvector{i}, K);
%blue
Z = projectData(Blue,  Data.blue_eigvector{i}, K);
t_img(:,:,3)  = recoverData(Z, Data.blue_eigvector{i}, K);

recover_image = uint8(255 * mat2gray(t_img));
% imshow(image8Bit);

% Display normalized data
subplot(1, 2, 1);
% displayData(Red);
imshow(Original_Image);
title('Original faces');
axis square;

% Display reconstructed data from only k eigenfaces
subplot(1, 2, 2);
% displayData(X_rec);
imshow(recover_image);
title('Recovered faces');
axis square;


pause;
close all;
end
%%

% % Normalize the Image:
% myRange = getrangefromclass(RGB_Image(1));
% newMax = myRange(2);
% newMin = myRange(1);
% RGB_Image_Norm = (RGB_Image - min(RGB_Image(:)))*(newMax - newMin)/(max(RGB_Image(:)) - min(RGB_Image(:))) + newMin;
% %resize image
% RGB_Image_Norm_Resized = imresize(RGB_Image_Norm, [240 240]) ;

% %seprate chanels
%
% Red = RGB_Image_Norm_Resized(:,:,1);
% Green = RGB_Image_Norm_Resized(:,:,2);
% Blue = RGB_Image_Norm_Resized(:,:,3);
%
% %show Red Chanel
% figure(10)
% imshow(Red);
% %claculte PCA eigvector and eigvalue for all chanels
% [red_eigvector , red_eigvalue] = PCA_(Red, 3);
% [blue_eigvector , blue_eigvalue] = PCA_(Blue, 3);
% [green_eigvector , green_eigvalue] = PCA_(Green, 3);
% %reshape Red matrix to the vector
% [height,width] = size(Red);
% red_im_vector = reshape(Red,[1,height*width]);
% blue_im_vector = reshape(Blue,[1,height*width]);
% green_im_vector = reshape(Blue,[1,height*width]);

