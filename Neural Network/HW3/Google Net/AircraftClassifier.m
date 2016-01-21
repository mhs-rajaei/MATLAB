% clc
clear
close all;
vl_setupnn;
% load the pre-trained CNN
cnnModel.net = load('F:\Documents\MATLAB\Neural Network\HW3\Google Net\Data\imagenet-vgg-verydeep-19.mat');
% %% Load images from folder
% % Use imageSet to load images stored in pet_images folder
% imset = imageSet('F:\Documents\MATLAB\Neural Network\HW3\Google Net\Data\Images','recursive');
% 
% % Preallocate arrays with fixed size for prediction
% imageSize = cnnModel.net.normalization.imageSize;
% trainingImages = zeros([imageSize sum([imset(:).Count])],'single');
% 
% % Load and resize images for prediction
% counter = 0;
% for ii = 1:numel(imset)
%   for jj = 1:imset(ii).Count
%       counter = counter +1; 
%       trainingImages(:,:,:, counter) = imresize(single(read(imset(ii),jj)),imageSize(1:2));      
%   end
% end
% 
% % Get the image labels
% trainingLabels = getImageLabels(imset);
% summary(trainingLabels) % Display class label distribution




%% Load data from folder
% Use imageSet to load images stored in pet_images folder
imset = imageSet('F:\Documents\MATLAB\Neural Network\HW3\Google Net\Data\Images','recursive');



% Load and resize images for prediction
counter = 0;
[~,im_size] = size(imset);
for j=1:im_size
  for i = 1:imset(j).Count
      counter = counter +1; 
      images{counter} = read(imset(j),i);%real size
      images2(counter).contain= imresize(read(imset(j),i),[224,224]); %resize size(fixd size)
  end
end

%% Get the image labels
Labels = getImageLabels(imset);
summary(Labels) % Display class label distribution


%% shuffeing images
min_idx=1;
max_idx=counter;
idx = randperm(max_idx-min_idx+1,35);
% imshow(images2(1).contain);
% pause;
% Preallocate arrays with fixed size
[im_hight,im_width,im_depth] = size(images2(1).contain);
images_matrix = zeros(im_hight,im_width,im_depth,counter);
% images_matrix = zeros([im_hight,im_width,im_depth,counter],'single');
for i=min_idx:max_idx

    myImg = im2double(images2(i).contain);
    %     myImgNorm = featureNormalize(myImg);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    images_matrix(:,:,:,i) = im2double(myImgNorm);
end
% imshow(images_matrix(:,:,:,1));
% pause;
%shuffle test data's
% training images and test images sepration
test_images = images_matrix(:,:,:,idx);
images_matrix(:,:,:,idx) = [];
training_images = images_matrix;
% training labels and test labels sepration
test_Labels = Labels(idx,1);
Labels(idx,:) = [];
training_Labels= Labels;

%shuffle tarin data's
[label_marix_size,~] = size(training_Labels)
min_idx=1;
max_idx=label_marix_size;
idx = randperm(max_idx-min_idx+1,label_marix_size);

training_images = training_images(:,:,:,idx);
training_Labels = training_Labels(idx,:);
% %  Display  image and correpondig lable for it
% for i=1:label_marix_size
%             imshow( training_images(:,:,:,i));
%             title(char(training_Labels(i)));
%             pause;
%             close all;
% end

%%
cnnModel.info.opts.batchSize = 5;
cnnFeatures = cnnPredict(cnnModel,training_images);


training_target = zeros(label_marix_size,1);
for i=1:label_marix_size
    if strcmpi(char(training_Labels(i)),'cat')
        training_target(i,1) = 0;
    else
        training_target(i,1) = 1;
    end
end

[test_label_marix_size,~] = size(training_Labels);
test_target = zeros(test_label_marix_size,1);
for i=1:test_label_marix_size
    if strcmpi(char(training_Labels(i)),'cat')
        test_target(i,1) = 0;
    else
        test_target(i,1) = 1;
    end
end
%% Set inputs for MLP
t_cnnFeatures = cnnPredict(cnnModel,test_images);
t_inputs = t_cnnFeatures;
inputs = cnnFeatures;

t_feature_target = test_target;
feature_target = training_target;

%% Learning MLP with PCA feature

google_net = 1;
MR_MLP;


%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = feature_target ;
% MLP;
% nptr;

% %% Train a classifier using extracted features
% 
% % Here I train a linear support vector machine (SVM) classifier.
% svmmdl = fitcsvm(cnnFeatures,trainingLabels);
% 
% % Perform crossvalidation and check accuracy
% cvmdl = crossval(svmmdl,'KFold',10);
% fprintf('kFold CV accuracy: %2.2f\n',1-cvmdl.kfoldLoss)