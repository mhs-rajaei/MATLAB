clear all
close all
%% Read Images & Targets & etc
Data = Load_Image('F:\Documents\MATLAB\Data\Pet Images',20,224,224,'true','false');
%% Runing PCA...
train_index  = size(Data.training_images,4);
for i=1:train_index
    %% number of feature that we want extract from all features
    K = 20;
    %%
    %convet RGB to Grayscale
    image = rgb2gray(Data.training_images(:,:,:,i));
    %% we can use sum of all chaneels instead of rgb2gray
    %     w1 = 0.299;
    %     w2 = 0.587;
    %     w3 = 0.114;
    %     Red =   Data.training_images(:,:,1,i);
    %     Green = Data.training_images(:,:,2,i);
    %     Blue =  Data.training_images(:,:,3,i);
    %     I = w1*Red + w2*Green + w3*Blue;
    %%  caculte PCA eigvector and eigvalue
    [ Data.eigvector{i} ,  Data.eigvalue{i}] = PCA_(image, K);
    %% feature reduction
    Data.Ytrn{i} = image * Data.eigvector{i};
    % Recover feature reduction Image
    %     t_img  =  Data.Ytrn{i} * Data.eigvector{i}';
    
    % Display original image
    %             subplot(1, 2, 1);
    %             imshow(image);
    %             title('Original');
    %             axis square;
    %             pause;
    %             close all;
    
    % Display reconstructed image from only F eigenfaces
    %             subplot(1, 2, 2);
    %             imshow(t_img);
    %             title('Recovered');
    %             axis square;
    %             pause;
    %             close all;
    %
end

%% Set Target and vectorization
[tr,tc] = size(Data.eigvector{1});
[tr,tc] = size(Data.Ytrn{1});
training_inputs = zeros(train_index,(tr*tc));
% training input vectorization
for i=1:train_index
    training_inputs(i,:) = reshape(Data.Ytrn{i},[1,(tr*tc)]);
end

%% Test Data
% Exact opreation on Test Data

%extract features
tese_index= size(Data.test_images,4);
for i=1:tese_index
    timage = rgb2gray(Data.test_images(:,:,:,i));
    [ Data.t_eigvector{i} ,  Data.t_eigvalue{i}] = PCA_(timage, K);
    %feature reduction
    Data.t_Ytrn{i} = timage * Data.t_eigvector{i};
end

[tr,tc] = size(Data.t_Ytrn{1});
test_inputs = zeros((tese_index),(tr*tc));
% test input vectorization
for i=1:tese_index
    test_inputs(i,:) = reshape(Data.t_Ytrn{i},[1,(tr*tc)]);
end

%% Learning MLP with PCA feature
MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
    Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);

%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = Data.zero_one_training_Labels ;
% % MLP;
% nptr;
