% mini batch   + regularization   +momentum
%% =========== Forward : Computing Delta's : Update Weights =============
delta_W=zeros();
delta_W_last=zeros();
delta_theta=zeros();

samples  =number_of_training_samples;

index = 1;
MSE = zeros(1,iteration);
layer(L).MSE = zeros(layer(L).Size,samples);

counter = 0;

for epoch=1:iteration % forward and update weight's in number of  iterations
    % after each iteration we must set bellow paramet to zero
    delta_W=zeros();
    delta_theta=zeros();
    for num_in=1:samples
        %% =========== Forward =============
        counter = counter +1;
        %% Forward inputs
        for c=2:L
            % for layer 2
            if c==2
                layer(c).z = (layer(c-1).a(:,num_in))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
                % for other layers
            else
                layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            end
            % check for NaN
            if isnan(layer(c).z)
                fprintf('\n');fprintf('\n'); fprintf('Please Change input parameter to prevent NaN in Calculation');
                error('Error We Find NaN in Calculation!!!!!!!!!!!!!!!');
            end
            % activation function
            if tanh_or_sigmoid==1 %tanh
                layer(c).a = tanhyp(layer(c).z);
            else %sigmoid
                layer(c).a = sigmoid(layer(c).z);
            end
        end
        
        %% =========== Computing MSE  =================
        layer(L).MSE(:,num_in) = (train_labels(num_in,:) - layer(L).a).^2;
        %% =========== Computing Delta's  =============
        
        % output DELTA
        layer(L).delta = -(train_labels(num_in,:) - layer(L).a);
        
        % Compute Other Delta's
        hl=L-1;
        while(hl>1)
            % activation function
            if tanh_or_sigmoid==1 %tanh
                layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                    tanhypGradient(layer(hl).z) ;
            else %sigmoid
                layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                    sigmoidGradient(layer(hl).z);
            end
            
            hl = hl-1;
        end
        
        
        %% ===========  Update Weights =============
        %
        up_ind=L;
        while(up_ind>1)
            
            if up_ind==2
                if parameter.method == 1 % batch method
                    %% BIG DELTA Weights Batch for INPUT's(L(1))
                    layer(up_ind).big_delta(1:end-1,:) = ((layer(up_ind-1).a(:,num_in)) *...
                        layer(up_ind).delta) + ...
                        layer(up_ind).big_delta(1:end-1,:);
                    
                    %% BIG DELTA BIAS's Batch for INPUT's(L(1))
                    layer(up_ind).big_delta_bias = layer(up_ind).delta + ...
                        layer(up_ind).big_delta_bias;
                    
                else % online method
                    %% BIG DELTA Weights ONLINE for L(1)
                    delta_W =   ((layer(up_ind-1).a(:,num_in)) *...
                        layer(up_ind).delta);
                    delta_theta =  layer(up_ind).delta;
                end
            else
                %% BIG DELTA Weights Batch for L(2)...L(L)
                if parameter.method == 1
                    layer(up_ind).big_delta(1:end-1,:) = (layer(up_ind-1).a' *...
                        layer(up_ind).delta) +...
                        layer(up_ind).big_delta(1:end-1,:);
                    
                    %% BIG DELTA BIAS's Batch for L(2)...L(L)
                    layer(up_ind).big_delta_bias = layer(up_ind).delta +...
                        layer(up_ind).big_delta_bias;
                    
                else % online method
                    %% BIG DELTA Weights ONLINE for L(2)...L(L)
                    delta_W = (layer(up_ind-1).a' * layer(up_ind).delta) ;%%%%%
                    delta_theta = layer(up_ind).delta ;
                end
            end
            %%
            %%Update Weight's layer i or update weights from i-1 to i
            if parameter.method == 0 % online method
                % Update Weight's
                layer(up_ind).wts(1:end-1,:) =  layer(up_ind).wts(1:end-1,:) - parameter.learning_rate .* delta_W -...
                    (parameter.alfa  * layer(up_ind).delta_W_last(1:end-1,:)) -...
                    parameter.lambda * parameter.learning_rate * (layer(up_ind).wts(1:end-1,:));
                layer(up_ind).delta_W_last(1:end-1,:) = delta_W;
                delta_W = zeros();
                % Update Bias
                layer(up_ind).wts(end,:) = layer(up_ind).wts(end,:) - parameter.learning_rate .* delta_theta -...
                    (parameter.alfa  * layer(up_ind).delta_W_last(end,:));
                layer(up_ind).delta_W_last(end,:)  = delta_theta;
                delta_theta = zeros();
                
            end % end if
            
            
            up_ind = up_ind-1;
        end
        
        if counter == batch_size
            if parameter.method == 1 % batch method
                for i=2:L
                    % Update Weight's
                    layer(i).wts(1:end-1,:) =  layer(i).wts(1:end-1,:) - (1/batch_size) * parameter.learning_rate .* layer(i).big_delta(1:end-1,:) + ...
                        parameter.lambda * parameter.learning_rate * (layer(i).wts(1:end-1,:)) - ...
                        (parameter.alfa  *  layer(i).delta_W_last(1:end-1,:));
                    % Last DELTA W Weights
                    layer(i).delta_W_last(1:end-1,:) = (1/batch_size) *layer(i).big_delta(1:end-1,:);
                    layer(i).big_delta= zeros(layer(i-1).Size+1,layer(i).Size);
                    
                    % Update Bias
                    layer(i).wts(end,:) =layer(i).wts(end,:) - (1/batch_size)* parameter.learning_rate .* layer(i).big_delta_bias -...
                        (parameter.alfa  *  layer(i).delta_W_last(end,:));
                    % Last DELTA W Weights
                    layer(i).delta_W_last(end,:) = (1/batch_size)*layer(i).big_delta_bias;
                    layer(i).big_delta_bias=zeros(1,layer(i).Size);
                    
                end
            end
            counter = 0;
        end
        
    end
    
    
    %% Compute Overal MSE
    MSE(epoch) = (sum(layer(L).MSE(:))^0.5) / samples;
    fprintf(num2str(MSE(epoch)));
    fprintf('\n');
    
    %% Showing Autoencoder image
    %     result = layer(L).a;
    %     dim = 227;
    %     tmp2 = reshape(result,[dim dim]);
    %     figure;
    %     imshow(tmp2);
    %     title('Autoencoder image');
    %     pause;
    
end


%% Showing Autoencoder image
result = layer(L).a;
dim = 227;
tmp2 = reshape(result,[dim dim]);
figure;
imshow(tmp2);
title('Autoencoder image');
%% Showing original image
figure;
imshow(input_image);
title('Original image');

%% Showing Extracted features
result = layer(floor(L/2)).a;
dim = floor(sqrt(length(layer(floor(L/2)).a)));
tmp2 = reshape(result(:,1:dim*dim),[dim dim]);
figure;
imshow(tmp2);
title('Extracted feature image');
%%
draw_MSE(MSE);

toc;


