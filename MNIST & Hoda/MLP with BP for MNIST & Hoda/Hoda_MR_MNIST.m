clear all;
clc;

% load Hoda data set
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_training_images(60000).mat');
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_remaining_images(22352).mat');
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_test_images(20000).mat');

% training data
trainig_inputs = reshape(training_images,[32*32,60000]);
number_of_training_samples = 60000;
number_of_input_neurons = 32*32;
% test data
test_inputs = reshape(test_images,[32*32,20000]);

% validation data
% tmp = zeros(32,32,10000);
tmp = remaining_images(:,:,1:10000);
validation_images = reshape(tmp,[32*32,10000]);
validation_labels = remaining_labels(1:10000);

% call the MR MNIST
MR_MLP(number_of_training_samples,number_of_input_neurons,trainig_inputs,...
    training_labels,test_inputs,test_labels,validation_images,validation_labels);



% 
% %% test some pictures
% 
% 
% 
% 
% test_image = uint8(zeros(32,32));
% last_test_image = transpose(test_image);
% 
% 
% %read live image from your PC
% imfile = 'E:\Desktop\7.png'; target_22 = 7;
% im = double(rgb2gray(imread(imfile))); % double and convert to grayscale
% im = imresize(im,[32,32]);  % change to 32 by 32 dimension
% im = im(:); % unroll matrix to vector
% im = im./max(im); 
% 
% % load('E:\Desktop\number2.mat');
% % load('E:\Desktop\x.mat');
% load('F:\Documents\MATLAB\Machine Learning\MR  ML Project\results\98.17 accuracy.mat');
% % layer(1).a=reshape(x,[784 1]);
% layer(1).a = im;
% answer=0;
%     for c=2:L
%         if c==2
%             layer(c).z = (layer(c-1).a(:,1))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
%         else
%             layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
%         end
%         if tanh_or_sigmoid==1 %tanh
%             layer(c).a = tanh(layer(c).z);
%         else %sigmoid
%             layer(c).a = sigmoid(layer(c).z);
%         end
%     end
%     test = Max_Rand_Activation(layer(L).a,layer(L).Size,target_22);
%     answer = test;
%     fprintf(num2str(answer));
% 
% 
% 
%     
%     
%     
%     
%     