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
    
%     %claculte PCA eigvector and eigvalue for all chanels
    [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = PCA_(Red, 0);
    [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = PCA_(Green, 0);
    [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = PCA_(Blue, 0);
%     
    % caculte PCA eigvector and eigvalue for all chanels
%     [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = pca(Red);
%     [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = pca(Green);
%     [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = pca(Blue);
    
%     %feature extarction
%     Data.red_ytrn{i} = (Red*Data.red_eigvector{i} )';
%     Data.green_ytrn{i} = (Green*Data.green_eigvector{i} )';
%     Data.blue_ytrn{i} = (Blue*Data.blue_eigvector{i} )';
    
    K = 25;
    Z = zeros(size(Red, 1), K);
    
    t_img(:,:,1) = Red;
    t_img(:,:,2) = Green;
    t_img(:,:,3) = Blue;
    Original_Image = uint8(255 * mat2gray(t_img));
    
    
    %red chanel feature reduction
    Data.Ytrn_red{i} = Red * Data.red_eigvector{i}(:, 1:K);
    %recover chanel
    t_img(:,:,1)  =  Data.Ytrn_red{i} * Data.red_eigvector{i}(:, 1:K)';
    
    %green chanel feature reduction
    Data.Ytrn_green{i} = Red * Data.green_eigvector{i}(:, 1:K);
    %recover chanel
    t_img(:,:,1)  =  Data.Ytrn_green{i} * Data.red_eigvector{i}(:, 1:K)';
    
    %blue chanel feature reduction
    Data.Ytrn_blue{i} = Red * Data.blue_eigvector{i}(:, 1:K);
    %recover chanel
    t_img(:,:,1)  =  Data.Ytrn_blue{i} * Data.blue_eigvector{i}(:, 1:K)';
    
    recover_image = uint8(255 * mat2gray(t_img));
    % imshow(image8Bit);
    
    % Display normalized data
    subplot(1, 2, 1);
    % displayData(Red);
    imshow(Original_Image);
    title('Original');
    axis square;
    
    % Display reconstructed data from only k eigenfaces
    subplot(1, 2, 2);
    % displayData(X_rec);
    imshow(recover_image);
    title('Recovered');
    axis square;
    
    
    pause;
    close all;
end
%%
