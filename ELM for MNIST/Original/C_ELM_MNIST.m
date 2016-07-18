clear all;tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This C-ELM code achieves the following:
%-if M = 1600, an error rate on MNIST of about 97% correct on test data in about 15 seconds (on a four core computer using multithreading)

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

%train the C-ELM with data X and labels Y

%Get the Constrained weights
L = size(X,1);
biases = zeros(M,1);
W_randoms = zeros(M,L);
for i = 1:M
    Norm = 0;
    Inds = ones(2,1);
    while labels(Inds(1)) == labels(Inds(2)) ||  Norm < eps
        Inds = randperm(length(labels),2);
        Wrow = X(:,Inds(1))-X(:,Inds(2));
        Norm  = sqrt(sum(Wrow.^2));
    end
    W_randoms(i,:) = Wrow/Norm;
    biases(i) = 0.5*(X(:,Inds(1))+X(:,Inds(2)))'*Wrow/Norm;
end
W_randoms = Scaling*W_randoms; %scale the weights (already normalised)

%to implement biases, set an extra input dimension to 1, and put the biases in the input weights matrix
X = [X;ones(1,length(labels))];
X_test = [X_test;ones(1,length(labels_test))];
W_randoms = [W_randoms biases];

%train the ELM
A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
[MaxVal,ClassificationID_train] = max(W_outputs*A); %get output layer response and then classify it
PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate
toc
