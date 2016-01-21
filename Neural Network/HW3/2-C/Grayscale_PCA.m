clear all
close all
%% Read Images & Targets & etc
Data = IO();

cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';

[index , ~] = size(Data.train_image);
for i=1:index
    %% number of feature that we want extract from all features
    K = 50;
    % convet RGB to Grayscale
    image = rgb2gray(Data.train_image{i});
    Data.target{i} = Data.train_image{i+size(Data.train_image)};
    %%  caculte PCA eigvector and eigvalue
    [ Data.eigvector{i} ,  Data.eigvalue{i}] = PCA_(image, K);
    %% feature reduction
    Data.Ytrn{i} = image * Data.eigvector{i};
    
    % Recover feature reduction Image
    t_img  =  Data.Ytrn{i} * Data.eigvector{i}';
    
%             % Display original image
%             subplot(1, 2, 1);
%             imshow(image);
%             title('Original');
%             axis square;
%     
%             Display reconstructed image from only F eigenfaces
%             subplot(1, 2, 2);
%             imshow(t_img);
%             title('Recovered');
%             axis square;
%             pause;
%             close all;
    
end

%% Set Target and vectorization
[~ , a]=size(Data.target);
% [tr,tc] = size(Data.eigvector{1});
[tr,tc] = size(Data.Ytrn{1});
inputs = zeros(a,(tr*tc));

feature_target = zeros(a,1);
for i=1:a
    %     inputs(i,:) = reshape(Data.eigvector{i},[1,(tr*tc)]);
    inputs(i,:) = reshape(Data.Ytrn{i},[1,(tr*tc)]);
    
    if strcmpi(Data.target{i},'civil')
        feature_target(i,1) = 0;
    else
        feature_target(i,1) = 1;
    end
    
end

%% Test Data
%% Exact opreation on Test Data
[index , ~] = size(Data.test_image);
for i=1:index
    timage = rgb2gray(Data.test_image{i});
    Data.t_target{i} = Data.test_image{i+size(Data.test_image)};
    [ Data.t_eigvector{i} ,  Data.t_eigvalue{i}] = PCA_(timage, K);
    %feature reduction
    Data.t_Ytrn{i} = timage * Data.t_eigvector{i};
end

[~ , a]=size(Data.t_target);
% [tr,tc] = size(Data.t_eigvector{1});
[tr,tc] = size(Data.t_Ytrn{1});
t_inputs = zeros((a),(tr*tc));

t_feature_target = zeros((a),1);

for i=1:a
    %     t_inputs(i,:) = reshape(Data.t_eigvector{i},[1,(tr*tc)]);
    t_inputs(i,:) = reshape(Data.t_Ytrn{i},[1,(tr*tc)]);
    if strcmpi(Data.t_target{i},'civil')
        t_feature_target(i,1) = 0;
    else
        t_feature_target(i,1) = 1;
    end
    
end
Color_Gray = 0;
MR_MLP;

%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = feature_target ;
% % MLP;
% nptr;
