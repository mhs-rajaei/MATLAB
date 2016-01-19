%% ============ Load data  ========
% clear all;
% clc;
% Load_Data;
% validation_images = images(:,IND);
% validation_labels = labels(IND);
% 
% total_images = zeros(784,70000);
% total_images(:,1:end-10000)= images;
% total_images(:,60001:end)= timages;
% total_labels = zeros(70000,1);
% total_labels(1:60000,:) = labels; 
% total_labels(60001:end,:) = tlabels;

%% ======  Initializing...
% vector_target = Target_to_Vector(total_labels);
% MLP_Inputss + Targets
% MLP_Inputss = MLP_Inputs';
% targets = Target';
% Choose a Logestic Function
TF={'logsig'};
%% Choose a Training Function
%For a list of all training functions type: help nntrain

%'trainbr' takes longer but may be better for challenging problems.

%'trainscg' uses less memory. Suitable in low memory situations.

% BTF = 'trainlm'; % Levenberg-Marquardt

% BTF = 'trainb';% batch training

% BTF = 'traingdm';%  gradient descent with momentum

BTF = 'traingdx';% gradient descent momentum + Adaptive learning rate

%%
% Create a feed forward neural network with hidden Layer Size 15
hiddenLayerSize = 1;
mlp = newff(MLP_Inputs',Target',[10],TF,BTF);
%% Set Training, Validation & Test Data with Performance Function & Plots
% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
mlp.divideFcn = 'dividerand';  % Divide data randomly
mlp.divideMode = 'sample';  % Divide up every sample
mlp.divideParam.trainRatio = 80/100;
mlp.divideParam.valRatio = 0/100;
mlp.divideParam.testRatio = 20/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
% mlp.performFcn = 'mse';  % Mean squared error
mlp.performFcn = 'crossentropy';  % Cross-Entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
mlp.plotFcns = {'plotperform','ploterrhist','plotregression','plotfit'};

mlp.trainParam.epochs=1000;% number of epoch's
% net.trainParam.goal=1e-8;% maximum goal for stop rule
mlp.trainParam.max_fail=200;% maximum failof training and validation set
view(mlp);% shows the MLP
%% Train the Network
[mlp,tr] = train(mlp,MLP_Inputs',Target');
%% Test the Network
y = mlp(MLP_Inputs');
e = gsubtract(Target',y);
performance = perform(mlp,Target',y);
tind = vec2ind(Target');
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);


