clc
clear all
imfile = 'E:\Desktop\7.png'; target_22 = 9;
im = double(rgb2gray(imread(imfile))); % double and convert to grayscale
im = imresize(im,[28,28]);  % change to 20 by 20 dimension
im = im(:); % unroll matrix to vector
im = im./max(im); 

% load('E:\Desktop\number2.mat');
% load('E:\Desktop\x.mat');
load('F:\Documents\MATLAB\Machine Learning\MR  ML Project\results\98.17 accuracy.mat');
% layer(1).a=reshape(x,[784 1]);
layer(1).a = im;
answer=0;
    for c=2:L
        if c==2
            layer(c).z = (layer(c-1).a(:,1))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
        else
            layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
        end
        if tanh_or_sigmoid==1 %tanh
            layer(c).a = tanh(layer(c).z);
        else %sigmoid
            layer(c).a = sigmoid(layer(c).z);
        end
    end
    test = Max_Rand_Activation(layer(L).a,layer(L).Size,target_22);
    answer = test;
    fprintf(num2str(answer));



    
    
    
    
    
    
    
    
    
    
    
    
% 
% % image = imread('E:\Desktop\5-2.png');
% % imshow(image);title('original image');
% % pause;
% % image  = imresize(image,[28 28]);
% % imshow(image);title('resized image');
% % pause;
% % image = rgb2gray(image);
% % imshow(image);title('gray image');
% % pause;
% 
%  % Normalize the Image:
% %     Max_range = 1;
% %     Min_range = 0;
% %     nomalized_image = (image - min(image(:)))*...
% %         (Max_range - Min_range)/(max(image(:)) - min(image(:))) + Min_range;
% % imshow(nomalized_image);title('nomalized_image');
% % pause;
% 
% % image_divided_255 = nomalized_image/255;
% % imshow(image);title('/ 255 image');
% % n1 = reshape(image_divided_255,[784 1]);
% 
% % Convert to double and rescale to [0,1]
% % image2 = double(image) / 255;
% % n2 = reshape(image2,[784 1]);
% 
% % save(nomalized_image);
% % save(image);
% % save(image_divided_255);
% % save('E:\Desktop\number2.mat');




 