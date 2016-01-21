clear all
close all
%%
%% Read Images & Targets & etc
Data = IO();

cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';

[index , ~] = size(Data.train_image);
for i=1:index
    %% Channel separation
    Red = Data.train_image{i}(:,:,1);
    Green =  Data.train_image{i}(:,:,2);
    Blue = Data.train_image{i}(:,:,3);
    Data.target{i} = Data.train_image{i+size(Data.train_image)};
    
    %% Number of feature that we want to extract
    F = 10;
    
    %% Claculte PCA eigvector and eigvalue for all channels
    [ Data.red_eigvector{i} ,  Data.red_eigvalue{i}] = PCA_(Red, F);
    [ Data.blue_eigvector{i} ,  Data.blue_eigvalue{i}] = PCA_(Green, F);
    [ Data.green_eigvector{i} ,  Data.green_eigvalue{i}] = PCA_(Blue, F);
    %% Reconstruction of the original image form Red, Green & Blue channel
    t_img(:,:,1) = Red;
    t_img(:,:,2) = Green;
    t_img(:,:,3) = Blue;
    % Combining Channels
    Original_Image = uint8(255 * mat2gray(t_img));
    %% Feature Reduction
    % Red channel feature reduction
    Data.Ytrn_red{i} = (Red * Data.red_eigvector{i})';
    %recover channel
    t_img(:,:,1)  =  Data.Ytrn_red{i}' * Data.red_eigvector{i}';
    
    %green channel feature reduction
    Data.Ytrn_green{i} = (Green * Data.green_eigvector{i})';
    %recover channel
    t_img(:,:,1)  =  Data.Ytrn_green{i}' * Data.green_eigvector{i}';
    
    %blue channel feature reduction
    Data.Ytrn_blue{i} = (Blue * Data.blue_eigvector{i})';
    %recover channel
    t_img(:,:,1)  =  Data.Ytrn_blue{i}' * Data.blue_eigvector{i}';
    % Recover feature reduction Image
    recover_image = uint8(255 * mat2gray(t_img));
     
%         % Display original image
%         subplot(1, 2, 1);
%         imshow(Original_Image);
%         title('Original');
%         axis square;
%     
%         % Display reconstructed image from only F eigenfaces
%         subplot(1, 2, 2);
%         imshow(recover_image);
%         title('Recovered');
%         axis square;
%         pause;
%         close all;
end


% 
% Data.Ytrn_red = Data.Ytrn_red';
% 
% Data.Ytrn_green = Data.Ytrn_green;
% 
% 
% Data.Ytrn_blue = Data.Ytrn_blue';

 








%% Set Target and vectorization
[~ , a]=size(Data.target);
[tr,tc] = size(Data.Ytrn_red{1});
red_inputs = zeros(a,(tr*tc));
green_inputs = zeros(a,(tr*tc));
blue_inputs = zeros(a,(tr*tc));

feature_target = zeros(a,1);

for i=1:a
    
%     red_inputs(i,:) = reshape(Data.red_eigvector{i},[1,(tr*tc)]);
%     green_inputs(i,:) = reshape(Data.green_eigvector{i},[1,(tr*tc)]);
%     blue_inputs(i,:) = reshape(Data.blue_eigvector{i},[1,(tr*tc)]);
    red_inputs(i,:) = reshape(Data.Ytrn_red{i},[1,(tr*tc)]);
    green_inputs(i,:) = reshape(Data.Ytrn_green{i},[1,(tr*tc)]);
    blue_inputs(i,:) = reshape(Data.Ytrn_blue{i},[1,(tr*tc)]);
    
    if strcmpi(Data.target{i},'civil')
        feature_target(i,1) = 0;
    else
        feature_target(i,1) = 1;
    end
    
end

%% Exact opreation on Test Data
[index , ~] = size(Data.test_image);
for i=1:index
    Red =Data.test_image{i}(:,:,1);
    Green =  Data.test_image{i}(:,:,2);
    Blue = Data.test_image{i}(:,:,3);
    Data.t_target{i} = Data.test_image{i+size(Data.test_image)};
    %claculte PCA eigvector and eigvalue for all channels
    [ Data.tred_eigvector{i} ,  Data.tred_eigvalue{i}] = PCA_(Red, F);
    [ Data.tblue_eigvector{i} ,  Data.tblue_eigvalue{i}] = PCA_(Green, F);
    [ Data.tgreen_eigvector{i} ,  Data.tgreen_eigvalue{i}] = PCA_(Blue, F);
  
    %red channel feature reduction
    Data.tYtrn_red{i} = (Red * Data.tred_eigvector{i})';

    %green channel feature reduction
    Data.tYtrn_green{i} = (Green * Data.tgreen_eigvector{i})';

    %blue channel feature reduction
    Data.tYtrn_blue{i} = (Blue * Data.tblue_eigvector{i})';
 
end

% Set Target and vectorization
[~ , a]=size(Data.t_target);
[tr,tc] = size(Data.tYtrn_blue{1});
tred_inputs = zeros((a),(tr*tc));
tgreen_inputs = zeros((a),(tr*tc));
tblue_inputs = zeros((a),(tr*tc));

t_feature_target = zeros((a),1);

for i=1:a
%     tred_inputs(i,:) = reshape(Data.tred_eigvector{i},[1,(tr*tc)]);
%     tgreen_inputs(i,:) = reshape(Data.tgreen_eigvector{i},[1,(tr*tc)]);
%     tblue_inputs(i,:) = reshape(Data.tblue_eigvector{i},[1,(tr*tc)]);
    tred_inputs(i,:) = reshape(Data.tYtrn_red{i},[1,(tr*tc)]);
    tgreen_inputs(i,:) = reshape(Data.tYtrn_green{i},[1,(tr*tc)]);
    tblue_inputs(i,:) = reshape(Data.tYtrn_blue{i},[1,(tr*tc)]);
    
    if strcmpi(Data.t_target{i},'civil')
        t_feature_target(i,1) = 0;
    else
        t_feature_target(i,1) = 1;
    end
    
end

%% Set inputs for MLP
t_inputs = [tred_inputs , tgreen_inputs , tblue_inputs];
inputs = [red_inputs , green_inputs , blue_inputs];

% t_inputs = [tred_inputs' , tgreen_inputs' , tblue_inputs'];
% inputs = [red_inputs' , green_inputs' , blue_inputs'];
t_feature_target = t_feature_target';
feature_target = feature_target';

%% Learning MLP with PCA feature
Color_Gray = 1;
MR_MLP;
