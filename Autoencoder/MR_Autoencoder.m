%% =========== Start MR_Autoencoder =============
close all;clear all;clc;
%% Prepare Inputs:
%% Read Images & Targets & etc
op = strcat('Do you want to read a image or multiple image from directory?( 1 for yes and other numbers for no\n');
one_or_multiple = input(op);
if one_or_multiple == 1
    %% Load one images
    % read a image
    input_image=imread('F:\Documents\MATLAB\Data\Autoencoder\1.jpg');
    
    % convert to grayscale
    input_image = rgb2gray(input_image);
    
    % set hight and width for resizing
    hight = 227;
    width = 227;
    % resize image
    image_ = imresize(input_image,[hight,width]); %resize size(fixd size);
    % convert to double
    converted_image_2_double = im2double(image_);
    
    % Normalize the Image with Min Max Normalization in boundary [0,]
    im_Range = getrangefromclass(converted_image_2_double(1));
    Max_range = im_Range(2);
    Min_range = im_Range(1);
    nomalized_image = (converted_image_2_double - min(converted_image_2_double(:)))*...
        (Max_range - Min_range)/(max(converted_image_2_double(:)) - min(converted_image_2_double(:))) + Min_range;
    % reshape as single vector
    tmp = reshape(nomalized_image, [1,227*227]);
    %% set trangnig set and training lable
    train_set = tmp';
    train_labels = tmp;
    %% Load images in directory
else
    % this function read all images in a directory recursively and create
    % two set: training set and test set
    Data = grayscale_load_image('F:\Documents\MATLAB\Data\Airplane Images\0',...
        15,227,227,'false','false');
    
    num_of_images = size(Data.training_images,3);
    train_set = zeros(227*227,num_of_images);
    % train_labels = zeros(num_of_images,227*227);
    
    for i=1:num_of_images
        train_set(:,i) = reshape(Data.training_images(:,:,i), [1,227*227]);
    end
    
    train_labels = train_set';
    
end


%% input dialog
prompt = {'Method:(1 for Batch method - 0 for Online method)','Learning rate:','alfa:(Momentum coefficient)'...
    ,'lambda:(Regularization coefficient)','Iteration','Number of samples',...
    'Number of layers','Batch size','tanh or sigmoid(1 for tanh -2  for sigmoid)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'0','0.3','0','0','100',num2str(size(train_set,2)),'3','2','2'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

%% =========== Create MLP Layer's  =====================================================
% struct of network layers
layer = struct('Size',[],'wts',[],'a',[],'delta',[],...
    'bias',[],'MSE',[],'delta_W',[],'big_delta',[],...
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
% epoch number(iteration)
iteration =str2num(answer{5});
% Number of samples
number_of_training_samples =str2num(answer{6});
% number of layers
L =str2num(answer{7});
% batch size(for mini batch training)\n';
batch_size =str2num(answer{8});
% temp=strcat('Enter tanh(1) or sigmoid(2) (1 for tanh and 2  for sigmoid\n');
tanh_or_sigmoid = str2num(answer{9});
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

% set layers parameters
for c=2:L
    temp=strcat('Enter numbers of nodes layer',num2str(c),'\n');
    
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
    
    layer(c).delta.Size=[layer(c).Size];
    layer(c).delta.Type='double';
    layer(c).delta.Range=[];
    layer(c).delta=zeros(1,layer(c).Size);
    
    
    layer(c).big_delta_bias.Size=[layer(c).Size];
    layer(c).big_delta_bias.Type='double';
    layer(c).big_delta_bias.Range=[];
    layer(c).big_delta_bias=zeros(1,layer(c).Size);
    
    layer(c).a.Size=[layer(c).Size];
    layer(c).a.Type='double';
    layer(c).a.Range=[];
    layer(c).a = zeros(1,layer(c).Size);
    
    layer(c).bias.Size=1;
    layer(c).bias.Type='double';
    layer(c).bias.Range=[];
    layer(c).bias=1;
    
    
end

%% Add mirror layer

i=0;
for c=(L+1):(2*L)
    
    %     layer(c) = layer(L-i);
    
    layer(c).Size=layer(L-i).Size;
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
    
    layer(c).delta.Size=[layer(c).Size];
    layer(c).delta.Type='double';
    layer(c).delta.Range=[];
    layer(c).delta=zeros(1,layer(c).Size);
    
    
    layer(c).big_delta_bias.Size=[layer(c).Size];
    layer(c).big_delta_bias.Type='double';
    layer(c).big_delta_bias.Range=[];
    layer(c).big_delta_bias=zeros(1,layer(c).Size);
    
    layer(c).a.Size=[layer(c).Size];
    layer(c).a.Type='double';
    layer(c).a.Range=[];
    layer(c).a = zeros(1,layer(c).Size);
    
    layer(c).bias.Size=1;
    layer(c).bias.Type='double';
    layer(c).bias.Range=[];
    layer(c).bias=1;
    
    
    
    i = i + 1 ;
end


%
L = 2*L;

tic;

%% =========== Forward and  Train MLP =============
clear('answer','defaultans','c','dlg_title','num_lines','one_or_multiple',...
    'op','prompt','temp','num_of_images','i');
% Training
Train;











