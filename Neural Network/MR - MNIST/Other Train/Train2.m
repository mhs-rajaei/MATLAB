%% =========== Forward : Computing Delta's : Update Weights =============
delta_W=zeros();
delta_W_last=zeros();
delta_theta=zeros();
delta_theta_last=zeros();

Accuracy_Train = zeros(1,iteration);
Accuracy_Test = zeros(1,iteration);
Accuracy_Validation = zeros(1,iteration);
check_validation = zeros(1,validation_check);


validation = 0;
index = 1;
MSE = zeros(1,iteration);
layer(L).MSE = zeros(10,samples);
% layer(L).MSE2 = zeros(10,samples);

for epoch=1:iteration % forward and update weight's in number of  iterations
    delta_W=zeros();
    delta_theta=zeros();
    for num_in=1:samples
        %% =========== Forward =============
        
        target = Target(labels(num_in),layer(L).Size);
        
        for c=2:L
                elm_sum = zeros();
                if c==2
                    elm_sum = (layer(c-1).a(:,num_in))'*(layer(c).wts(1:end-1,:));
                else
                    elm_sum = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:));
                end
                % add bias
                elm_sum = (layer(c).bias*layer(c).wts(end,:))+elm_sum;
            
                 if isnan(elm_sum)
                    fprintf('\n');
                    fprintf('\n');
                    fprintf('Please Change input parameter to prevent NaN in Calculation');
                    error('Error We Find NaN in Calculation!!!!!!!!!!!!!!!');
                 end
                
                layer(c).z=(elm_sum);
                
                layer(c).a = sigmoid(layer(c).z); 
        end
        
        % =========== Computing MSE  =============
        layer(L).MSE(:,num_in) = (layer(L).a - target).^2;
        % =========== Computing Delta's  =============
        
        
        %% Compute Output Delta
        
        layer(L).delta = (layer(L).a - target);
        
        % Compute Other Delta's
        hl=L-1;
        while(hl>1)
            layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                layer(hl).a .* (1-layer(hl).a); % or sigmoidGradient(layer(hl).z)
            hl=hl-1;
        end
        
        
        
        
        %% ===========  Update Weights =============
        %
        up_ind=L;
        while(up_ind>1)
%             for i=2:L
                if up_ind==2
                    if parameter.method == 1 % batch method
                        %% BIG DELTA Weights Batch for INPUT's(L(1))
                        layer(up_ind).big_delta(1:end-1,:) =  -parameter.learning_rate .* ...
                            ((layer(up_ind-1).a(:,num_in)) * layer(up_ind).delta) + ...
                            layer(up_ind).big_delta(1:end-1,:);

                        %% BIG DELTA BIAS's Batch for INPUT's(L(1))
                        layer(up_ind).big_delta_bias = -parameter.learning_rate .* layer(up_ind).delta + ...
                            layer(up_ind).big_delta_bias;
                        
                    else % online method
                         %% BIG DELTA Weights ONLINE for L(1)
                        delta_W =  -parameter.learning_rate .* ((layer(up_ind-1).a(:,num_in)) *...
                            layer(up_ind).delta);
                        delta_theta = -parameter.learning_rate .* layer(up_ind).delta;
                    end
                else
                    %% BIG DELTA Weights Batch for L(2)...L(L)
                    if parameter.method == 1
                        layer(up_ind).big_delta(1:end-1,:) =  -parameter.learning_rate .*...
                            (layer(up_ind-1).a' * layer(up_ind).delta) +...
                            layer(up_ind).big_delta(1:end-1,:);

                        %% BIG DELTA BIAS's Batch for L(2)...L(L)
                        layer(up_ind).big_delta_bias =  -parameter.learning_rate .* layer(up_ind).delta +...
                            layer(up_ind).big_delta_bias;
                    else % online method
                         %% BIG DELTA Weights ONLINE for L(2)...L(L)
                        delta_W = -parameter.learning_rate.* (layer(up_ind-1).a' * layer(up_ind).delta) ;
                        delta_theta = -parameter.learning_rate .* layer(up_ind).delta ;   
                        
                    end
                end
                %%
                %%Update Weight's layer i or update weights from i-1 to i
                 if parameter.method == 0 % online method
                    % Update Weight's
                    layer(up_ind).wts(1:end-1,:) =  layer(up_ind).wts(1:end-1,:) +...
                        delta_W + (parameter.alfa  * layer(up_ind).delta_W_last(1:end-1,:)) -...
                        parameter.lambda * parameter.learning_rate * (layer(up_ind).wts(1:end-1,:));
                    layer(up_ind).delta_W_last(1:end-1,:) = delta_W;
                    % Update Bias
                    layer(up_ind).wts(end,:) = layer(up_ind).wts(end,:) +...
                        delta_theta + (parameter.alfa  * layer(up_ind).delta_W_last(end,:));
                    layer(up_ind).delta_W_last(end,:)  = delta_theta;   
                 end % end if
                 
                
                up_ind = up_ind-1;
        end
            
        end

    %%
        if parameter.method == 1 % batch method
            for i=2:L
                % Update Weight's
                layer(i).wts(1:end-1,:) = (1/samples) *layer(i).big_delta(1:end-1,:) - ...
                    parameter.lambda * parameter.learning_rate * (layer(i).wts(1:end-1,:)) + ...
                    (parameter.alfa  *  layer(i).delta_W_last(1:end-1,:));
%               % Last DELTA W Weights
                layer(i).delta_W_last(1:end-1,:) = layer(i).wts(1:end-1,:);
                % Update Bias
                layer(i).wts(end,:) = (1/samples)*layer(i).big_delta_bias +...
                    (parameter.alfa  *  layer(i).delta_W_last(end,:));
%               % Last DELTA W Weights
                layer(i).delta_W_last(end,:) = layer(i).wts(end,:);
                  
            end
        end
    
     %% TEST & Accuracy & MSE
     
        Train_or_Test = 0;% accuracy on Train Data
        Accuracy_Train(epoch) = Test(layer,samples,Train_or_Test,L,labels,images)/samples;
        %
        if samples >= 10000
            tsamples = 10000;
        else
            tsamples = samples;
        end
        
        Train_or_Test = 1;% accuracy on Test Data
        Accuracy_Test(epoch) = Test(layer,tsamples,Train_or_Test,L,tlabels,timages)/tsamples;
        %
        Train_or_Test = 2;% accuracy on Validation Data
        Accuracy_Validation(epoch) = Test(layer,tsamples,Train_or_Test,L,validation_labels,...
            validation_images)/tsamples;
        
        % Compute Overal MSE
        MSE(epoch) = (sum(layer(L).MSE(:))^0.5) / samples;
        
        %% Validation check
        if epoch == 1
            validation = Accuracy_Validation(epoch);
        end
        
        if check_validation(1,validation_check) == 1
            break;
        elseif Accuracy_Validation(epoch)<=validation
            check_validation(1,index)=1;
            index = index+1;
        else
            validation = Accuracy_Validation(epoch);
        end
        
    %%
end
    
%     displayData(layer(L).wts(:,end-1));

toc;
    
