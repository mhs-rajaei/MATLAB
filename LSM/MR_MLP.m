%% =========== Start MR_Autoencoder =============
close all;
%% Prepare Inputs:
Load_Data;

    %% set trangnig set and training lable
    train_set = training_set';%train_set(1:number_of_input_neurons,1:number_of_training_samples);
%% =========== Create Network Layer's  =====================================================
% struct of network layers
layer = struct('Size',[],'wts',[],'a',[],'z',[],'bias',[],'MSE',[]);

%% =======================set paremeters==========================
% value epsilon use for initialize random weights:
epsilon = 0.12;

% learning_rate:
learning_rate =0.3;

% epoch number(iteration):
iteration = 1000;
% Number of samples;
number_of_training_samples = size(train_set,2);

%% ===================================================================================================
%% Input Layer
number_of_input_neurons = size(train_set,1);
% Initialize first layers or input layer :
layer(1).Size=number_of_input_neurons;
layer(1).a.Size=[layer(1).Size];
layer(1).a.Type='double';
layer(1).a.Range=[];
layer(1).a = zeros(layer(1).Size,number_of_training_samples);
% set first layer data by train set:
layer(1).a = train_set(1:number_of_input_neurons,1:number_of_training_samples);

%% Hidden Layers
% set output layer parameter

%% Output Layer
    layer(2).Size=4;
    layer(2).wts.Size=[layer(1).Size+1,layer(2).Size];
    layer(2).wts.Type='double';
    layer(2).wts.Range=[];
    layer(2).wts = rand(layer(1).Size+1,layer(2).Size) * 2 * epsilon - epsilon;
    % Initialize aLtivation of layers:
    layer(2).a.Size=[layer(2).Size];
    layer(2).a.Type='double';
    layer(2).a.Range=[];
    layer(2).a = zeros(1,layer(2).Size);
    % Initialize z of layers:
    layer(2).z.Size=[layer(2).Size];
    layer(2).z.Type='double';
    layer(2).z.Range=[];
    layer(2).z = zeros(1,layer(2).Size);
    % Initialize Bias  layers:
    layer(2).bias.Size=1;
    layer(2).bias.Type='double';
    layer(2).bias.Range=[];
    layer(2).bias=1;


%%
% delete Unnecessary and temp variable
clear('training_set');
%% =========== Forward and  Train Network =============
Train;



