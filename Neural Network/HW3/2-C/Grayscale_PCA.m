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
    [ Data.eigvector{i} ,  Data.eigvalue{i}] = pca(image);
    %number of feature that we want extract from all features
    K = 240;
    %feature reduction
    Data.Ytrn{i} = projectData(image,  Data.eigvector{i}, K);
    %recover image
    t_img  = recoverData(Data.Ytrn{i}, Data.eigvector{i}, K);
%     
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
[tr,tc] = size(Data.Ytrn{i});
inputs = zeros(a,(tr*tc));


Target = zeros(a,1);

for i=1:a
    inputs(i,:) = reshape(Data.Ytrn{i},[1,(tr*tc)]);
    if strcmpi(Data.target{i},'civil')
        Target(i,1) = 1;
    else
        Target(i,1) = 0;
    end
    
end
MLP_Inputs= [inputs];
MLP;
% nptr;
