clear all;

% Common format for xlsread (read an xls-file):

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

% %Read first sheet or KDD Training+ from NSL-KDD Dataset.xlsx 
% [KDD_Training_p_num,KDD_Training_p_txt,KDD_Training_p_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'KDD Training+');
% %Read seecond sheet or  20% KDD Training+ from NSL-KDD Dataset.xlsx 
% [Twenty_Percent_KDD_Training_p_num,Twenty_Percent_KDD_Training_p_txt,Twenty_Percent_KDD_Training_p_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     '20% KDD Training+');
% %Read third sheet or KDD Test+ from NSL-KDD Dataset.xlsx 
% [KDD_Test_p_num,KDD_Test_p_txt,KDD_Test_p_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'KDD Test+');
% %Read forth sheet or KDD Test(-21) from NSL-KDD Dataset.xlsx 
% [KDD_Test_mines21_num,KDD_Test_mines21_txt,KDD_Test_mines21_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'KDD Test(-21)');
% %Read six sheet or Feature Types from NSL-KDD Dataset.xlsx 
% [~,Feature_Types_txt,Feature_Types_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'Feature Types');
% %Read seven sheet or Attack Types from NSL-KDD Dataset.xlsx 
% [~,Attack_Types_txt,Attack_Types_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'Attack Types');

% %Read eight sheet or Feature Description from NSL-KDD Dataset.xlsx 
% [Feature_Description_num,Feature_Description_txt,Feature_Description_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'Feature Description');

%Read first sheet or KDD Training+ from NSL-KDD Dataset.xlsx 
[~,~,KDD_Training_p_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
    'KDD Training+');
%Read seecond sheet or  20% KDD Training+ from NSL-KDD Dataset.xlsx 
[~,~,Twenty_Percent_KDD_Training_p_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
    '20% KDD Training+');
%Read third sheet or KDD Test+ from NSL-KDD Dataset.xlsx 
[~,~,KDD_Test_p_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
    'KDD Test+');
%Read forth sheet or KDD Test(-21) from NSL-KDD Dataset.xlsx 
[~,~,KDD_Test_mines21_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
    'KDD Test(-21)');
%Read six sheet or Feature Types from NSL-KDD Dataset.xlsx 
[~,~,Feature_Types_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
    'Feature Types');
%Read seven sheet or Attack Types from NSL-KDD Dataset.xlsx 
[~,~,Attack_Types_raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
    'Attack Types');


% save variabels to 'Inputs.mat'
save('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL_KDD.mat');

