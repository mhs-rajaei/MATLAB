clear all;tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This RF-CIW-ELM code achieves the following:
%-if M = 1600, an error rate on MNIST of about 97.7% correct on test data in about 15 seconds (on a four core computer using multithreading)
%-if M = 8000, an error rate on MNIST of about 98.8-99.0% in about 3-4 minutes

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
MinMaskSize = 10; %parameter for the RF-ELM
RF_Border = 3; %parameter for RF-ELM

%train the RF-ELM with data X and labels Y

%get receptive field masks
L = size(X,1);
ReceptiveFields =  zeros(M,L);
ImageSize = sqrt(L); %assumes L is a square number, as is the case for MNIST
for ii = 1:M
    Mask = zeros(ImageSize,ImageSize);
    Inds1 = zeros(2,1);Inds2 = zeros(2,1);
    while (Inds1(2)-Inds1(1))*(Inds2(2)-Inds2(1)) < MinMaskSize
        Inds1 = RF_Border+sort(randperm(ImageSize-2*RF_Border,2));
        Inds2 = RF_Border+sort(randperm(ImageSize-2*RF_Border,2));        
    end
    Mask(Inds1(1):Inds1(2),Inds2(1):Inds2(2))=1;
    ReceptiveFields(ii,:) =  Mask(:);
end
%Get the Constrained weights
biases = zeros(M,1);
W_randoms = zeros(M,L);
for i = 1:M
    Norm = 0;
    Inds = ones(2,1);
    while labels(Inds(1)) == labels(Inds(2)) ||  Norm < eps
        Inds = randperm(length(labels),2);
        X_Diff = X(:,Inds(1))-X(:,Inds(2));
        Wrow = X_Diff.*ReceptiveFields(i,:)';
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
