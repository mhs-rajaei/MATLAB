%% =========== Start MR_MLP =============
clc;
clear all;

%% =========== Laod Hoda Data set =============
% load Hoda data set
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_training_images(60000).mat');
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_remaining_images(22352).mat');
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_test_images(20000).mat');

figure(4);
% randomly show 60 numbers of test data
for i=1:60
    subplot(6, 10, i);
    rand_idx = randi(20000);
    imshow(test_images(:,:,rand_idx));
    title(test_labels(rand_idx));
    axis square;
end

% training data
trainig_inputs = reshape(training_images,[32*32,60000]);
number_of_input_neurons = 32*32;
% test data
test_inputs = reshape(test_images,[32*32,20000]);

% validation data
% tmp = zeros(32,32,10000);
tmp = remaining_images(:,:,1:20000);
validation_images = reshape(tmp,[32*32,20000]);
validation_labels = remaining_labels(1:20000);


%     num_of_samples = num2str(number_of_training_samples);%sapmles

% Targets
labels = training_labels;

test_images = test_inputs;

test_samples = size(test_inputs,2);


prompt = {'Method:(1 for Batch method - 0 for Online method)','Learning rate:','alfa:(Momentum coefficient)'...
    ,'lambda:(Regularization coefficient)','Validation check','Iteration','Number of training_samples',...
    'Number of layers','Batch size','Train(1) or Train2(2) or Train3(3) or Train4(4)',...
    'tanh or sigmoid(1 for tanh -2  for sigmoid)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','0.3','0.9','0','100','100',num2str(size(trainig_inputs,2)),'3','100','3','2'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

%% =========== Create Network Layer's  =====================================================
% struct of network layers
layer = struct('Size',[],'wts',[],'a',[],'z',[],'delta',[],'DW',[],...
    'bias',[],'MSE',[],'delta_W',[],'big_delta',[],...
    'big_delta_bias',[],'delta_W_last',[]);
parameter = struct('learning_rate',[],'alfa',[],'lambda',[],'epsilon',[],'method',[]);
% value epsilon use for initialize random weights
parameter.epsilon = 0.12;


% Enter the Learning method(1 for Batch method or 0 for Online method)
parameter.method =str2num(answer{1});

%set paremeters
% Enter the learning rate value
parameter.learning_rate =str2num(answer{2});

% Enter the momentum value
parameter.alfa =str2num(answer{3});

% Enter the regularization value
parameter.lambda =str2num(answer{4});

% Enter the validation check value
validation_check =str2num(answer{5});

% epoch number
% Enter the iteration value
iteration =str2num(answer{6});

% Number of training_samples
% Enter the number of training_samples
number_of_training_samples =str2num(answer{7});

if number_of_training_samples > 60000
    number_of_training_samples = 60000;
end

% Enter the number of layers
L =str2num(answer{8});

% Enter the batch size(for mini batch training)
batch_size =str2num(answer{9});

% Enter Train(1) or Train2(2) or Train_3(3) or Train_4(4)
train_file = str2num(answer{10});

% Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid)
tanh_or_sigmoid = str2num(answer{11});

layer(1).Size=number_of_input_neurons;
layer(1).a.Size=[layer(1).Size];
layer(1).a.Type='double';
layer(1).a.Range=[];
layer(1).a = zeros(layer(1).Size,number_of_training_samples);

layer(1).a = trainig_inputs(:,1:number_of_training_samples);%size input: number_of_input_neurons * number_of_samples


% set other layer parameters, layer 2 from end
for c=2:(L-1)
    temp=strcat('Enter numbers of nodes layer',num2str(c),'\n');
    % randomly Initialize weight of layers:
    layer(c).Size=input(temp);
    layer(c).wts.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).wts.Type='double';
    layer(c).wts.Range=[];
    layer(c).wts = rand(layer(c-1).Size+1,layer(c).Size) * 2 * parameter.epsilon - parameter.epsilon;
    % Initialize Big DELTA of layers - (Big DELTA is notation of Backprppagation algorithm):
    layer(c).big_delta.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).big_delta.Type='double';
    layer(c).big_delta.Range=[];
    layer(c).big_delta = zeros(layer(c-1).Size+1,layer(c).Size);
    % Initialize DELTA W last of layers - (DELTA W last is notation of momentum  :
    layer(c).delta_W_last.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).delta_W_last.Type='double';
    layer(c).delta_W_last.Range=[];
    layer(c).delta_W_last = zeros(layer(c-1).Size+1,layer(c).Size);
    % Initialize DELTA of layers - (DELTA is notation of Backprppagation algorithm):
    layer(c).delta.Size=[layer(c).Size];
    layer(c).delta.Type='double';
    layer(c).delta.Range=[];
    layer(c).delta=zeros(1,layer(c).Size);
    % Initialize Big DELTA Bias of layers - (Big DELTA Bias is notation of Backprppagation algorithm):
    layer(c).big_delta_bias.Size=[layer(c).Size];
    layer(c).big_delta_bias.Type='double';
    layer(c).big_delta_bias.Range=[];
    layer(c).big_delta_bias=zeros(1,layer(c).Size);
    % Initialize activation of layers:
    layer(c).a.Size=[layer(c).Size];
    layer(c).a.Type='double';
    layer(c).a.Range=[];
    layer(c).a = zeros(1,layer(c).Size);
    % Initialize z of layers:
    layer(c).z.Size=[layer(c).Size];
    layer(c).z.Type='double';
    layer(c).z.Range=[];
    layer(c).z = zeros(1,layer(c).Size);
    % Initialize Bias  layers:
    layer(c).bias.Size=1;
    layer(c).bias.Type='double';
    layer(c).bias.Range=[];
    layer(c).bias=1;
    
    layer(c).DW.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).DW.Type='double';
    layer(c).DW.Range=[];
    layer(c).DW = zeros(layer(c-1).Size+1,layer(c).Size);
    
end
%% Output Layer
layer(L).Size=10;
layer(L).wts.Size=[layer(L-1).Size+1,layer(L).Size];
layer(L).wts.Type='double';
layer(L).wts.Range=[];
layer(L).wts = rand(layer(L-1).Size+1,layer(L).Size) * 2 * parameter.epsilon - parameter.epsilon;
% Initialize Big DELTA of layers - (Big DELTA is notation of Backprppagation algorithm):
layer(L).big_delta.Size=[layer(L-1).Size+1,layer(L).Size];
layer(L).big_delta.Type='double';
layer(L).big_delta.Range=[];
layer(L).big_delta = zeros(layer(L-1).Size+1,layer(L).Size);
% Initialize DELTA W last of layers - (DELTA W last is notation of momentum  :
layer(L).delta_W_last.Size=[layer(L-1).Size+1,layer(L).Size];
layer(L).delta_W_last.Type='double';
layer(L).delta_W_last.Range=[];
layer(L).delta_W_last = zeros(layer(L-1).Size+1,layer(L).Size);
% Initialize DELTA of layers - (DELTA is notation of Backprppagation algorithm):
layer(L).delta.Size=[layer(L).Size];
layer(L).delta.Type='double';
layer(L).delta.Range=[];
layer(L).delta=zeros(1,layer(L).Size);
% Initialize Big DELTA Bias of layers - (Big DELTA Bias is notation of Backprppagation algorithm):
layer(L).big_delta_bias.Size=[layer(L).Size];
layer(L).big_delta_bias.Type='double';
layer(L).big_delta_bias.Range=[];
layer(L).big_delta_bias=zeros(1,layer(L).Size);
% Initialize activation of layers:
layer(L).a.Size=[layer(L).Size];
layer(L).a.Type='double';
layer(L).a.Range=[];
layer(L).a = zeros(1,layer(L).Size);
% Initialize z of layers:
layer(L).z.Size=[layer(L).Size];
layer(L).z.Type='double';
layer(L).z.Range=[];
layer(L).z = zeros(1,layer(L).Size);
% Initialize Bias  layers:
layer(L).bias.Size=1;
layer(L).bias.Type='double';
layer(L).bias.Range=[];
layer(L).bias=1;

layer(L).DW.Size=[layer(L-1).Size+1,layer(L).Size];
layer(L).DW.Type='double';
layer(L).DW.Range=[];
layer(L).DW = zeros(layer(L-1).Size+1,layer(L).Size);
    

% delete Unnecessary and temp variable
clear('answer','defaultans','num_lines','prompt','rand_idx','remaining_images','remaining_labels',...
    'temp','tmp');

%% =========== Forward and  Train MLP =============

if train_file == 1
    Train;
elseif train_file==2
    Train2;
elseif train_file==3
    Train3;
elseif train_file==4
    Train4;
else
    error('Error in inputs');
end



