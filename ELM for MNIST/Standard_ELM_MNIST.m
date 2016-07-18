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
M = 8000; %set the number of hidden layer neurons
Scaling = 2; %set the input weights scaling
RidgeParam = 1e-8; %set the ridge regression parameter

%train the ELM with data X and labels Y, using four lines of matlab code
% W_randoms =  sign(randn(M,size(X,1))); %get bipolar random weights
% W_randoms = Scaling*diag(1./sqrt(sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale

% X_test = [X_test;ones(1,length(labels_test))]; %to implement possible non-zero biases, we set an extra input dimension to 1
Start_index = 0;
W_randoms = rand((M+1),size(X_inputs,1)) * Scaling * 0.25 - 0.25;
% W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
Sum_of_W_outputs = zeros(NumClasses,(M+1));
Num_of_Data_parts = round(size(X_inputs,2)/Num_samples);

for j =1:(Num_of_Data_parts)
    End_index = j*size(X_inputs,2)/Num_of_Data_parts;
    X = X_inputs(:,Start_index+1:End_index);
    labels = labels_input(Start_index+1:End_index,:);
    Y = Y_input(Start_index+1:End_index,:);
    Start_index =  End_index;
    %training phase
    L = size(X,1);
    ImageSize = sqrt(L);
    
    %train the ELM
    
    %     W_randoms = rand(M,size(X,1)) * 2 * 0.25 - 0.25;
    
    A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
    W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M+1)); %find output weights by solving the for regularised least mean square weights
    
    Sum_of_W_outputs = W_outputs + Sum_of_W_outputs;
    %validate with trained-on data, X
    [MaxVal,ClassificationID_train] = max(W_outputs*A);%get output layer response and then classify it
    PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels)); %calculate the error rate
    
    %output the number of training data points correctly classified following training
    PercentCorrect_train
    
    %test with unseen data, X_test
    %     X_test = [X_test;ones(1,length(labels_test))]; %to implement possible non-zero biases, we set an extra input dimension to 1
    %test with unseen data, X_test
    Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test))); %get output layer response
    [MaxVal,ClassificationID_test] = max(Y_predicted_test); %get classification
    PercentCorrect_test = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))%calculate the error rate
    
    
    UseBackprop = 0;
    
    if UseBackprop
        
        % do some iterations of backprop
        
        %hyperparameters:
        Epsilon = 0.001;
        NumIterations = 10;
        RidgeParam = 1e-2;
        
        %obtain revised weights
        
        %             X = [X;ones(1,length(labels))];
        [W_randoms,W_outputs,A] = ELM_backprop(NumIterations,Epsilon,X,Y,A,W_randoms,W_outputs,RidgeParam);
        
        Y_predicted_train = W_outputs*A;
        [MaxVal,ClassificationID_train] = max(Y_predicted_train);
        PercentCorrect_train_backprop = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/length(labels))
        
        Y_predicted_test = W_outputs*(1./(1+exp(-W_randoms*X_test)));
        [MaxVal,ClassificationID_test] = max(Y_predicted_test);
        PercentCorrect_test_backprop = 100*(1-length(find(ClassificationID_test-1-labels_test'~=0))/length(labels_test))
        
    end
    
end

         
%         for jj=1:j
%             W_outputs = Sum_of_W_outputs(:,:,jj) + W_outputs;
%         end
%         W_outputs = Sum_of_W_outputs;
W_outputs = zeros(NumClasses,M);
% W_outputs = W_outputs_3;
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

