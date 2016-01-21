clear;
close all;
clc
%add pre MatConvNet setup
vl_setupnn;
% --------------------------------------------------------------------
%                                                         options
% --------------------------------------------------------------------
% opts.dataDir = fullfile('data','mnist') ;
opts.train.batchSize = 20;
opts.train.numEpochs = 50 ;
opts.train.learningRate = 0.001 ;




% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------
imdb = getJaffeImdb('F:\Documents\MATLAB\Neural Network\HW3\jaffe\data\jaffeTrain','F:\Documents\MATLAB\Neural Network\HW3\jaffe\data\jaffeTest',[256 256 1]);

imageMean = mean(imdb.images.data(:)) ;
imdb.images.data = imdb.images.data - imageMean ;


Factor=0.01 ;
net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{Factor*randn(9,9,1,7, 'single'), zeros(1, 7, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
                       
                       net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [4 4], ...
                           'stride', 4, ...
                           'pad', 0) ;
                       net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{Factor*randn(7,7,7,7, 'single'), zeros(1, 7, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
                       net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [4 4], ...
                           'stride', 4, ...
                           'pad', 0) ;
                        net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{Factor*randn(5,5,7,7, 'single'), zeros(1, 7, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
                       net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
                       net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{Factor*randn(5,5,7,7, 'single'), zeros(1, 7, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
                      
                         
                      
                       
                       
net.layers{end+1} = struct('type', 'softmaxloss') ;


% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

 [net, info] = cnn_train(net, imdb, @getBatch, ...
     opts.train, ...
     'val', find(imdb.images.set == 3)) ;
