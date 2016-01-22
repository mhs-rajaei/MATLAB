clear all
close all
%%
%% Read Images & Targets & etc
Data = Load_Image('F:\Documents\MATLAB\Neural Network\HW3\Data\Pet Images',...
    15,224,224,'true','true');

cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';

train_index  = size(Data.training_images,4);
for i=1:train_index
    %% Channel separation
    Red =   Data.training_images(:,:,1,i);
    Green = Data.training_images(:,:,2,i);
    Blue =  Data.training_images(:,:,3,i);
%     Data.target{i} = Data.training_images{i+size(Data.training_images)};
    
    %% Number of feature that we want to extract
    F = 5;
    
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
    %     imshow(Data.Ytrn_red{i});
    %     pause;
    %recover channel
    t_img(:,:,1)  =  Data.Ytrn_red{i}' * Data.red_eigvector{i}';
    
    %green channel feature reduction
    Data.Ytrn_green{i} = (Green * Data.green_eigvector{i})';
    %     imshow(Data.Ytrn_green{i});
    %     pause;
    %recover channel
    t_img(:,:,1)  =  Data.Ytrn_green{i}' * Data.green_eigvector{i}';
    
    %blue channel feature reduction
    Data.Ytrn_blue{i} = (Blue * Data.blue_eigvector{i})';
    %     imshow(Data.Ytrn_blue{i});
    %     pause;
    %recover channel
    t_img(:,:,1)  =  Data.Ytrn_blue{i}' * Data.blue_eigvector{i}';
    % Recover feature reduction Image
    recover_image = uint8(255 * mat2gray(t_img));
    
%             % Display original image
%             subplot(1, 2, 1);
%             imshow(Original_Image);
%             title('Original');
%             axis square;
%     
%             % Display reconstructed image from only F eigenfaces
%             subplot(1, 2, 2);
%             imshow(recover_image);
%             title('Recovered');
%             axis square;
%             pause;
%             close all;
end

%% Set Target and vectorization
train_index=size(Data.training_Labels,1);
[tr,tc] = size(Data.Ytrn_red{1});
training.red_inputs = zeros(train_index,(tr*tc));
training.green_inputs = zeros(train_index,(tr*tc));
training.blue_inputs = zeros(train_index,(tr*tc));

% feature_target = zeros(a,1);

for i=1:train_index
    
    %     red_inputs(i,:) = reshape(Data.red_eigvector{i},[1,(tr*tc)]);
    %     green_inputs(i,:) = reshape(Data.green_eigvector{i},[1,(tr*tc)]);
    %     blue_inputs(i,:) = reshape(Data.blue_eigvector{i},[1,(tr*tc)]);
    training.red_inputs(i,:) = reshape(Data.Ytrn_red{i},[1,(tr*tc)]);
    training.green_inputs(i,:) = reshape(Data.Ytrn_green{i},[1,(tr*tc)]);
    training.blue_inputs(i,:) = reshape(Data.Ytrn_blue{i},[1,(tr*tc)]);
%     
%     if strcmpi(Data.target{i},'0')
%         feature_target(i,1) = 0;
%     else
%         feature_target(i,1) = 1;
%     end
    
end

%% Exact opreation on Test Data
tese_index= size(Data.test_images,4);
for i=1:tese_index
    Red =Data.test_images(:,:,1,i);
    Green =  Data.test_images(:,:,2,i);
    Blue = Data.test_images(:,:,3,i);
%     Data.t_target{i} = Data.test_images{i+size(Data.test_images)};
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
% index =size(Data.test_Labels,1);
[tr,tc] = size(Data.tYtrn_blue{1});
test.red_inputs = zeros((tese_index),(tr*tc));
test.green_inputs = zeros((tese_index),(tr*tc));
test.blue_inputs = zeros((tese_index),(tr*tc));

% t_feature_target = zeros((a),1);

for i=1:tese_index
    %     tred_inputs(i,:) = reshape(Data.tred_eigvector{i},[1,(tr*tc)]);
    %     tgreen_inputs(i,:) = reshape(Data.tgreen_eigvector{i},[1,(tr*tc)]);
    %     tblue_inputs(i,:) = reshape(Data.tblue_eigvector{i},[1,(tr*tc)]);
    test.red_inputs(i,:) = reshape(Data.tYtrn_red{i},[1,(tr*tc)]);
    test.green_inputs(i,:) = reshape(Data.tYtrn_green{i},[1,(tr*tc)]);
    test.blue_inputs(i,:) = reshape(Data.tYtrn_blue{i},[1,(tr*tc)]);
    
%     if strcmpi(Data.t_target{i},'0')
%         t_feature_target(i,1) = 0;
%     else
%         t_feature_target(i,1) = 1;
%     end
%     
end

%% Set inputs for MLP
test_inputs = [test.red_inputs , test.green_inputs , test.blue_inputs];
training_inputs = [training.red_inputs , training.green_inputs , training.blue_inputs];
%     imshow(inputs);
%     pause;
% t_inputs = [tred_inputs' , tgreen_inputs' , tblue_inputs'];
% inputs = [red_inputs' , green_inputs' , blue_inputs'];

% t_feature_target = t_feature_target';
% feature_target = feature_target';

%% Learning MLP with PCA feature
% Color_Gray = 1;
% MR_MLP;
% MR_MLP(number_of_training_samples,number_of_input_neurons,inputs,...
%     training_labels,test_inputs,test_labels);
MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
    Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);



clear tr;clear tc;clear t_img;clear Original_Image;clear recover_image;
clear Red;clear Green;clear Blue;