%% =========== Start MR_MLP =============
clc;
clear all;

%% =========== Laod MNIST Dataset =============

%Load MNIST Dataset
Load_Data;


%% Inputs from user
prompt = {'Learning rate:','Iteration','Number of training_samples'};
dlg_title = 'Input';
num_lines = 1;
% num2str(size(images,2))
defaultans = {'0.9','10','100'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
%% =========== Create Network Layer's  =====================================================
% struct of network layers
layer = struct('Size',[],'wts',[],'a',[],'n',[]);

%value epsilon use for initialize random weights
epsilon = 0.12;

%set paremeters
% Enter the learning rate value
learning_rate =str2num(answer{1});

% epoch number
% Enter the iteration value
iteration =str2num(answer{2});

% Number of training_samples
% Enter the number of training_samples
number_of_training_samples =str2num(answer{3});

if number_of_training_samples<=50000
    samples = number_of_training_samples;
else
    number_of_training_samples = 50000;
end
% Number of layers
L = 3;

layer(1).Size=784;
layer(1).a.Size=[layer(1).Size];
layer(1).a.Type='double';
layer(1).a.Range=[];
layer(1).a = zeros(layer(1).Size,samples);

%% Set competetive layer
c = 2;
% randomly Initialize weight of layers:
layer(c).Size=784;
layer(c).wts.Size=[10,784];
layer(c).wts.Type='double';
layer(c).wts.Range=[];
layer(c).wts = rand(10,784) * 2 * epsilon - epsilon;

% Initialize activation of layers:
layer(c).a.Size=[layer(c).Size];
layer(c).a.Type='double';
layer(c).a.Range=[];
layer(c).a = zeros(784,1);

%% Output Layer
layer(L).Size=10;
% Initialize activation of layers:
layer(L).a.Size=[layer(L).Size];
layer(L).a.Type='double';
layer(L).a.Range=[];
layer(L).a = zeros(1,10);

layer(1).a(1:layer(1).Size,1:samples) = images(1:layer(1).Size,1:samples);

%% =========== Forward and  Train =============
Train;

