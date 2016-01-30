%%
images = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\train-images-idx3-ubyte\train-images.idx3-ubyte');
labels = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\train-labels-idx1-ubyte\train-labels.idx1-ubyte');
%figure;display_network(images(:,1:100)); % Show the first 100 images
timages = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\t10k-images-idx3-ubyte\t10k-images.idx3-ubyte');
tlabels = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte');
%figure(2);display_network(timages(:,1:100)); % Show the first 100 images

IND=load('F:\Documents\MATLAB\Data\MNIST\Validation_index.mat');
IND=IND.IND;
IND=sort(IND);
%%


