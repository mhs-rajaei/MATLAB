function [W_in,W_out,A] = ELM_backprop(NumIterations,Epsilon,X,Y,A,W_in,W_out,RidgeParam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code implements the method of 

%D. Yu and L. Ding, 
%"Efficient and effective algorithms for training single-hidden-layer neural networks", 
%Pattern Recognition Letters 33:554-558 2012

%Our implementation assumes biases are includes as the final row of the input weights, W_in
%We also assume that hidden layer activations are the sigmoidal logistic function. If not, in the code A-A.^2 needs to be changed, as well as A.

%Author of code: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: January 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1412.8307

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = size(W_in,1);
for ii = 1:NumIterations
    dW = ((A-A.^2).*(W_out'*(W_out*A-Y')))*X'; %assumes logistic function sigmoidal activations
    W_in = W_in - Epsilon*dW; %get new W_in
    A = 1./(1+exp(-W_in*X)); %get new A
    W_out = (A*Y)'/(A*A'+RidgeParam*eye(M)); %get new W_out
end