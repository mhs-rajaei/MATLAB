clear all;
% read train set from excel
Xtrain = xlsread('tak2train.xlsx');
% train set labels
Xlabels = Xtrain(:,end);
% remove last column
Xtrain(:,end)=[];
% remove first column
Xtrain(:,1)=[];
% read tets set from excel
Xtest = xlsread('tak2test.xlsx');

%add bias
Xtrain(:,end+1)=1;
Xtest(:,end+1)=1;
% save variabels to 'Inputs.mat'
save('Inputs.mat');