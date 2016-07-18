clear all;tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%this is an example script that applies an ELM-trained classifier to
%image features obtained using convolutional filtering

%Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: June 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1503.04596

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get training and test data; data files can be obtained from http://yann.lecun.com/exdb/mnist/
X = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\train-images-idx3-ubyte\train-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
X_test = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\t10k-images-idx3-ubyte\t10k-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\train-labels-idx1-ubyte\train-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels_test = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip

%create a target matrix using the training class labels
ImageSize = 28;
NumClasses = 10;
k_train = 60000;
k_test = 10000;
Y = zeros(length(labels),NumClasses);
for ii = 1:length(labels)
    Y(ii,labels(ii)+1) = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 1: set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set feature extraction hyperparameters:
WhichFiltersFlag = 1; %set to 1 for patches from training data, or to 2 for orthogonal random weights
W=7; %filter size
Q=8; %pooling size
PoolingStride = 6; %number of pixels between pooling points
NumOfEach = 4; %ensure number of filters is a multiple of the number of classes (for use with patch filters)
NumFilters = NumClasses*NumOfEach;

%set ELM hyperparameters
M=6400;  %number of hidden units

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 2: get filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if WhichFiltersFlag == 1
    Filters = zeros(NumFilters,W,W);
    Count = 1;
    for jj = 1:NumOfEach
        for ThisClass = 1:NumClasses
            ThisClass = find(labels==ThisClass-1);
            X0 = reshape(X(:,ThisClass(jj)),[ImageSize,ImageSize]); %get an image from class i
            X1 = X0(round((ImageSize-W)/2)+1:round((ImageSize-W)/2)+W,round((ImageSize-W)/2)+1:round((ImageSize-W)/2)+W); %extract a patch from the centre of the image
            Filters(Count,:,:) = X1-mean(X1(:));
            Count = Count + 1;
        end
    end
elseif WhichFiltersFlag == 2
    OrthRands = orth(randn(W^2,W^2));
    if NumFilters <= W^2
        Filters = reshape(OrthRands(1:NumFilters,:),[NumFilters,W,W]);
    else
        Filters(1:W^2,:) = OrthRands;
        Filters(W^2+1:NumFilters) = randn(NumFilters-W^2,W,W);
    end
end

toc 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 3: get Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PoolRows = [W+5:PoolingStride:ImageSize+Q-1-5]; %index into the full size: ImageSize+W+Q-2,ImageSize+W+Q-2
PoolColumns = [W+5:PoolingStride:ImageSize+Q-1-5];
PooledImageSize = length(PoolRows)

TotalFeatures = length(PoolRows)*length(PoolColumns)*NumFilters
A = GetFeaturesMatConv(PoolRows,PoolColumns,ImageSize,X,k_train,W,Q,Filters);clear X
A_test = GetFeaturesMatConv(PoolRows,PoolColumns,ImageSize,X_test,k_test,W,Q,Filters);clear X_test
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 4: train the ELM 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%begin by ensuring training data is in the interval [0,1] and boost the smaller values to help make more Gaussian
MaxA = max(max(A));
A = sqrt(A/MaxA);
A_test = sqrt(A_test/MaxA);

%train the ELM output layer
tic
[Y_predicted_train,W_randoms,W_outputs,A_ELM,ZZ,UU] = ConvELM_training(size(A,1),A,Y,k_train,labels,M);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 5: get classification on test data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A_test_ELM = (W_randoms*[A_test;ones(1,k_test)]).^2;

[MaxVal,ClassificationID_train] = max(Y_predicted_train); %get output layer response and then classify it
PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/k_train) %calculate the error rate
 
Y_predicted_test = W_outputs*A_test_ELM;
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get output layer response and then classify it
PercentCorrect_test = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/k_test)

