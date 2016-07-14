clear all; tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%this is an example script that calls on a generic ELM training function.
%set Flags(1)=1 to use receptive fields and Flags(1)=0 otherwise
%set Flags(2)=1 for standard ELM
%set Flags(2)=2 for CIW-ELM
%set Flags(2)=3 for C-ELM
%set UseBackprop=1 to improve the input weights using backpropagation and UseBackprop=0 otherwise
 %Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: January 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1412.8307

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get training and test data; data files can be obtained from http://yann.lecun.com/exdb/mnist/
X = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\train-images-idx3-ubyte\train-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
X_test = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\t10k-images-idx3-ubyte\t10k-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\train-labels-idx1-ubyte\train-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels_test = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip

%set up the ELM:

%create a target matrix using the training class labels
NumClasses = 10;
Y = zeros(length(labels),NumClasses);
for ii = 1:length(labels)
    Y(ii,labels(ii)+1) = 1;
end

%set ELM hyperparameters
M = 1600; %number of hidden layer neurons
Scaling = 2; %scaling of input weights
RidgeParam = 1e-8; %ridge regression parameter

%set receptive field hyperparameters
MinMaskSize = 10; %parameter for  receptive fields
RF_Border = 3; %parameter for receptive fields
UseReceptiveFields = 1; %use receptive fields or not

%control choice of ELM
StandardELM = 1;
CIW_ELM = 2;
C_ELM = 3;

%specify RF-C-ELM mode
Flags = [UseReceptiveFields,C_ELM];

%training phase
L = size(X,1);
ImageSize = sqrt(L);

%train the ELM
tic
[PercentCorrect_train,Y_predicted_train,W_in,W_out,A] = ELM_training(Flags,L,ImageSize,X,Y,length(labels),labels,NumClasses,M,Scaling,RidgeParam,MinMaskSize,RF_Border);
toc

%output the number of training data points correctly classified following training
PercentCorrect_train

%test with unseen data, X_test
X_test = [X_test;ones(1,length(labels_test))]; %to implement possible non-zero biases, we set an extra input dimension to 1
Y_predicted_test = W_out*(1./(1+exp(-W_in*X_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect_test = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))

UseBackprop = 0;

if UseBackprop
    
    % do some iterations of backprop
    
    %hyperparameters:
    Epsilon = 0.001;
    NumIterations = 10;
    RidgeParam = 1e-2;
    
    %obtain revised weights
    tic
    X = [X;ones(1,length(labels))];
    [W_in,W_out,A] = ELM_backprop(NumIterations,Epsilon,X,Y,A,W_in,W_out,RidgeParam);
    toc
    
    Y_predicted_train = W_out*A;
    [MaxVal,ClassificationID_train] = max(Y_predicted_train);
    PercentCorrect_train_backprop = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels))
    
    Y_predicted_test = W_out*(1./(1+exp(-W_in*X_test)));
    [MaxVal,ClassificationID_test] = max(Y_predicted_test);
    PercentCorrect_test_backprop = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))
    
end
