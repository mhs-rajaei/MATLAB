%% =========== Start MR_Autoencoder =============
close all;
%% Prepare Inputs:
Load_Data;

    %% set trangnig set and training lable
    tmp = training_set(:,2:3);
    train_set = tmp';%train_set(1:number_of_input_neurons,1:number_of_training_samples);
    
    test_set = test_set(:,2:3)';%test_set(1:number_of_input_neurons,1:number_of_test_samples);


%% input dialog
prompt = {'Method:(1 for Batch method - 0 for Online method)','Learning rate:','alfa:(Momentum coefficient)'...
    ,'lambda:(Regularization coefficient)','Iteration','Number of samples',...
    'Number of layers','Batch size','tanh or sigmoid(1 for tanh -2  for sigmoid)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','0.2','0','0','500',num2str(size(train_set,2)),'3','100','2'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

%% =========== Create Network Layer's  =====================================================
% struct of network layers
layer = struct('Size',[],'wts',[],'a',[],'z',[],'delta',[],...
    'bias',[],'MSE',[],'delta_W',[],'big_delta',[],...
    'big_delta_bias',[],'delta_W_last',[]);
parameter = struct('learning_rate',[],'alfa',[],'lambda',[],'epsilon',[],'method',[]);
%% =======================set paremeters==========================
% value epsilon use for initialize random weights:
parameter.epsilon = 0.12;
% learning method(online or batch):
parameter.method =str2num(answer{1});
% learning_rate:
parameter.learning_rate =str2num(answer{2});
% momentum value:
parameter.alfa =str2num(answer{3});
% regularization:
parameter.lambda =str2num(answer{4});
% epoch number(iteration):
iteration =str2num(answer{5});
% Number of samples;
number_of_training_samples =str2num(answer{6});
% number of layers:
L =str2num(answer{7});
% batch size(for mini batch training):
batch_size =str2num(answer{8});
% activation function type:
tanh_or_sigmoid = str2num(answer{9});

%% ===================================================================================================
%% Input Layer
% train_set = [number_of_input_neurons , number_of_training_samples]

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
    
    
end


%% Output Layer
    layer(L).Size=2;
    layer(L).wts.Size=[layer(L-1).Size+1,layer(L).Size];
    layer(L).wts.Type='double';
    layer(L).wts.Range=[];
    layer(L).wts = rand(layer(L-1).Size+1,layer(L).Size) * 2 * parameter.epsilon - parameter.epsilon;
    % Initialize Big DELTA of layers - (Big DELTA is notation of BaLkprppagation algorithm):
    layer(L).big_delta.Size=[layer(L-1).Size+1,layer(L).Size];
    layer(L).big_delta.Type='double';
    layer(L).big_delta.Range=[];
    layer(L).big_delta = zeros(layer(L-1).Size+1,layer(L).Size);
    % Initialize DELTA W last of layers - (DELTA W last is notation of momentum  :
    layer(L).delta_W_last.Size=[layer(L-1).Size+1,layer(L).Size];
    layer(L).delta_W_last.Type='double';
    layer(L).delta_W_last.Range=[];
    layer(L).delta_W_last = zeros(layer(L-1).Size+1,layer(L).Size);
    % Initialize DELTA of layers - (DELTA is notation of BaLkprppagation algorithm):
    layer(L).delta.Size=[layer(L).Size];
    layer(L).delta.Type='double';
    layer(L).delta.Range=[];
    layer(L).delta=zeros(1,layer(L).Size);
    % Initialize Big DELTA Bias of layers - (Big DELTA Bias is notation of BaLkprppagation algorithm):
    layer(L).big_delta_bias.Size=[layer(L).Size];
    layer(L).big_delta_bias.Type='double';
    layer(L).big_delta_bias.Range=[];
    layer(L).big_delta_bias=zeros(1,layer(L).Size);
    % Initialize aLtivation of layers:
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


%%
% delete Unnecessary and temp variable
clear('answer','defaultans','c','dlg_title','num_lines','one_or_multiple',...
    'op','prompt','temp','num_of_images','i');
%% =========== Forward and  Train Network =============
Train;



