clear all;
load('F:\Documents\MATLAB\Data\Kyoto\training_data.mat');
%datanum = cell2mat(data');
%% preparing target labels
% train targets
train_labels = zeros(2,size(training_data,1))';
for i=1:size(training_data,1)
    if training_data(i,size(training_data,2))==1
        train_labels(i,1) = 1;
    else
        train_labels(i,2) = 1;
    end
end
% train_set = [input_nurons , number_of_training_samples]
% train_labels = [number_of_training_samples , number of output neurons]
train_set = training_data(:,1:size(training_data,2)-1)';
clear('training_data')
%%%%%%%%%%%%%%%%%%%%%%%5
load('F:\Documents\MATLAB\Data\Kyoto\test_data.mat');
% test2-1 targets
test_labels = zeros(2,size(test_data,1))';
for i=1:size(test_data,1)
    if test_data(i,size(test_data,2))==1
        test_labels(i,1) = 1;
    else
        test_labels(i,2) = 1;
    end
end
test_set = test_data(:,1:size(test_data,2)-1)';
clear('test_data')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('F:\Documents\MATLAB\Data\Kyoto\test_data2.mat');
% tets2-2 targets
test_2_labels = zeros(2,size(test_data2,1))';
for i=1:size(test_data2,1)
    if test_data2(i,size(test_data2,2))==1
        test_2_labels(i,1) = 1;
    else
        test_2_labels(i,2) = 1;
    end
end
test_set2 = test_data2(:,1:size(test_data2,2)-1)';
clear('test_data2')



%% RUN MR-MLP
MR_MLP
