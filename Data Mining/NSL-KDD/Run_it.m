
clear all
load('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed_Numeric_2Class_Target.mat');
%% Normalization
% before normalizing we must replace NaN whit 0
KDD_Training_p_num_2class_target(isnan(KDD_Training_p_num_2class_target)) = 0;
KDD_Test_p_num_2class_target(isnan(KDD_Test_p_num_2class_target)) = 0;
Twenty_Percent_KDD_Training_p_2class_target(isnan(Twenty_Percent_KDD_Training_p_2class_target)) = 0;
KDD_Test_mines21_mum_2class_target(isnan(KDD_Test_mines21_mum_2class_target)) = 0;

% %% Deleting Columns
% % number of columns that must be delated, afte delete each column you must
% % decrement index -> [21 22 25 26 27 28 29 30 40] == [21 21 23 23 23 23 23 23 32]
% % column = [21 21 22 23 23 23 23 23 32];
% column = [21 22 25 26 27 28 29 30 40];
% % deleting for each coulme number
% % for i=1:length(column)
% %     KDD_Training_p_num_2class_target(:,column(i)) =  [];
% %     KDD_Test_p_num_2class_target(:,column(i)) =  [];
% %     Twenty_Percent_KDD_Training_p_2class_target(:,column(i)) = [];
% %     KDD_Test_mines21_mum_2class_target(:,column(i)) =  [];
% % end
% KDD_Training_p_num_2class_target(:,column) =  [];
% KDD_Test_p_num_2class_target(:,column) =  [];
% Twenty_Percent_KDD_Training_p_2class_target(:,column) = [];
% KDD_Test_mines21_mum_2class_target(:,column) =  [];
% 
%% Normalization by "Normalization.m"
KDD_Training_p_num_2class_target = Normalization(KDD_Training_p_num_2class_target);
KDD_Test_p_num_2class_target = Normalization(KDD_Test_p_num_2class_target);
Twenty_Percent_KDD_Training_p_2class_target = Normalization(Twenty_Percent_KDD_Training_p_2class_target);
KDD_Test_mines21_mum_2class_target = Normalization(KDD_Test_mines21_mum_2class_target);

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

%% preparing target labels
% train targets
train_labels = zeros(2,size(KDD_Training_p_num_2class_target,1))';
for i=1:size(KDD_Training_p_num_2class_target,1)
    if KDD_Training_p_num_2class_target(i,size(KDD_Training_p_num_2class_target,2))==0
        train_labels(i,1) = 1;
    else
        train_labels(i,2) = 1;
    end
end
% test targets
test_labels = zeros(2,size(KDD_Test_p_num_2class_target,1))';
for i=1:size(KDD_Test_p_num_2class_target,1)
    if KDD_Test_p_num_2class_target(i,size(KDD_Test_p_num_2class_target,2))==0
        test_labels(i,1) = 1;
    else
        test_labels(i,2) = 1;
    end
end
% validation targets
validation_labels = zeros(2,size(Twenty_Percent_KDD_Training_p_2class_target,1))';
for i=1:size(Twenty_Percent_KDD_Training_p_2class_target,1)
    if Twenty_Percent_KDD_Training_p_2class_target(i,size(Twenty_Percent_KDD_Training_p_2class_target,2))==0
        validation_labels(i,1) = 1;
    else
        validation_labels(i,2) = 1;
    end
end

% %% save to text format
% csvwrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\txt\KDD_Training_p_num_2class_target.txt',...
%     KDD_Training_p_num_2class_target);
% csvwrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\txt\KDD_Test_p_num_2class_target.txt',...
%     KDD_Test_p_num_2class_target);
% csvwrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\txt\Twenty_Percent_KDD_Training_p_2class_target.txt',...
%     Twenty_Percent_KDD_Training_p_2class_target);
        
% MR_MLP(train_set,train_labels, ...
%     test_set,test_labales  ,validation_set,validation_labels)
% train_set = [input_nurons , number_of_training_samples]
MR_MLP(KDD_Training_p_num_2class_target(:,1:size(KDD_Training_p_num_2class_target,2)-1),...
    train_labels, ...
    KDD_Test_p_num_2class_target(:,1:size(KDD_Training_p_num_2class_target,2)-1),...
    test_labels  ,...
    Twenty_Percent_KDD_Training_p_2class_target(:,1:size(KDD_Training_p_num_2class_target,2)-1),...
    validation_labels)

