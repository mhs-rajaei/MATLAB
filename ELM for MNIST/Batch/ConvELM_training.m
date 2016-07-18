function [Y_predicted_train,W_randoms,W_outputs,A,ZZ,UU] = ConvELM_training(L,X,Y,k_train,labels,M)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code implements methods described and referenced in the paper at http://arxiv.org/abs/1412.8307

%Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: June 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1412.8307

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W_randoms = zeros(M,L);
biases = zeros(M,1);

%Uses the "Constrained weights" method (see W. Zhu and J. Miao and L. Qing, "Constrained extreme learning machines: A study on classification cases", arXiv:1501.06115, 2015.
for i = 1:M
    Norm = 0;
    Inds = ones(2,1);
    while labels(Inds(1)) == labels(Inds(2)) ||  Norm < eps
        Inds = randperm(k_train,2);
        X_Diff = X(:,Inds(1))-X(:,Inds(2));
        Wrow = X_Diff-mean(X_Diff);
        Norm  = sqrt(sum(Wrow.^2));
    end
    W_randoms(i,:) = Wrow/Norm;
    biases(i) = 0.5*(X(:,Inds(1))+X(:,Inds(2)))'*Wrow/Norm;
end

%to implement biases, set an extra input dimension to 1, and put the biases in the input weights matrix
X = [X;ones(1,k_train)];
W_randoms = [W_randoms biases];

%train the ELM using QR factorization with ridge regression
A = (W_randoms*X).^2; %get hidden layer activations
UU = (A*Y)'/k_train;
ZZ = A*A'/k_train;
RidgeParam = 0.5*min(diag(ZZ))*size(Y,2)^2/M^2; %see the paper described at http://arxiv.org/abs/1503.04596
W_outputs = UU/(ZZ+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
Y_predicted_train = W_outputs*A;

