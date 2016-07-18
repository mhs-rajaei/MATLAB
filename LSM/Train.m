% +mini batch   +regularization   +momentum   +adaptive learning rate
%% =========== Forward : Computing Delta's : Update Weights =============
delta_W=zeros();
delta_theta=zeros();

samples = number_of_training_samples;

index = 1;
MSE = zeros(1,iteration);
layer(2).MSE = zeros(10,samples);

for epoch=1:iteration % forward and update weight's in number of  iterations
    delta_W=zeros();
    delta_theta=zeros();
    for num_in=1:samples
        %% =========== Forward =============
        
        target = Target(train_labels(num_in),layer(2).Size);
        
        layer(2).z = (layer(1).a(:,num_in))'*(layer(2).wts(1:end-1,:))+(layer(2).bias*layer(2).wts(end,:));
        
        layer(2).a = sigmoid(layer(2).z);
        
        % =========== Computing MSE  =================
        layer(2).MSE(:,num_in) = sum((target - layer(2).a).^2);

        %% ===========  Update Weights =============
            layer(2).wts(1:end-1,:) =  layer(2).wts(1:end-1,:) - ...
                learning_rate .* ((layer(1).a(:,num_in)) * -(target - layer(2).a));
            delta_W = zeros();
            % Update Bias
            layer(2).wts(end,:) = layer(2).wts(end,:) - learning_rate .* -(target - layer(2).a);
    end
    
    %% Overal MSE
    MSE(epoch) = (sum(layer(2).MSE(:))^0.5) / samples;
    
    
end


draw_MSE(MSE);


