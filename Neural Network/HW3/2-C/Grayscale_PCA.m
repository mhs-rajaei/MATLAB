clear all
close all
%% Read Images & Targets & etc
Data = Load_Image('F:\Documents\MATLAB\Data\Pet Images',20,224,224,'true','false');
train_index  = size(Data.training_images,4);
for i=1:train_index
    %% number of feature that we want extract from all features
    K = 20;
%     convet RGB to Grayscale
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
% %             title('Original');
% title(Data.zero_one_training_Labels(i,:));
%             axis square;
%             pause;
%             close all;
    
% % %             Display reconstructed image from only F eigenfaces
%             subplot(1, 2, 2);
%             imshow(t_img);
%             title('Recovered');
% % % % title(Data.zero_one_training_Labels(i,:));
%             axis square;
%             pause;
%             close all;
%     
end

%% Set Target and vectorization
% [~ , a]=size(Data.target);
[tr,tc] = size(Data.eigvector{1});
[tr,tc] = size(Data.Ytrn{1});
training_inputs = zeros(train_index,(tr*tc));
% 
% feature_target = zeros(a,1);
for i=1:train_index
%     %     inputs(i,:) = reshape(Data.eigvector{i},[1,(tr*tc)]);
    training_inputs(i,:) = reshape(Data.Ytrn{i},[1,(tr*tc)]);
%     
%     if strcmpi(Data.target{i},'0')
%         feature_target(i,1) = 0;
%     else
%         feature_target(i,1) = 1;
%     end
%     
end

%% Test Data
%% Exact opreation on Test Data
tese_index= size(Data.test_images,4);
for i=1:tese_index
    timage = rgb2gray(Data.test_images(:,:,:,i));
%     Data.t_target{i} = Data.test_image{i+size(Data.test_image)};
    [ Data.t_eigvector{i} ,  Data.t_eigvalue{i}] = PCA_(timage, K);
    %feature reduction
    Data.t_Ytrn{i} = timage * Data.t_eigvector{i};

% imshow(timage);
% %             title('Original');
% title(Data.zero_one_testing_Labels(i,:));
%             axis square;
%        pause;
%             close all;
end

% [~ , a]=size(Data.t_target);
% % [tr,tc] = size(Data.t_eigvector{1});
[tr,tc] = size(Data.t_Ytrn{1});
test_inputs = zeros((tese_index),(tr*tc));
% 
% t_feature_target = zeros((a),1);
% 
for i=1:tese_index
%     %     t_inputs(i,:) = reshape(Data.t_eigvector{i},[1,(tr*tc)]);
    test_inputs(i,:) = reshape(Data.t_Ytrn{i},[1,(tr*tc)]);
%     if strcmpi(Data.t_target{i},'0')
%         t_feature_target(i,1) = 0;
%     else
%         t_feature_target(i,1) = 1;
%     end
%     
end

%% Learning MLP with PCA feature
% Color_Gray = 1;
% MR_MLP;
% MR_MLP(number_of_training_samples,number_of_input_neurons,inputs,...
%     training_labels,test_inputs,test_labels);
MR_MLP(size(training_inputs,1),size(training_inputs,2),training_inputs',...
    Data.zero_one_training_Labels,test_inputs',Data.zero_one_testing_Labels);

% Color_Gray = 0;
% MR_MLP;

%% Train with NN toolbox in matlab if you want!
% MLP_Inputs= [inputs];
% Target = feature_target ;
% % MLP;
% nptr;
