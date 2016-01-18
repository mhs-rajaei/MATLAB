%%
% clear all;
% Load_Data;
clear all;
% load train and test set from 'Inputs.mat'
load('Inputs.mat');
% this paramet-er used for initial random weight's
parameter.epsilon=0.15;
% Learning rate
parameter.learning_rate=.001;
% iteration number
parameter.iteration = 10000;
% weight's vector + bias weight
wts=rand(1,7) * 1 * parameter.epsilon;

[ML_Result,ML_wts] = ML(Xtrain,wts,Xlabels,Xtest);


[Online_Result,Online_MSE,Online_wts] = Online(Xtrain,wts,parameter,Xlabels,Xtest);

[Batch_Result,Batch_MSE,Batch_wts] = Batch(Xtrain,wts,parameter,Xlabels,Xtest);

[Pass_or_Fail_status,Pass_or_Fail_MSE,Pass_or_Fail_wts] = Pass_or_Fail(Xtrain,wts,parameter,Xlabels,Xtest);

[Logistic_Result , Logistic_MSE , Logistic_wts] = Logistic_Classification(Xtrain,wts,parameter,Xlabels,Xtest);