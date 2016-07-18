clear all;tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This CIW-ELM code achieves the following:
%-if M = 1600, an error rate on MNIST of about 96.5% correct on test data in about 16 seconds (on a four core computer using multithreading)

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
Num_samples = 30000;
M = 9500; %set the number of hidden layer neurons
Scaling = 2; %set the input weights scaling
RidgeParam = 1e-8; %set the ridge regression parameter

%train the CIW-ELM with data X and labels Y

NumEachClass = sum(Y_input);
M_CIWs = round(M*NumEachClass/length(labels_input));
M0 = sum(M_CIWs);
if M0 ~= M
    M_CIWs(1) = M_CIWs(1) + M - M0;
end
Count = 1;
for i = 1:NumClasses
    ClassIndices = find(labels_input==i-1);
    %           W_randoms(Count:Count+M_CIWs(i)-1,:) = sign(randn(M_CIWs(i),length(ClassIndices)))*X(:,ClassIndices)';
    W_randoms(Count:Count+M_CIWs(i)-1,:) = (rand(M_CIWs(i),length(ClassIndices)) * 2 * 0.25 - 0.25) *X_inputs(:,ClassIndices)';
    Count = Count + M_CIWs(i);
end

W_randoms(M+1,:) = 1;
W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
%% Batch
Start_index = 0;
% W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
Sum_of_W_randoms = zeros((M+1),size(X_inputs,1));
Sum_of_W_outputs = zeros(NumClasses,(M+1));
Num_of_Data_parts = round(size(X_inputs,2)/Num_samples);

for j =1:(Num_of_Data_parts)
    End_index = j*size(X_inputs,2)/Num_of_Data_parts;
    X = X_inputs(:,Start_index+1:End_index);
    labels = labels_input(Start_index+1:End_index,:);
    Y = Y_input(Start_index+1:End_index,:);
    Start_index =  End_index;
    %%
%     NumEachClass = sum(Y);
%     M_CIWs = round(M*NumEachClass/length(labels));
%     M0 = sum(M_CIWs);
%     if M0 ~= M
%         M_CIWs(1) = M_CIWs(1) + M - M0;
%     end
%     Count = 1;
%     for i = 1:NumClasses
%         ClassIndices = find(labels==i-1);
%         W_randoms(Count:Count+M_CIWs(i)-1,:) = (rand(M_CIWs(i),length(ClassIndices)) * 2 * 0.25 - 0.25) *X(:,ClassIndices)';
%         Count = Count + M_CIWs(i);
%     end
%     
%     W_randoms(M+1,:) = 1;
%     W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
%     %%
%     Sum_of_W_randoms = W_randoms + Sum_of_W_randoms;
    %train the ELM
    A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
    W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M+1)); %find output weights by solving the for regularised least mean square weights
    
    Sum_of_W_outputs = W_outputs + Sum_of_W_outputs;
    
    %test with trained-on data
    [MaxVal,ClassificationID_train] = max(W_outputs*A); %get output layer response and then classify it
    PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)) %calculate the error rate
    
    %test with unseen data, X_test
    Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test))); %get output layer response
    [MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
    PercentCorrect = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate
    
end

W_outputs = zeros(NumClasses,(M+1));
% W_randoms = Sum_of_W_randoms / Num_of_Data_parts;
% A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs = (Sum_of_W_outputs / Num_of_Data_parts);
[MaxVal,ClassificationID_train] = max(W_outputs*A);%get output layer response and then classify it
PercentCorrect_train_avg = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)); %calculate the error rate

%output the number of training data points correctly classified following training
PercentCorrect_train_avg

%test with unseen data, X_test
%     X_test = [X_test;ones(1,length(labels_test))]; %to implement possible non-zero biases, we set an extra input dimension to 1
%test with unseen data, X_test
Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test))); %get output layer response
[MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
PercentCorrect_test_avg = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate

toc