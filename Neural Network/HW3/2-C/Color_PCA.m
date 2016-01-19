clear all
close all

%%read images
Data = IO();
%%
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';
%%extract chaneles and eigs
%seprate chanels
[index , ~] = size(Data.train_image);
for i=1:index
    Red = Data.train_image{i}(:,:,1);
    Green =  Data.train_image{i}(:,:,2);
    Blue = Data.train_image{i}(:,:,3);
    Data.target{i} = Data.train_image{i+size(Data.train_image)};
    %number of feature that we want to select
    F = 150;
    
    %claculte PCA eigvector and eigvalue for all chanels
    [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = PCA_(Red, F);
    [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = PCA_(Green, F);
    [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = PCA_(Blue, F);
    
    t_img(:,:,1) = Red;
    t_img(:,:,2) = Green;
    t_img(:,:,3) = Blue;
    Original_Image = uint8(255 * mat2gray(t_img));
%     
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
%      
%         % Display normalized data
%         subplot(1, 2, 1);
%         % displayData(Red);
%         imshow(Original_Image);
%         title('Original');
%         axis square;
%     
%         % Display reconstructed data from only k eigenfaces
%         subplot(1, 2, 2);
%         % displayData(X_rec);
%         imshow(recover_image);
%         title('Recovered');
%         axis square;
%     
%         pause;
%         close all;
end

[~ , a]=size(Data.target);
[tr,tc] = size(Data.Ytrn_red{i});
red_inputs = zeros(a,(tr*tc));
green_inputs = zeros(a,(tr*tc));
blue_inputs = zeros(a,(tr*tc));

Target = zeros(a,1);

for i=1:a
    
    red_inputs(i,:) = reshape(Data.Ytrn_red{i},[1,(tr*tc)]);
    green_inputs(i,:) = reshape(Data.Ytrn_green{i},[1,(tr*tc)]);
    blue_inputs(i,:) = reshape(Data.Ytrn_blue{i},[1,(tr*tc)]);
    if strcmpi(Data.target{i},'civil')
        Target(i,1) = 1;
    else
        Target(i,1) = 0;
    end
    
end
MLP_Inputs= [red_inputs , green_inputs , blue_inputs];

%% Test Samples Class 1
[index , ~] = size(Data.test_image_class1);
for i=1:index
    Red = Data.test_image_class1{i}(:,:,1);
    Green =  Data.test_image_class1{i}(:,:,2);
    Blue = Data.test_image_class1{i}(:,:,3);
%     Data.target{i} = Data.test_image_class1{i+size(Data.test_image_class1)};
    %number of feature that we want to select
    
    %claculte PCA eigvector and eigvalue for all chanels
    [ Data.tred_eigvector{i} ,  Data.tred_eigvalue{i}] = PCA_(Red, F);
    [ Data.tblue_eigvector{i} ,  Data.tblue_eigvalue{i}] = PCA_(Green, F);
    [ Data.tgreen_eigvector{i} ,  Data.tgreen_eigvalue{i}] = PCA_(Blue, F);
    
    t_img(:,:,1) = Red;
    t_img(:,:,2) = Green;
    t_img(:,:,3) = Blue;
    Original_Image = uint8(255 * mat2gray(t_img));
%     
    %red chanel feature reduction
    Data.tYtrn_red{i} = Red * Data.tred_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.tYtrn_red{i} * Data.tred_eigvector{i}';
    
    %green chanel feature reduction
    Data.tYtrn_green{i} = Red * Data.tgreen_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.tYtrn_green{i} * Data.tred_eigvector{i}';
    
    %blue chanel feature reduction
    Data.tYtrn_blue{i} = Red * Data.tblue_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.tYtrn_blue{i} * Data.tblue_eigvector{i}';
    
    recover_image = uint8(255 * mat2gray(t_img));
%      
%         % Display normalized data
%         subplot(1, 2, 1);
%         % displayData(Red);
%         imshow(Original_Image);
%         title('Original');
%         axis square;
%     
%         % Display reconstructed data from only k eigenfaces
%         subplot(1, 2, 2);
%         % displayData(X_rec);
%         imshow(recover_image);
%         title('Recovered');
%         axis square;
%     
%         pause;
%         close all;
end

% [~ , a]=size(Data.target);
[tr,tc] = size(Data.tYtrn_red{i});
tred_inputs = zeros(a,(tr*tc));
tgreen_inputs = zeros(a,(tr*tc));
tblue_inputs = zeros(a,(tr*tc));

% Target = zeros(a,1);

for i=1:index
    
    tred_inputs(i,:) = reshape(Data.tYtrn_red{i},[1,(tr*tc)]);
    tgreen_inputs(i,:) = reshape(Data.tYtrn_green{i},[1,(tr*tc)]);
    tblue_inputs(i,:) = reshape(Data.tYtrn_blue{i},[1,(tr*tc)]);
%     if strcmpi(Data.target{i},'civil')
%         Target(i,1) = 1;
%     else
%         Target(i,1) = 0;
%     end
    
end
tMLP_Inputs= [tred_inputs , tgreen_inputs , tblue_inputs];

%%
%% Test Samples Class 2
[index , ~] = size(Data.test_image_class2);
for i=1:index
    Red = Data.test_image_class2{i}(:,:,1);
    Green =  Data.test_image_class2{i}(:,:,2);
    Blue = Data.test_image_class2{i}(:,:,3);
%     Data.target{i} = Data.test_image_class1{i+size(Data.test_image_class1)};
    %number of feature that we want to select
    
    %claculte PCA eigvector and eigvalue for all chanels
    [ Data.t2red_eigvector{i} ,  Data.t2red_eigvalue{i}] = PCA_(Red, F);
    [ Data.t2blue_eigvector{i} ,  Data.t2blue_eigvalue{i}] = PCA_(Green, F);
    [ Data.t2green_eigvector{i} ,  Data.t2green_eigvalue{i}] = PCA_(Blue, F);
    
    t_img(:,:,1) = Red;
    t_img(:,:,2) = Green;
    t_img(:,:,3) = Blue;
    Original_Image = uint8(255 * mat2gray(t_img));
%     
    %red chanel feature reduction
    Data.t2Ytrn_red{i} = Red * Data.t2red_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.t2Ytrn_red{i} * Data.t2red_eigvector{i}';
    
    %green chanel feature reduction
    Data.t2Ytrn_green{i} = Red * Data.t2green_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.t2Ytrn_green{i} * Data.t2red_eigvector{i}';
    
    %blue chanel feature reduction
    Data.t2Ytrn_blue{i} = Red * Data.t2blue_eigvector{i};
    %recover chanel
    t_img(:,:,1)  =  Data.t2Ytrn_blue{i} * Data.t2blue_eigvector{i}';
    
    recover_image = uint8(255 * mat2gray(t_img));
%      
%         % Display normalized data
%         subplot(1, 2, 1);
%         % displayData(Red);
%         imshow(Original_Image);
%         title('Original');
%         axis square;
%     
%         % Display reconstructed data from only k eigenfaces
%         subplot(1, 2, 2);
%         % displayData(X_rec);
%         imshow(recover_image);
%         title('Recovered');
%         axis square;
%     
%         pause;
%         close all;
end

% [~ , a]=size(Data.target);
[tr,tc] = size(Data.t2Ytrn_red{i});
t2red_inputs = zeros(a,(tr*tc));
t2green_inputs = zeros(a,(tr*tc));
t2blue_inputs = zeros(a,(tr*tc));

% Target = zeros(a,1);

for i=1:index
    
    t2red_inputs(i,:) = reshape(Data.t2Ytrn_red{i},[1,(tr*tc)]);
    t2green_inputs(i,:) = reshape(Data.t2Ytrn_green{i},[1,(tr*tc)]);
    t2blue_inputs(i,:) = reshape(Data.t2Ytrn_blue{i},[1,(tr*tc)]);
%     if strcmpi(Data.target{i},'civil')
%         Target(i,1) = 1;
%     else
%         Target(i,1) = 0;
%     end
    
end
t2MLP_Inputs= [t2red_inputs , t2green_inputs , t2blue_inputs];

%%
MLP;

