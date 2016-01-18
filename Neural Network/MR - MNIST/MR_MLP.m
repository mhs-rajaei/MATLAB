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

prompt = {'parameter.method:','parameter.learning_rate:','parameter.alfa:'...
    ,'parameter.lambda:','validation_check:','iteration:','samples:','L:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','0.3','0.9','0','10','100','1000','3'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


temp=strcat('Enter the Learning method(1 for Batch method or 0 for Online method) \n');
% parameter.method = input(temp);
parameter.method =answer{1};

%set paremeters
temp=strcat('Enter the learning rate value \n');
% parameter.learning_rate = input(temp);
parameter.learning_rate =answer{2};

%learning_rate=0.3;
temp=strcat('Enter the momentum value \n');
% parameter.alfa = input(temp);
parameter.alfa =answer{3};

temp=strcat('Enter the regularization value \n');
% parameter.lambda = input(temp);
parameter.lambda =answer{4};

temp=strcat('Enter the validation check value \n');
% validation_check = input(temp);
validation_check =answer{5};

% epoch number
temp=strcat('Enter the iteration value \n');
% iteration = input(temp);
iteration =answer{6};

% Number of samples
temp=strcat('Enter the number of samples \n');
% samples = input(temp);
samples =answer{7};

prompt = 'Enter the number of layers\n';
% L = input(prompt);
L =answer{8};
trrr= char(L);
%Mohsen
% set layers parameters
for c=1:trrr
 
    if(c==1)
        temp=strcat('Enter numbers of INPUTS (number of neuron in first layer)  \n');
        layer(c).Size=input(temp);
       
        layer(c).a.Size=[layer(c).Size];
        layer(c).a.Type='double';
        layer(c).a.Range=[];
        layer(c).a = zeros(layer(c).Size,samples);

    else
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
    
end
% layer(L).MSE = zeros(10,samples);
% layer(L).MSE_2 = zeros(10,samples);
layer(1).a(1:layer(1).Size,1:samples) = images(1:layer(1).Size,1:samples);
tic;


temp=strcat('Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid\n');
tanh_or_sigmoid = input(temp);

%% =========== Forward and  Train MLP =============
% 
temp=strcat('Enter Train(1) or Train2_orig(2) or Train7(7)\n');
train_c = input(temp);
if train_c == 1
    Train;
elseif train_c==2
    Train2_orig;
elseif train_c==7
        Train7;
end

%%


