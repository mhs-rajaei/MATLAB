clear all
close all

%%read images
tr_class1=randperm(67,40);
tes_class1=1:67;
tes_class1(tr_class1)=[];
tr_class2=randperm(67,40);
tes_class2=1:67;
tes_class2(tr_class2)=[];
%read class1
cd 'F:\Documents\MATLAB\test\2_Class\Military'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);
myimages_class1={};
for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    B = rgb2gray(A);
    B=imresize(B,0.4,'nearest');
    %% normalize method 1
    myImg = im2double(B);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    myimages_class1{Q}=myImgNorm;
end
%read class2
cd 'F:\Documents\MATLAB\test\2_Class\Civil'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);
myimages_class2={};
for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    B = rgb2gray(A);
    B=imresize(B,0.4,'nearest');
    %% normalize method 1
    myImg = im2double(B);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    myimages_class2{Q}=myImgNorm;
end
%%
j=0;t1=0;t2=0;
for i=1:67
    if i~=tes_class1(:)
        j=j+1;
        imtr_class{j,1}=myimages_class1{i};
        imtr_class{j,2}='Military';
    else
        t1=t1+1;
        imte_class1{t1,1}=myimages_class1{i};
        imte_class1{t1,2}='Military';
    end
    %%
    if i~=tes_class2(:)
        j=j+1;
        imtr_class{j,1}=myimages_class2{i};
        imtr_class{j,2}='Civil';
    else
        t2=t2+1;
        imte_class2{t2,1}=myimages_class2{i};
        imte_class2{t2,2}='Civil';
    end
end
%%

RGB_Image = zeros(10);
%read image

RGB_Image = im2double(imread('1.jpg'));

% Normalize the Image:
% myRange = getrangefromclass(RGB_Image(1));
% newMax = myRange(2);
% newMin = myRange(1);
% RGB_Image_Norm = (RGB_Image - min(RGB_Image(:)))*(newMax - newMin)/(max(RGB_Image(:)) - min(RGB_Image(:))) + newMin;
% %resize image
% RGB_Image_Norm_Resized = imresize(RGB_Image_Norm, [240 240]) ;
% %seprate chanels
% Red = RGB_Image_Norm_Resized(:,:,1);
% Green = RGB_Image_Norm_Resized(:,:,2);
% Blue = RGB_Image_Norm_Resized(:,:,3);
%
% %show Red Chanel
% figure(10)
% imshow(Red);
% %claculte PCA eigvector and eigvalue for all chanels
% [red_eigvector , red_eigvalue] = PCA_(Red, 3);
% [blue_eigvector , blue_eigvalue] = PCA_(Blue, 3);
% [green_eigvector , green_eigvalue] = PCA_(Green, 3);
% %reshape Red matrix to the vector
% [height,width] = size(Red);
% red_im_vector = reshape(Red,[1,height*width]);
% blue_im_vector = reshape(Blue,[1,height*width]);
% green_im_vector = reshape(Blue,[1,height*width]);
%
