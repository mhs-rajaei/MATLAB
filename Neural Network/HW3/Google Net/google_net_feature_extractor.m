clear
close all;
vl_setupnn;
% load the pre-trained CNN
cnnModel.net = load('F:\Documents\MATLAB\Data\imagenet-vgg-f.mat');
%% Load data
Data = Load_Image('F:\Documents\MATLAB\Data\Pet Images',20,224,224,'true','false');
% IO(path,percent_of_test_data,hight,width,zero_one,original)

%% Freature extraction...
% cnnModel.net.layers = cnnModel.net.layers(1:end-1);
cnnModel.info.opts.batchSize = 50;
training_cnnFeatures = cnnPredict(cnnModel,Data.training_images);
test_cnnFeatures = cnnPredict(cnnModel,Data.test_images);

%% Set inputs for MLP
test_inputs = test_cnnFeatures;
training_inputs = training_cnnFeatures;

%% Learning MR_MLP with Googl net feature
MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
    Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);

%% Learning with original image...
% [dim1,dim2,dim3,dim4]=size(Data.training_images);
% for i=1:dim4
%     training_inputs(i,:) = reshape(Data.training_images(:,:,:,i),[1,(dim1*dim2*dim3)]);
% end
% 
% [dim1,dim2,dim3,dim4]=size(Data.test_images);
% for i=1:dim4
%     test_inputs(i,:) = reshape(Data.test_images(:,:,:,i),[1,(dim1*dim2*dim3)]);
% end
% 
% MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
%     Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);

%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = feature_target ;
% MLP;
% nptr;
