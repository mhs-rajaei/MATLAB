%% =========== NSL_KDD =============
clear all
% load NSL_KDD dataset
load('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL_KDD.mat');
%% Conver Nominal to Numeric
KDD_Training_p_processed = Nominal2Numeric(KDD_Training_p_raw);
KDD_Test_p =  Nominal2Numeric(KDD_Test_p_raw);
KDD_Test_mines21 =  Nominal2Numeric(KDD_Test_mines21_raw);
Twenty_Percent_KDD_Training_p =  Nominal2Numeric(Twenty_Percent_KDD_Training_p_raw);

% Common format for xlswrite (to write an xls.file):

% xlswrite(file, m, sheet, range)

% Where
% m = matrix to insert in xls file
% file, sheet and range are as before
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed.xlsx',...
    Twenty_Percent_KDD_Training_p,'20% KDD Training+');
save('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed.mat');


%% Next ...
clear all;

load('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed.mat');
%% Set targets -> norma:0 and attacks:1
for i=1:size(KDD_Training_p_processed,1)
    % trainig
    if(strcmp(KDD_Training_p_processed{i,42},'normal'))
        KDD_Training_p_processed{i,42} = 0;
    else
        KDD_Training_p_processed{i,42} = 1;
    end
end
% test
for i=1:size(KDD_Test_p,1)
    
    if(strcmp(KDD_Test_p{i,42},'normal'))
        KDD_Test_p{i,42} = 0;
    else
        KDD_Test_p{i,42} = 1;
    end
end

% KDD_Test_mines21
for i=1:size(KDD_Test_mines21,1)
    if(strcmp(KDD_Test_mines21{i,42},'normal'))
        KDD_Test_mines21{i,42} = 0;
    else
        KDD_Test_mines21{i,42} = 1;
    end
end
% Twenty_Percent_KDD_Training_p
for i=1:size(Twenty_Percent_KDD_Training_p,1)
    if(strcmp(Twenty_Percent_KDD_Training_p{i,42},'normal'))
        Twenty_Percent_KDD_Training_p{i,42} = 0;
    else
        Twenty_Percent_KDD_Training_p{i,42} = 1;
    end
end
save('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed_2Class_Target.mat');
% save as xlsx file
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    Twenty_Percent_KDD_Training_p,'20% KDD Training+');
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    KDD_Training_p_processed,'KDD Training+');
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    KDD_Test_p,'KDD Test+');
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    KDD_Test_mines21,'KDD Test(-21)');


clear all
load('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed_2Class_Target.mat');
%% Next...
clear all
%Read first sheet or KDD Training+ from NSL-KDD Dataset
[KDD_Training_p_num_2class_target,~,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    'KDD Training+');
%Read seecond sheet or  20% KDD Training+ from NSL-KDD Dataset.xlsx 
[Twenty_Percent_KDD_Training_p_2class_target,~,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    '20% KDD Training+');
%Read third sheet or KDD Test+ from NSL-KDD Dataset.xlsx 
[KDD_Test_p_num_2class_target,~,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    'KDD Test+');
%Read forth sheet or KDD Test(-21) from NSL-KDD Dataset.xlsx 
[KDD_Test_mines21_mum_2class_target,~,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed 2 Class Target.xlsx',...
    'KDD Test(-21)');

save('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed_Numeric_2Class_Target.mat');

clear all
load('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processed with MATLAB\NSL-KDD Preprocessed_Numeric_2Class_Target.mat');
%% Normalization
% before normalizing we must replace NaN whit 0
KDD_Training_p_num_2class_target(isnan(KDD_Training_p_num_2class_target)) = 0;
KDD_Test_p_num_2class_target(isnan(KDD_Test_p_num_2class_target)) = 0;
Twenty_Percent_KDD_Training_p_2class_target(isnan(Twenty_Percent_KDD_Training_p_2class_target)) = 0;
KDD_Test_mines21_mum_2class_target(isnan(KDD_Test_mines21_mum_2class_target)) = 0;
% number of columns that must be Normalized
column = [1,8,23,13,29,11,17,19,32];
% normalizing for each coulme number
for i=1:length(column)
    KDD_Training_p_num_2class_target(:,column(i)) = ...
        Min_Max_Normalization(KDD_Training_p_num_2class_target(:,column(i)));
    KDD_Test_p_num_2class_target(:,column(i)) = ...
        Min_Max_Normalization(KDD_Test_p_num_2class_target(:,column(i)));
    Twenty_Percent_KDD_Training_p_2class_target(:,column(i)) = ...
        Min_Max_Normalization(Twenty_Percent_KDD_Training_p_2class_target(:,column(i)));
    KDD_Test_mines21_mum_2class_target(:,column(i)) = ...
        Min_Max_Normalization(KDD_Test_mines21_mum_2class_target(:,column(i)));
end

% number of columns that must be delated, afte delete each column you must
% decrement index -> [21 22 25 26 27 28 29 30 40] == [21 21 23 23 23 23 23 23 32]
column = [21 21 23 23 23 23 23 23 32];
% deleting for each coulme number
for i=1:length(column)
    KDD_Training_p_num_2class_target(:,column(i)) =  [];
    KDD_Test_p_num_2class_target(:,column(i)) =  [];
    Twenty_Percent_KDD_Training_p_2class_target(:,column(i)) = [];
    KDD_Test_mines21_mum_2class_target(:,column(i)) =  [];
end


