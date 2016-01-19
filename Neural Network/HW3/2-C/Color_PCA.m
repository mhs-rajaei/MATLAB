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
    Data.target{i} = Data.train_image{i+size(Data.train_image)};
    %number of feature that we want to select
    F = 25;
    
    %claculte PCA eigvector and eigvalue for all chanels
    [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = PCA_(Red, F);
    [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = PCA_(Green, F);
    [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = PCA_(Blue, F);
    
    t_img(:,:,1) = Red;
    t_img(:,:,2) = Green;
    t_img(:,:,3) = Blue;
    Original_Image = uint8(255 * mat2gray(t_img));
    
    %red chanel feature reduction
    Data.Ytrn_red{i} = Red * Data.red_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.Ytrn_red{i} * Data.red_eigvector{i}';
    
    %green chanel feature reduction
    Data.Ytrn_green{i} = Red * Data.green_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.Ytrn_green{i} * Data.red_eigvector{i}';
    
    %blue chanel feature reduction
    Data.Ytrn_blue{i} = Red * Data.blue_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.Ytrn_blue{i} * Data.blue_eigvector{i}';
    
    recover_image = uint8(255 * mat2gray(t_img));
    
    %     % Display normalized data
    %     subplot(1, 2, 1);
    %     % displayData(Red);
    %     imshow(Original_Image);
    %     title('Original');
    %     axis square;
    %
    %     % Display reconstructed data from only k eigenfaces
    %     subplot(1, 2, 2);
    %     % displayData(X_rec);
    %     imshow(recover_image);
    %     title('Recovered');
    %     axis square;
    %
    %     pause;
    %     close all;
end

[~ , a]=size(Data.target);
[tr,tc] = size(Data.Ytrn_red{i});
Input = zeros(a,(tr*tc));
Target = zeros(a,1);

for i=1:a
    Input(i,:) = reshape(Data.Ytrn_red{i},[1,(tr*tc)]);
    red_Input = Data.Ytrn_red{i};
    if strcmpi(Data.target{i},'civil')
        Target(i,1) = 1;
    else
        Target(i,1) = 0;
    end
end

% MLP;

