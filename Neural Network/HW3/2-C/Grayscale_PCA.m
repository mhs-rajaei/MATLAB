clear all
close all

%%read images
Data = IO();
%%
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C';
%%extract chaneles and eigs
%seprate chanels
[index , ~] = size(Data.train_image);
for i=1:index
    image = rgb2gray(Data.train_image{i});
    Data.target{i} = Data.train_image{i+size(Data.train_image)};
    % caculte PCA eigvector and eigvalue for all chanels
%     [ Data.eigvector{i} ,  Data.eigvalue{i}] = pca(image);
 %number of feature that we want extract from all features
    K = 10;
    
    [ Data.eigvector{i} ,  Data.eigvalue{i}] = PCA_(image, K);
   
    %feature reduction
    Data.Ytrn{i} = projectData(image,  Data.eigvector{i}, K);
    %recover image
    t_img  = recoverData(Data.Ytrn{i}, Data.eigvector{i}, K);
% %     
%     % Display normalized data
%     subplot(1, 2, 1);
%     % displayData(Red);
%     imshow(image);
%     title('Original');
%     axis square;
%     
%     % Display reconstructed data from only k eigenfaces
%     subplot(1, 2, 2);
%     % displayData(X_rec);
%     imshow(t_img);
%     title('Recovered');
%     axis square;
%     
%     
%     pause;
%     close all;
end

[~ , a]=size(Data.target);
[tr,tc] = size(Data.eigvector{1});
inputs = zeros(a,(tr*tc));


feature_target = zeros(a,1);

for i=1:a
    inputs(i,:) = reshape(Data.eigvector{i},[1,(tr*tc)]);
    if strcmpi(Data.target{i},'civil')
        feature_target(i,1) = 0;
    else
        feature_target(i,1) = 1;
    end
    
end

%% Test Data
[index , ~] = size(Data.test_image);
for i=1:index
    timage = rgb2gray(Data.test_image{i});
    Data.t_target{i} = Data.test_image{i+size(Data.test_image)};

    % caculte PCA eigvector and eigvalue for all chanels
%     [ Data.t_eigvector{i} ,  Data.t_eigvalue{i}] = pca(timage);
    [ Data.t_eigvector{i} ,  Data.t_eigvalue{i}] = PCA_(timage, K);
    %number of feature that we want extract from all features

    %feature reduction
    Data.t_Ytrn{i} = projectData(timage, Data.t_eigvector{i}, K);

    %recover image
    t_img  = recoverData(Data.t_Ytrn{i}, Data.t_eigvector{i}, K);
% % %     
%     % Display normalized data
%     subplot(1, 2, 1);
%     % displayData(Red);
%     imshow(timage);
%     title('Original');
%     axis square;
%     
%     % Display reconstructed data from only k eigenfaces
%     subplot(1, 2, 2);
%     % displayData(X_rec);
%     imshow(t_img);
%     title('Recovered');
%     axis square;
% 
%     pause;
%     close all;

end

[~ , a]=size(Data.t_target);
[tr,tc] = size(Data.t_eigvector{1});
t_inputs = zeros((a),(tr*tc));

t_feature_target = zeros((a),1);

for i=1:a
    t_inputs(i,:) = reshape(Data.t_eigvector{i},[1,(tr*tc)]);
    if strcmpi(Data.t_target{i},'civil')
        t_feature_target(i,1) = 0;
    else
        t_feature_target(i,1) = 1;
    end
    
end
Color_Gray = 0;
MR_MLP;
% MLP_Inputs= [inputs];
% MLP;
% nptr;
