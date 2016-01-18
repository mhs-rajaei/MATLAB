clear all
close all

%%read images
Data = IO();
%%
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';
%%extract chaneles and eigs
%seprate chanels
for i=1:80
    image = rgb2gray(Data.train_image{i});

    % caculte PCA eigvector and eigvalue for all chanels
    [ Data.eigvector{i} ,  Data.eigvalue{i}] = pca(image);
    %number of feature that we want extract from all features
    K = 50;
    %feature reduction
    Z = projectData(image,  Data.eigvector{i}, K);
    %recover image
    t_img  = recoverData(Z, Data.eigvector{i}, K);
    
    % Display normalized data
    subplot(1, 2, 1);
    % displayData(Red);
    imshow(image);
    title('Original');
    axis square;
    
    % Display reconstructed data from only k eigenfaces
    subplot(1, 2, 2);
    % displayData(X_rec);
    imshow(t_img);
    title('Recovered');
    axis square;
    
    
    pause;
    close all;
end

