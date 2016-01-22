clc
clear
close all;
%add pre MatConvNet setup
vl_setupnn;
% load the pre-trained CNN(regular CNN)
net = load('F:\Documents\MATLAB\Data\imagenet-vgg-f.mat');

% load and preprocess an image
im = imread('F:\Documents\MATLAB\Data\Pet Images\0\1 (19).jpg') ;
im_ = single(im) ; % note: 0-255 range
im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
im_ = im_ - net.normalization.averageImage ;
% run the CNN
res = vl_simplenn(net, im_) ;

% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores);
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s %s (%d), score %.3f',...
'imagenet-vgg-f.mat: ',net.classes.description{best}, best, bestScore)) ;
%%
clc;
% load the pre-trained CNN with 19 layer(verydeep)
net = load('F:\Documents\MATLAB\Data\imagenet-vgg-verydeep-19.mat');

% run the CNN
res = vl_simplenn(net, im_) ;

% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores);
figure(2) ; clf ; imagesc(im) ;
title(sprintf('%s %s (%d), score %.3f',...
'imagenet-vgg-verydeep-19.mat: ',net.meta.classes.description{best}, best, bestScore)) ;

