%% =========== Start MR_MLP =============
clc;
clear all;

prompt = {'Method:(1 for Batch method - 0 for Online method)','Learning rate:','alfa:(Momentum coefficient)'...
    ,'lambda:(Regularization coefficient)','Validation check','Iteration','Number of samples',...
    'Number of layers','Batch size','Train(1) or Train2(2) or Train3(3) or Train4(4)',...
    'tanh or sigmoid(1 for tanh -2  for sigmoid)','Hoda(1) or MNIST(0)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','0.3','0.9','0','100','100','1000','3','100','3','2','1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

tmp = str2num(answer{12});
if (tmp == 1)
    hoda = true;
else
    hoda = false;
end

%% Hoda
if(hoda == true)
    
    %% =========== Laod Hoda Data set =============
    % load Hoda data set
%     load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_training_images(60000).mat');
%     load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_remaining_images(22352).mat');
%     load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_test_images(20000).mat');
%     
%     figure(4);
    % randomly show 60 numbers of test data
%     for i=1:60
%         subplot(6, 10, i);
%         rand_idx = randi(20000);
%         imshow(test_images(:,:,rand_idx));
%         title(test_labels(rand_idx));
%         axis square;
%     end

    
    

mimg=im2double(imread('F:\Documents\MATLAB\Machine Learning\MR  ML Project\MNIST\lena.jpg'));
nimg=mimg;
[M,N]=size(mimg);
cnt=0;
for i=1:M-3
    for j=1:N-3
        cnt=cnt+1;
        mpatch=mimg(i:i+2,j:j+2);
        mpatch=mpatch(:);
        npatch=nimg(i:i+2,j:j+2);
        npatch=npatch(:);
        patches(:,cnt)=npatch;
        opatches(:,cnt)=mpatch;
    end
end

    % Normalize the Image:
    for i=1:cnt
        min_ = min(opatches(:,i));
        max_ = max(opatches(:,i));
        range = max_ - min_;
       for j=1:9
           opatches(j,i)=(opatches(j,i)-min_) / range;
       end
        if(isnan(opatches(:,i)))
           opatches(:,i)=0;
        end
    end


    % training data
    trainig_inputs = reshape(opatches,[9,cnt]);
    number_of_training_samples = str2num(answer{7});
    number_of_input_neurons = 9;
    % test data
    test_inputs = reshape(opatches,[9,cnt]);
    
%     % validation data
%     % tmp = zeros(32,32,10000);
%     tmp = remaining_images(:,:,1:10000);
%     validation_images = reshape(tmp,[32*32,10000]);
%     validation_labels = remaining_labels(1:10000);
%     
    
    %     num_of_samples = num2str(number_of_training_samples);%sapmles
    
    % Targets
    labels = test_inputs;
    
%     tlabels = test_labels;
%     
%     timages = test_inputs;
%     
%     t_size =  size(test_inputs,2);
%     tsamples = t_size;
    
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
    
    
    
    
    % temp=strcat('Enter the Learning method(1 for Batch method or 0 for Online method) \n');
    % parameter.method = input(temp);
    parameter.method =str2num(answer{1});
    
    %set paremeters
    % temp=strcat('Enter the learning rate value \n');
    % parameter.learning_rate = input(temp);
    parameter.learning_rate =str2num(answer{2});
    
    %learning_rate=0.3;
    % temp=strcat('Enter the momentum value \n');
    % parameter.alfa = input(temp);
    parameter.alfa =str2num(answer{3});
    
    % temp=strcat('Enter the regularization value \n');
    % parameter.lambda = input(temp);
    parameter.lambda =str2num(answer{4});
    
    % temp=strcat('Enter the validation check value \n');
    % validation_check = input(temp);
    validation_check =str2num(answer{5});
    
    % epoch number
    % temp=strcat('Enter the iteration value \n');
    % iteration = input(temp);
    iteration =str2num(answer{6});
    
    % Number of samples
    % temp=strcat('Enter the number of samples \n');
    % samples = input(temp);
    number_of_training_samples =str2num(answer{7});
    
    % prompt = 'Enter the number of layers\n';
    % L = input(prompt);
    L =str2num(answer{8});
    
    % prompt = 'Enter the batch size(for mini batch training)\n';
    % L = input(prompt);
    batch_size =str2num(answer{9});
    
    % temp=strcat('Enter Train(1) or Train2_orig(2) or mini batch(3) or Train7(7) \n');
    train_file = str2num(answer{10});
    
    
    % temp=strcat('Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid\n');
    tanh_or_sigmoid = str2num(answer{11});
    
    
    
    
    layer(1).Size=number_of_input_neurons;
    layer(1).a.Size=[layer(1).Size];
    layer(1).a.Type='double';
    layer(1).a.Range=[];
    layer(1).a = zeros(layer(1).Size,number_of_training_samples);
    
    layer(1).a = trainig_inputs;%size input: number_of_input_neurons * number_of_samples
    
    
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
    %
    
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
    
    
else %% MNIST
    %% =========== Laod MNIST Dataset =============
    
    %Load MNIST Dataset
    Load_Data;
    
    figure(4);
    % randomly show 60 numbers of test data
    for i=1:60
        subplot(6, 10, i);
        rand_idx = randi(10000);
        imshow(reshape(timages(:,rand_idx),[28 28]));
        title(tlabels(rand_idx));
        axis square;
    end
    
    % validation_images = images(:,IND);
    % validation_labels = labels(IND);
    %
    % images(:,IND) = [];
    % labels(IND) = [];
    
    min_idx=1;
    max_idx=60000;
    idx = randperm(max_idx-min_idx+1,10000);
    
    validation_images = images(:,idx);
    validation_labels = labels(idx);
    
    images(:,idx) = [];
    labels(idx) = [];
    
    
    % =========== Create MLP Layer's  =============
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
    
    % temp=strcat('Enter the Learning method(1 for Batch method or 0 for Online method) \n');
    % parameter.method = input(temp);
    parameter.method =str2num(answer{1});
    
    %set paremeters
    % temp=strcat('Enter the learning rate value \n');
    % parameter.learning_rate = input(temp);
    parameter.learning_rate =str2num(answer{2});
    
    %learning_rate=0.3;
    % temp=strcat('Enter the momentum value \n');
    % parameter.alfa = input(temp);
    parameter.alfa =str2num(answer{3});
    
    % temp=strcat('Enter the regularization value \n');
    % parameter.lambda = input(temp);
    parameter.lambda =str2num(answer{4});
    
    % temp=strcat('Enter the validation check value \n');
    % validation_check = input(temp);
    validation_check =str2num(answer{5});
    
    % epoch number
    % temp=strcat('Enter the iteration value \n');
    % iteration = input(temp);
    iteration =str2num(answer{6});
    
    % Number of samples
    % temp=strcat('Enter the number of samples \n');
    % samples = input(temp);
    tmp =str2num(answer{7});
    if tmp<=50000
        samples = tmp;
    else
        samples = 50000;
    end
    % prompt = 'Enter the number of layers\n';
    % L = input(prompt);
    L =str2num(answer{8});
    
    prompt = 'Enter the batch size(for mini batch training)\n';
    % L = input(prompt);
    batch_size =str2num(answer{9});
    
    % temp=strcat('Enter Train(1) or Train2_orig(2) or mini batch(3) or Train7(7) \n');
    train_file = str2num(answer{10});
    
    
    % temp=strcat('Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid\n');
    tanh_or_sigmoid = str2num(answer{11});
    
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
    
    % =========== Forward and  Train MLP =============
    %
%     close all;
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
    
    
    
    
    
    
end

