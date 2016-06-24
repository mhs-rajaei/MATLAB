clear all;

%% Common format for xlsread (read an xls-file):

% [num,txt,raw] = xlsread(file, sheet, range)

% Where 
% file = name of xls file (string)
% sheet = name of specific sheet within the file (string)
% range = specific range to read (string)
% num = read numerical data (numeric array or matrix)
% txt = read text data (cell array)
% 
% Common format for xlswrite (to write an xls.file):

% xlswrite(file, m, sheet, range)

% Where 
% m = matrix to insert in xls file
% file, sheet and range are as before
%%
% read train set from excel
[training_set,~,~] = xlsread('Computer_Assignment_5_Data.xls',...
    'Training Set');

% read test set from excel
[test_set,~,~] = xlsread('Computer_Assignment_5_Data.xls',...
    'Testing Set');

% train set labels
train_labels = training_set(:,1);

% test set labels
test_labels = test_set(:,1);

