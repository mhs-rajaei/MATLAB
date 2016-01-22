%%
images = loadMNISTImages('Data\train-images-idx3-ubyte\train-images.idx3-ubyte');
labels = loadMNISTLabels('Data\train-labels-idx1-ubyte\train-labels.idx1-ubyte');
%figure;display_network(images(:,1:100)); % Show the first 100 images
timages = loadMNISTImages('Data\t10k-images-idx3-ubyte\t10k-images.idx3-ubyte');
tlabels = loadMNISTLabels('Data\t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte');
%figure(2);display_network(timages(:,1:100)); % Show the first 100 images

IND=load('Data\Validation_index.mat');
IND=IND.IND;
IND=sort(IND);
%%


