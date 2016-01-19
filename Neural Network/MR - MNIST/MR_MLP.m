%% =========== Start Project =============
%
%
%
clear all;
%clc;


%% =========== Laod MNIST Dataset =============
%
%
%
%Load MNIST Dataset
Load_Data;

validation_images = images(:,IND);
validation_labels = labels(IND);

images(:,IND) = [];
labels(IND) = [];

%% =========== Create MLP Layer's  =============
%
%
%
% struct for layers of MLP
layer = struct('Size',[],'wts',[],'z',[],'a',[],'delta',[],'DW',[]...
    ,'bias',[],'MSE',[],'delta_W',[],'delta_bias',[],'big_delta',[],...
    'big_delta_bias',[],'delta_W_last',[]);
parameter = struct('learning_rate',[],'alfa',[],'lambda',[],'epsilon',[],'method',[]);
%value epsilon use for initialize random weights
parameter.epsilon = 0.12;

prompt = {'Method:(1 for Batch method - 0 for Online method)','Learning rate:','alfa:(Momentum coefficient)'...
    ,'lambda:(Regularization coefficient','Validation check:','Iteration:','Samples:','Number of layers:','Batch size: '};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','0.3','0.9','0','10','100','1000','3','20'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


temp=strcat('Enter the Learning method(1 for Batch method or 0 for Online method) \n');
% parameter.method = input(temp);
parameter.method =str2num(answer{1});

%set paremeters
temp=strcat('Enter the learning rate value \n');
% parameter.learning_rate = input(temp);
parameter.learning_rate =str2num(answer{2});

%learning_rate=0.3;
temp=strcat('Enter the momentum value \n');
% parameter.alfa = input(temp);
parameter.alfa =str2num(answer{3});

temp=strcat('Enter the regularization value \n');
% parameter.lambda = input(temp);
parameter.lambda =str2num(answer{4});

temp=strcat('Enter the validation check value \n');
% validation_check = input(temp);
validation_check =str2num(answer{5});

% epoch number
temp=strcat('Enter the iteration value \n');
% iteration = input(temp);
iteration =str2num(answer{6});

% Number of samples
temp=strcat('Enter the number of samples \n');
% samples = input(temp);
samples =str2num(answer{7});

prompt = 'Enter the number of layers\n';
% L = input(prompt);
L =str2num(answer{8});

prompt = 'Enter the batch size(for mini batch training)\n';
% L = input(prompt);
batch_size =str2num(answer{9});

layer(1).Size=784;
layer(1).a.Size=[layer(1).Size];
layer(1).a.Type='double';
layer(1).a.Range=[];
layer(1).a = zeros(layer(1).Size,samples);


% set layers parameters
for c=2:L
    if(c==L)
        temp=strcat('Enter numbers of OUTPUTS (number of neuron in last layer) \n');
    else
        temp=strcat('Enter numbers of nodes layer',num2str(c),'\n');
    end
    
    layer(c).Size=input(temp);
    layer(c).wts.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).wts.Type='double';
    layer(c).wts.Range=[];
    layer(c).wts = rand(layer(c-1).Size+1,layer(c).Size) * 2 * parameter.epsilon - parameter.epsilon;
    
    layer(c).big_delta.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).big_delta.Type='double';
    layer(c).big_delta.Range=[];
    layer(c).big_delta = zeros(layer(c-1).Size+1,layer(c).Size);
    
    
    layer(c).delta_W_last.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).delta_W_last.Type='double';
    layer(c).delta_W_last.Range=[];
    layer(c).delta_W_last = zeros(layer(c-1).Size+1,layer(c).Size);
    
    layer(c).DW.Size=[layer(c-1).Size+1,layer(c).Size];
    layer(c).DW.Type='double';
    layer(c).DW.Range=[];
    layer(c).DW = zeros(layer(c-1).Size+1,layer(c).Size);
    
    layer(c).delta.Size=[layer(c).Size];
    layer(c).delta.Type='double';
    layer(c).delta.Range=[];
    layer(c).delta=zeros(1,layer(c).Size);
    
    
    layer(c).big_delta_bias.Size=[layer(c).Size];
    layer(c).big_delta_bias.Type='double';
    layer(c).big_delta_bias.Range=[];
    layer(c).big_delta_bias=zeros(1,layer(c).Size);
    
    layer(c).z.Size=[layer(c).Size];
    layer(c).z.Type='double';
    layer(c).z.Range=[];
    layer(c).z = zeros(1,layer(c).Size);
    
    layer(c).a.Size=[layer(c).Size];
    layer(c).a.Type='double';
    layer(c).a.Range=[];
    layer(c).a = zeros(1,layer(c).Size);
    
    layer(c).bias.Size=1;
    layer(c).bias.Type='double';
    layer(c).bias.Range=[];
    layer(c).bias=1;
    
    layer(c).delta_bias.Size=1;
    layer(c).delta_bias.Type='double';
    layer(c).delta_bias.Range=[];
    layer(c).delta_bias=zeros();
    
end

layer(1).a(1:layer(1).Size,1:samples) = images(1:layer(1).Size,1:samples);
tic;


temp=strcat('Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid\n');
tanh_or_sigmoid = input(temp);

%% =========== Forward and  Train MLP =============
%
temp=strcat('Enter Train(1) or Train2_orig(2) or mini batch(3) or Train7(7) \n');
train_c = input(temp);
if train_c == 1
    Train;
elseif train_c==2
    Train2_orig;
elseif train_c==7
    Train7;
elseif train_c==3
    mini_batch;
end

%%


