clear
close all;
vl_setupnn;
% load the pre-trained CNN
cnnModel.net = load('F:\Documents\MATLAB\Data\imagenet-vgg-f.mat');
%% Load data
Data = IO('F:\Documents\MATLAB\Data\Pet Images',20,224,224,'true','false');
% IO(path,percent_of_test_data,hight,width,zero_one,original)

%% Freature extraction...
cnnModel.net.layers = cnnModel.net.layers(1:end-1);
cnnModel.info.opts.batchSize = 10;
training_cnnFeatures = cnnPredict(cnnModel,Data.training_images);
test_cnnFeatures = cnnPredict(cnnModel,Data.test_images);

%% Set inputs for MLP
test_inputs = test_cnnFeatures;
training_inputs = training_cnnFeatures;

%% Learning MR_MLP with Googl net feature
google_net = 1;
MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
    Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);

%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = feature_target ;
% MLP;
% nptr;
