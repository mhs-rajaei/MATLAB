
clear all
load('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\NSL-KDD Preprocessed_5Class_Target.mat');
%% Normalization
% before normalizing we must replace NaN whit 0
KDD_Training_p_num_5class_target(isnan(KDD_Training_p_num_5class_target)) = 0;
KDD_Test_p_num_5class_target(isnan(KDD_Test_p_num_5class_target)) = 0;
Twenty_Percent_KDD_Training_p_num_5class_target(isnan(Twenty_Percent_KDD_Training_p_num_5class_target)) = 0;
KDD_Test_mines21_num_5class_target(isnan(KDD_Test_mines21_num_5class_target)) = 0;

%% Deleting Columns
% number of columns that must be delated, afte delete each column you must
column = [7 8 9 10 13 16 17 19 20 24 25 26 27 28 29 30 34 36 37 38 39 40];

KDD_Training_p_num_5class_target(:,column) =  [];
KDD_Test_p_num_5class_target(:,column) =  [];
Twenty_Percent_KDD_Training_p_num_5class_target(:,column) = [];
KDD_Test_mines21_num_5class_target(:,column) =  [];

%% Normalization by "Normalization.m"
KDD_Training_p_num_5class_target = Normalization(KDD_Training_p_num_5class_target);
KDD_Test_p_num_5class_target = Normalization(KDD_Test_p_num_5class_target);
Twenty_Percent_KDD_Training_p_num_5class_target = Normalization(Twenty_Percent_KDD_Training_p_num_5class_target);
KDD_Test_mines21_num_5class_target = Normalization(KDD_Test_mines21_num_5class_target);

% % number of columns that must be Normalized
% column = [1:size(KDD_Training_p_num_2class_target,2)-1];
% % normalizing for each coulme number
% for i=1:length(column)
%     KDD_Training_p_num_2class_target(:,column(i)) = ...
%         Min_Max_Normalization(KDD_Training_p_num_2class_target(:,column(i)));
%     KDD_Test_p_num_2class_target(:,column(i)) = ...
%         Min_Max_Normalization(KDD_Test_p_num_2class_target(:,column(i)));
%     Twenty_Percent_KDD_Training_p_2class_target(:,column(i)) = ...
%         Min_Max_Normalization(Twenty_Percent_KDD_Training_p_2class_target(:,column(i)));
%     KDD_Test_mines21_mum_2class_target(:,column(i)) = ...
%         Min_Max_Normalization(KDD_Test_mines21_mum_2class_target(:,column(i)));
% end



%% Training MR_MLP

% MR_MLP(train_set,train_labels, ...
%     test_set,test_labales  ,validation_set,validation_labels)
% train_set = [input_nurons , number_of_training_samples]
MR_MLP(KDD_Training_p_num_5class_target(:,1:size(KDD_Training_p_num_5class_target,2)-1),...
    KDD_Training_p_num_5class_target_labels, ...
    KDD_Test_p_num_5class_target(:,1:size(KDD_Training_p_num_5class_target,2)-1),...
    KDD_Test_p_num_5class_target_labels  ,...
    Twenty_Percent_KDD_Training_p_num_5class_target(:,1:size(KDD_Training_p_num_5class_target,2)-1),...
    Twenty_Percent_KDD_Training_p_5class_target_labels)

