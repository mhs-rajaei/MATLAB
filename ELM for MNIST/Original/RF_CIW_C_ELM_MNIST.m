clear all;tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This RF-CIW-ELM code achieves the following:
%-if M = 1600, an error rate on MNIST of about 98.3% correct on test data in about 30 seconds (on a four core computer using multithreading)
%-if M = 8000, an error rate on MNIST of about 99% in about 9 minutes

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

%specify the hyperparameters:
M = 8000; %set the number of hidden layer neurons
M2 = 500; %set the number of final layer ELM hidden neurons
Scaling = 2; %set the input weights scaling
RidgeParam = 1e-8; %set the ridge regression parameter
MinMaskSize = 10; %parameter for the RF-ELM
RF_Border = 3; %parameter for RF-ELM

%train the RF-ELM with data X and labels Y

NumEachClass = sum(Y);
M_CIWs = round(M*NumEachClass/length(labels));
M = sum(M_CIWs);

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

%get the CIW weights
W_randoms_CIW = zeros(M,L);
Count = 1;
for i = 1:NumClasses
    ClassIndices = find(labels==i-1);
    W_randoms_CIW(Count:Count+M_CIWs(i)-1,:) = sign(randn(M_CIWs(i),length(ClassIndices)))*X(:,ClassIndices)';
    Count = Count + M_CIWs(i);
end

W_randoms_CIW =  ReceptiveFields.*W_randoms_CIW; %get CIW random weights masked by the receptive fields
W_randoms_CIW = Scaling*diag(1./sqrt(eps+sum(W_randoms_CIW.^2,2)))*W_randoms_CIW; %normalise rows and scale
W_randoms_CIW = [W_randoms_CIW zeros(M,1)];

%Get the Constrained weights
biases = zeros(M,1);
W_randoms_C = zeros(M,L);
for i = 1:M
    Norm = 0;
    Inds = ones(2,1);
    while labels(Inds(1)) == labels(Inds(2)) ||  Norm < eps
        Inds = randperm(length(labels),2);
        X_Diff = X(:,Inds(1))-X(:,Inds(2));
        Wrow = X_Diff.*ReceptiveFields(i,:)';
        Norm  = sqrt(sum(Wrow.^2));
    end
    W_randoms_C(i,:) = Wrow/Norm;
    biases(i) = 0.5*(X(:,Inds(1))+X(:,Inds(2)))'*Wrow/Norm;
end
W_randoms_C = Scaling*W_randoms_C; %scale the weights (already normalised)
W_randoms_C = [W_randoms_C biases];

%to implement biases, set an extra input dimension to 1, and put the biases in the input weights matrix
X = [X;ones(1,length(labels))];
X_test = [X_test;ones(1,length(labels_test))];

%train the CIW ELM
tic
A_CIW = 1./(1+exp(-W_randoms_CIW*X)); %get hidden layer activations
W_outputs_CIW = (A_CIW*Y)'/(A_CIW*A_CIW'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
Y_predicted_CIW = W_outputs_CIW*A_CIW;
[MaxVal,ClassificationID_train_CIW] = max(Y_predicted_CIW); %get output layer response and then classify it
PercentCorrect_train_CIW = 100*(1-length(find(ClassificationID_train_CIW-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test_CIW = W_outputs_CIW*(1./(1+exp(-W_randoms_CIW*X_test))); %get output layer response
[MaxVal,ClassificationID_test_CIW] = max(Y_predicted_test_CIW); %get classification
PercentCorrect_CIW = 100*(1-length(find(ClassificationID_test_CIW-1-labels_test'~=0))/length(labels_test))%calculate the error rate
toc

%train the C ELM
tic
A_C = 1./(1+exp(-W_randoms_C*X)); %get hidden layer activations
W_outputs_C = (A_C*Y)'/(A_C*A_C'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
Y_predicted_C = W_outputs_C*A_C;
[MaxVal,ClassificationID_train_C] = max(Y_predicted_C); %get output layer response and then classify it
PercentCorrect_train_C = 100*(1-length(find(ClassificationID_train_C-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test_C = W_outputs_C*(1./(1+exp(-W_randoms_C*X_test))); %get output layer response
[MaxVal,ClassificationID_test_C] = max(Y_predicted_test_C); %get classification
PercentCorrect_C = 100*(1-length(find(ClassificationID_test_C-1-labels_test'~=0))/length(labels_test))%calculate the error rate
toc

%now do the second layer combining ELM
tic
X_combined = [Y_predicted_CIW;Y_predicted_C];
X_combined_test = [Y_predicted_test_CIW;Y_predicted_test_C];

%get CIW weights for the output layer
M2_CIWs = round(M2*NumEachClass/length(labels));
M2 = sum(M2_CIWs);
W_randoms = zeros(M2,size(X_combined,1));
Count = 1;
for i = 1:NumClasses
    ClassIndices = find(labels==i-1);
    W_randoms(Count:Count+M2_CIWs(i)-1,:) = sign(randn(M2_CIWs(i),length(ClassIndices)))*X_combined(:,ClassIndices)';
    Count = Count + M2_CIWs(i);
end

W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale

A = 1./(1+exp(-W_randoms*X_combined)); %get hidden layer activations
W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M2)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
[MaxVal,ClassificationID_train] = max(W_outputs*A);%get output layer response and then classify it
PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_combined_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate

toc




