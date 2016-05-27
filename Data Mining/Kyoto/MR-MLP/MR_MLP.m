%% =========== Start MR_MLP =============
% function MR_MLP(train_set,train_labels,  test_set,test_labels  ,validation_set,validation_labels)
% train_set = [input_nurons , number_of_training_samples]
% train_labels = [number_of_training_samples , number of output neurons]
% target = [1 , number of output neurons] 
clear all;

[training_data,~,~] = xlsread('F:\Documents\R\Kyoto\Processed Dataset\train2\CSV\1.csv');
%% preparing target labels
% train targets
train_labels = zeros(2,size(training_data,1))';
for i=1:size(training_data,1)
    if training_data(i,size(training_data,2))==0
        train_labels(i,1) = 1;
    else
        train_labels(i,2) = 1;
    end
end
[validation_data,~,~] = xlsread('F:\Documents\R\Kyoto\Processed Dataset\test2-2\CSV\test2-2.csv');
% validation targets
validation_labels = zeros(2,size(validation_data,1))';
for i=1:size(validation_data,1)
    if validation_data(i,size(validation_data,2))==0
        validation_labels(i,1) = 1;
    else
        validation_labels(i,2) = 1;
    end
end

[test_data,~,~] = xlsread('F:\Documents\R\Kyoto\Processed Dataset\test2-1\CSV\test2-1.csv');
% test targets
test_labels = zeros(2,size(test_data,1))';
for i=1:size(test_data,1)
    if test_data(i,size(test_data,2))==0
        test_labels(i,1) = 1;
    else
        test_labels(i,2) = 1;
    end
end
% 
% train_set = [input_nurons , number_of_training_samples]
% train_labels = [number_of_training_samples , number of output neurons]
% target = [1 , number of output neurons]
train_set = training_data(:,1:size(training_data,2)-1)';
clear('training_data')
validation_set = validation_data(:,1:size(validation_data,2)-1)';
clear('validation_data')
test_set = test_data(:,1:size(test_data,2)-1)';
clear('test_data')

%% input dialog
prompt = {'Method:(1 for Batch method - 0 for Online method)','Learning rate:','alfa:(Momentum coefficient)'...
    ,'lambda:(Regularization coefficient)','Validation check','Iteration','Number of samples',...
    'Number of layers','Batch size','tanh or sigmoid(1 for tanh -2  for sigmoid)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','0.3','0','0','100','300',num2str(size(train_set,2)),'3','10000','1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

    %% =========== Create MLP Layer's  =====================================================
    % struct for layers of MLP
    layer = struct('Size',[],'wts',[],'z',[],'a',[],'delta',[],'DW',[]...
        ,'bias',[],'MSE',[],'delta_W',[],'delta_bias',[],'big_delta',[],...
        'big_delta_bias',[],'delta_W_last',[]);
    parameter = struct('learning_rate',[],'alfa',[],'lambda',[],'epsilon',[],'method',[]);
    %% =======================set paremeters==========================
    %value epsilon use for initialize random weights
    parameter.epsilon = 0.12;
    % learning method(online or batch)
    parameter.method =str2num(answer{1});
    % learning_rate
    parameter.learning_rate =str2num(answer{2});
    % momentum value
    parameter.alfa =str2num(answer{3});
    % regularization
    parameter.lambda =str2num(answer{4});
    % validation check value
    validation_check =str2num(answer{5});
    % epoch number(iteration)
    iteration =str2num(answer{6});
    % Number of samples
    number_of_training_samples =str2num(answer{7});
    % number of layers
    L =str2num(answer{8});
    % batch size(for mini batch training)\n';
    batch_size =str2num(answer{9});
    % temp=strcat('Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid\n');
    tanh_or_sigmoid = str2num(answer{10});
     % training data
%% ===================================================================================================
    % train_set = [number_of_input_neurons , number_of_training_samples]
    number_of_input_neurons = size(train_set,1);
    
    layer(1).Size=number_of_input_neurons;
    layer(1).a.Size=[layer(1).Size];
    layer(1).a.Type='double';
    layer(1).a.Range=[];
    layer(1).a = zeros(layer(1).Size,number_of_training_samples);
    
    layer(1).a = train_set(1:number_of_input_neurons,1:number_of_training_samples);
%     clear('train_set')
%     layer(1).a(1:layer(1).Size,1:samples) = images(1:layer(1).Size,1:samples);
    
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
    
    tic;
    
    %% =========== Forward and  Train MLP =============
   
    % Training
    Train;

% end

   
    
    
    
    
    
    


