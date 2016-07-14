clear all;tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code trains an ELM in just four lines of matlab code. It can achieve the following performance:
%-if M = 1600, an error rate on MNIST of 94.5% correct on test data in about 14 seconds (on a four core computer using multithreading)
%-if M = 8000, an error rate on MNIST of 97.3% in about 3 minutes

%Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: January 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1412.8307

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get training and test data; data files can be obtained from http://yann.lecun.com/exdb/mnist/
X = loadMNISTImages('train-images-idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
X_test = loadMNISTImages('t10k-images-idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels = loadMNISTLabels('train-labels-idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels_test = loadMNISTLabels('t10k-labels-idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip

%set up the ELM:

%create a target matrix using the training class labels
NumClasses = 10;
Y = zeros(length(labels),NumClasses);
for ii = 1:length(labels)
    Y(ii,labels(ii)+1) = 1;
end

%specify the hyperparameters:
M = 1600; %set the number of hidden layer neurons
Scaling = 2; %set the input weights scaling
RidgeParam = 1e-8; %set the ridge regression parameter

%train the ELM with data X and labels Y, using four lines of matlab code
W_randoms =  sign(randn(M,size(X,1))); %get bipolar random weights
W_randoms = Scaling*diag(1./sqrt(sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%validate with trained-on data, X
[MaxVal,ClassificationID_train] = max(W_outputs*A);%get output layer response and then classify it
PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate
toc
