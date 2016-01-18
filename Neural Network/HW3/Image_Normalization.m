clc;
clear all;
A = imread('2.jpg');%read image

% imshow(A); % display image

B = rgb2gray(A);% convet to grayscale

% imshow(B);

imwrite (B, 'image2.png');% write the image to disk
%% normalize method 1
myImg = im2double(A);
% Normalize the Image:
myRange = getrangefromclass(myImg(1));
newMax = myRange(2);
newMin = myRange(1);
myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;


%% normalize method 2

NB = im2double(B);
ff = NB/255;



%%

% Display the Image:
figure(42);
clf;

% Display the original:
subplot(2,3,1);
imagesc(myImg);
% set(gca, 'clim', [0,1]);;
title('(1) Original Image');
colorbar

% Display the normalized image method 1:
subplot(2,3,2);
imagesc(myImgNorm);
title('(3) Normalized Image method 1');
colorbar

% Display the normalized image method 2:
subplot(2,3,3);
imagesc(ff);
title('(5) Normalized Image method 2');
colorbar

% Display the hist of the original:
subplot(2,3,4);
hist(myImg(:))
title('(2) Histogram Of Original Image');
axis tight;

% Display the hist of the normalized image method 1:
subplot(2,3,5);
hist(myImgNorm(:))
title('(4) Histogram of Normalized Image method 1');
axis tight;

% Display the hist of the normalized image method 2:
subplot(2,3,6);
hist(ff(:))
title('(6) Histogram of Normalized Image method 2');
axis tight;
colormap gray

clc;






