% clc
clear
close all;
vl_setupnn;
% load the pre-trained CNN
cnnModel.net = load('F:\Documents\MATLAB\Data\imagenet-vgg-f.mat');
%% Load data from folder
% Use imageSet to load images stored in pet_images folder
% imset = imageSet('F:\Documents\MATLAB\Neural Network\HW3\Google Net\Data\Images','recursive');
% imset = imageSet('F:\Documents\MATLAB\Neural Network\HW3\Google Net\Data\Airplane Images','recursive');
% imset = imageSet('F:\Documents\MATLAB\Data\Pet Images','recursive');
Data = IO('F:\Documents\MATLAB\Data\Pet Images',20,224,224,'true','false');
% IO(path,percent_of_test_data,hight,width,zero_one,original)
% % Load and resize images for prediction
% counter = 0;
% [~,im_size] = size(imset);
% for j=1:im_size
%   for i = 1:imset(j).Count
%       counter = counter +1; 
%       images{counter} = read(imset(j),i);%real size
%       images2(counter).contain= imresize(read(imset(j),i),[224,224]); %resize size(fixd size)
%   end
% end

% %% Get the image labels
% Labels = getImageLabels(imset);
% summary(Labels) % Display class label distribution
% 
% 
% %% shuffeing images
% min_idx=1;
% max_idx=counter;
% idx = randperm(max_idx-min_idx+1,40);
% % Preallocate arrays with fixed size
% [im_hight,im_width,im_depth] = size(images2(1).contain);
% images_matrix = zeros(im_hight,im_width,im_depth,counter);
% % images_matrix = zeros([im_hight,im_width,im_depth,counter],'single');
% for i=min_idx:max_idx
% 
%     myImg = im2double(images2(i).contain);
%     %     myImgNorm = featureNormalize(myImg);
%     % Normalize the Image:
%     myRange = getrangefromclass(myImg(1));
%     newMax = myRange(2);
%     newMin = myRange(1);
%     myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
%     images_matrix(:,:,:,i) = im2double(myImgNorm);
% end
% %shuffle test data's
% % training images and test images sepration
% test_images = images_matrix(:,:,:,idx);
% images_matrix(:,:,:,idx) = [];
% training_images = images_matrix;
% % training labels and test labels sepration
% test_Labels = Labels(idx,1);
% Labels(idx,:) = [];
% training_Labels= Labels;
% 
% %shuffle tarin data's
% [label_marix_size,~] = size(training_Labels)
% min_idx=1;
% max_idx=label_marix_size;
% idx = randperm(max_idx-min_idx+1,label_marix_size);
% 
% training_images = training_images(:,:,:,idx);
% training_Labels = training_Labels(idx,:);
% % %  Display  image and correpondig lable for it
% % for i=1:label_marix_size
% %             imshow( training_images(:,:,:,i));
% %             title(char(training_Labels(i)));
% %             pause;
% %             close all;
% % end

%%

cnnModel.net.layers = cnnModel.net.layers(1:end-1);
cnnModel.info.opts.batchSize = 10;
training_cnnFeatures = cnnPredict(cnnModel,Data.training_images);
test_cnnFeatures = cnnPredict(cnnModel,Data.test_images);

% training_target = zeros(label_marix_size,1);
% for i=1:label_marix_size
%     if strcmpi(char(training_Labels(i)),'0')
%         training_target(i,1) = 0;
%     else
%         training_target(i,1) = 1;
%     end
% end

% [test_label_marix_size,~] = size(test_Labels);
% test_target = zeros(test_label_marix_size,1);
% for i=1:test_label_marix_size
%     if strcmpi(char(test_Labels(i)),'0')
%         test_target(i,1) = 0;
%     else
%         test_target(i,1) = 1;
%     end
% end

% %% feature normalozation
% for i=1:label_marix_size
%     newMax = 1;
%     newMin = 0;
%     myImgNorm = (cnnFeatures(i,:) - min(cnnFeatures(i,:)))*...
%         (newMax - newMin)/(max(cnnFeatures(i,:)) - min(cnnFeatures(i,:))) + newMin;
%     cnnFeatures(i,:) = myImgNorm;
% end
% 
% for i=1:test_label_marix_size
% 
% 
%     newMax = 1;
%     newMin = -1;
%     myImgNorm = (t_cnnFeatures(i,:) - min(t_cnnFeatures(i,:)))*...
%         (newMax - newMin)/(max(t_cnnFeatures(i,:)) - min(t_cnnFeatures(i,:))) + newMin;
%     t_cnnFeatures(i,:) = myImgNorm;
% end

%% Set inputs for MLP
test_inputs = test_cnnFeatures;
training_inputs = training_cnnFeatures;

% test_feature_target = Data.zero_one_testing_Labels;
% feature_target = Data.zero_one_training_Labels;




%% Learning MLP with Googl net feature
google_net = 1;
MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
    Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);
% function MR_MLP(number_of_training_samples,number_of_input_neurons,trainig_inputs,...
%     training_labels,test_inputs,test_labels)


%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = feature_target ;
% MLP;
% nptr;
