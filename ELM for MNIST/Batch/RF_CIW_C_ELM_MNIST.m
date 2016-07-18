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
X_inputs = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\train-images-idx3-ubyte\train-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
X_test = loadMNISTImages('F:\Documents\MATLAB\Data\MNIST\t10k-images-idx3-ubyte\t10k-images.idx3-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels_input = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\train-labels-idx1-ubyte\train-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip
labels_test = loadMNISTLabels('F:\Documents\MATLAB\Data\MNIST\t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte'); %uses function available from http://ufldl.stanford.edu/wiki/resources/mnistHelper.zip

idx = randperm(60000,60000);
X_inputs = X_inputs(:,idx);
labels_input = labels_input(idx,:);
%set up the ELM:

%create a target matrix using the training class labels
NumClasses = 10;
Y_input = zeros(length(labels_input),NumClasses);
for ii = 1:length(labels_input)
    Y_input(ii,labels_input(ii)+1) = 1;
end

%specify the hyperparameters:
Num_samples = 20000;
M = 3000; %set the number of hidden layer neurons
M2 = 500; %set the number of final layer ELM hidden neurons
Scaling = 2; %set the input weights scaling
RidgeParam = 1e-8; %set the ridge regression parameter
MinMaskSize = 10; %parameter for the RF-ELM
RF_Border = 3; %parameter for RF-ELM

%train the RF-ELM with data X and labels Y

NumEachClass = sum(Y_input);
M_CIWs = round(M*NumEachClass/length(labels_input));
M = sum(M_CIWs);

%get receptive field masks
L = size(X_inputs,1);
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
    ClassIndices = find(labels_input==i-1);
    W_randoms_CIW(Count:Count+M_CIWs(i)-1,:) = sign(randn(M_CIWs(i),length(ClassIndices)))*X_inputs(:,ClassIndices)';
%     W_randoms_CIW(Count:Count+M_CIWs(i)-1,:) =  (rand(M_CIWs(i),length(ClassIndices)) * Scaling * 0.25 - 0.25)*X_inputs(:,ClassIndices)';
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
    while labels_input(Inds(1)) == labels_input(Inds(2)) ||  Norm < eps
        Inds = randperm(length(labels_input),2);
        X_Diff = X_inputs(:,Inds(1))-X_inputs(:,Inds(2));
        Wrow = X_Diff.*ReceptiveFields(i,:)';
        Norm  = sqrt(sum(Wrow.^2));
    end
    W_randoms_C(i,:) = Wrow/Norm;
    biases(i) = 0.5*(X_inputs(:,Inds(1))+X_inputs(:,Inds(2)))'*Wrow/Norm;
end
W_randoms_C = Scaling*W_randoms_C; %scale the weights (already normalised)
W_randoms_C = [W_randoms_C biases];

%to implement biases, set an extra input dimension to 1, and put the biases in the input weights matrix
X_test = [X_test;ones(1,length(labels_test))];
%%
Start_index = 0;
% W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
% Sum_of_W_randoms = zeros((M),size(X_inputs,1));
Sum_of_W_outputs_CIW = zeros(NumClasses,(M));
Sum_of_W_outputs_C = zeros(NumClasses,(M));
Num_of_Data_parts = round(size(X_inputs,2)/Num_samples);

for j =1:(Num_of_Data_parts)
    End_index = j*size(X_inputs,2)/Num_of_Data_parts;
    X = X_inputs(:,Start_index+1:End_index);
    labels = labels_input(Start_index+1:End_index,:);
    Y = Y_input(Start_index+1:End_index,:);
    Start_index =  End_index;
%to implement biases, set an extra input dimension to 1, and put the biases in the input weights matrix
X = [X;ones(1,length(labels))];
%train the CIW ELM

A_CIW = 1./(1+exp(-W_randoms_CIW*X)); %get hidden layer activations
W_outputs_CIW = (A_CIW*Y)'/(A_CIW*A_CIW'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

Sum_of_W_outputs_CIW = W_outputs_CIW + Sum_of_W_outputs_CIW;

%test with trained-on data
Y_predicted_CIW = W_outputs_CIW*A_CIW;
[MaxVal,ClassificationID_train_CIW] = max(Y_predicted_CIW); %get output layer response and then classify it
PercentCorrect_train_CIW = 100*(1-length(find(ClassificationID_train_CIW-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test_CIW = W_outputs_CIW*(1./(1+exp(-W_randoms_CIW*X_test))); %get output layer response
[MaxVal,ClassificationID_test_CIW] = max(Y_predicted_test_CIW); %get classification
PercentCorrect_CIW = 100*(1-length(find(ClassificationID_test_CIW-1-labels_test'~=0))/length(labels_test))%calculate the error rate


%train the C ELM
A_C = 1./(1+exp(-W_randoms_C*X)); %get hidden layer activations
W_outputs_C = (A_C*Y)'/(A_C*A_C'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

Sum_of_W_outputs_C = W_outputs_C + Sum_of_W_outputs_C;

%test with trained-on data
Y_predicted_C = W_outputs_C*A_C;
[MaxVal,ClassificationID_train_C] = max(Y_predicted_C); %get output layer response and then classify it
PercentCorrect_train_C = 100*(1-length(find(ClassificationID_train_C-1-labels'~=0))/length(labels)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test_C = W_outputs_C*(1./(1+exp(-W_randoms_C*X_test))); %get output layer response
[MaxVal,ClassificationID_test_C] = max(Y_predicted_test_C); %get classification
PercentCorrect_C = 100*(1-length(find(ClassificationID_test_C-1-labels_test'~=0))/length(labels_test))%calculate the error rate



end
clear('X','Y','A_C','A_CIW','Y_predicted_C','Y_predicted_test_C','W_outputs_C',...
    'Y_predicted_test_CIW','Y_predicted_CIW','W_outputs_CIW','labels');
% add ones for bias
X_inputs = [X_inputs;ones(1,size(X_inputs,2))];
%% C_ELM
W_outputs_C = zeros(NumClasses,(M+1));
% W_randoms = Sum_of_W_randoms / Num_of_Data_parts;
% A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs_C = ( Sum_of_W_outputs_C / Num_of_Data_parts);

A_C = 1./(1+exp(-W_randoms_C*X_inputs)); %get hidden layer activations
Y_predicted_C = W_outputs_C*A_C;
[MaxVal,ClassificationID_train_C] = max(Y_predicted_C); %get output layer response and then classify it
PercentCorrect_train_C = 100*(1-length(find(ClassificationID_train_C-1-labels_input'~=0))/length(labels_input)) %calculate the error rate

Y_predicted_test_C = W_outputs_C*(1./(1+exp(-W_randoms_C*X_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test_C); %get classification
PercentCorrect_test_C_avg = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate

%% CIW_ELM

W_outputs_CIW = zeros(NumClasses,(M+1));
% W_randoms = Sum_of_W_randoms / Num_of_Data_parts;
% A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs_CIW = ( Sum_of_W_outputs_CIW / Num_of_Data_parts);

A_CIW = 1./(1+exp(-W_randoms_CIW*X_inputs)); %get hidden layer activations
Y_predicted_CIW = W_outputs_CIW*A_CIW;
[MaxVal,ClassificationID_train_CIW] = max(Y_predicted_CIW); %get output layer response and then classify it
PercentCorrect_train_CIW = 100*(1-length(find(ClassificationID_train_CIW-1-labels_input'~=0))/length(labels_input)) %calculate the error rate

Y_predicted_test_CIW = W_outputs_CIW*(1./(1+exp(-W_randoms_CIW*X_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test_CIW); %get classification
PercentCorrect_test_CIW_avg = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate

%%
%now do the second layer combining ELM

X_combined = [Y_predicted_CIW;Y_predicted_C];
X_combined_test = [Y_predicted_test_CIW;Y_predicted_test_C];

%get CIW weights for the output layer
M2_CIWs = round(M2*NumEachClass/length(labels_input));
M2 = sum(M2_CIWs);
W_randoms = zeros(M2,size(X_combined,1));
Count = 1;
for i = 1:NumClasses
    ClassIndices = find(labels_input==i-1);
    W_randoms(Count:Count+M2_CIWs(i)-1,:) = sign(randn(M2_CIWs(i),length(ClassIndices)))*X_combined(:,ClassIndices)';
%     W_randoms(Count:Count+M2_CIWs(i)-1,:) = (rand(M2_CIWs(i),length(ClassIndices)) * Scaling * 0.25 - 0.25)*X_combined(:,ClassIndices)';
    Count = Count + M2_CIWs(i);
end

W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale

A = 1./(1+exp(-W_randoms*X_combined)); %get hidden layer activations
W_outputs = (A*Y_input)'/(A*A'+RidgeParam*eye(M2)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
[MaxVal,ClassificationID_train] = max(W_outputs*A);%get output layer response and then classify it
PercentCorrect_train_RF_CIW_C_ELM_MNIST = 100*(1-length(find(ClassificationID_train-1-labels_input'~=0))/length(labels_input)) %calculate the error rate

%test with unseen data, X_test
Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_combined_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect_RF_CIW_C_ELM_MNIST = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate

toc





