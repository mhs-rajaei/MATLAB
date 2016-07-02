% -mini batch +regularization +momentum +adaptive learning rate 

%% =========== Forward : Computing Delta's : Update Weights =============
training_samples = number_of_training_samples;
samples = training_samples;
validation_samples = size(validation_images,2);

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

for epoch=1:iteration % forward and update weight's in number of  iterations
    delta_W=zeros();
    delta_theta=zeros();
    for num_in=1:samples
        %% =========== Forward =============
        
        target = Target(labels(num_in),layer(L).Size);
        for c=2:L
            if c==2
                layer(c).z = (layer(c-1).a(:,num_in))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            else
                layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            end
            
            if isnan(layer(c).z)
                fprintf('\n');
                fprintf('\n');
                fprintf('Please Change input parameter to prevent NaN in Calculation');
                error('Error We Find NaN in Calculation!!!!!!!!!!!!!!!');
            end
            
            %                 layer(c).z=(elm_sum);
            
            if tanh_or_sigmoid==1 %tanh
                layer(c).a = tanhyp(layer(c).z);
            else %sigmoid
                layer(c).a = sigmoid(layer(c).z);
            end
        end
        
        
        % =========== Computing MSE  =============
        layer(L).MSE(:,num_in) = (layer(L).a - target).^2;
        % =========== Computing Delta's  =============
        
        
        %% Compute Output Delta
        
        layer(L).delta = (layer(L).a - target);
        if parameter.method ==1
            layer(L).big_delta(1:end-1,:) = -parameter.learning_rate .* (layer(L-1).a' * layer(L).delta) +...
                layer(L).big_delta(1:end-1,:);
            layer(L).big_delta_bias = -parameter.learning_rate .* ...
                layer(L).delta +layer(L).big_delta_bias;
        else % online method
            %% BIG DELTA Weights ONLINE for L(L)
            delta_W = (-parameter.learning_rate) .* (layer(L-1).a' * layer(L).delta) ;
            delta_theta = layer(L).delta ;
        end

        % Compute Other Delta's
        % Compute Other Delta's
        hl=L-1;
        while(hl>1)
            if tanh_or_sigmoid==1 %tanh
                layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                    tanhypGradient(layer(hl).z) ;
            else %sigmoid
                layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                    sigmoidGradient(layer(hl).z);
            end
            hl = hl-1;
        end
        
        
        up_ind=L;
        while(up_ind>1)

            if up_ind==2
                if parameter.method == 1 % batch method
                    %% BIG DELTA Weights Batch for INPUT's(L(1))
                    layer(up_ind).big_delta(1:end-1,:) =  (-parameter.learning_rate) .*...
                        ((layer(up_ind-1).a(:,num_in)) * layer(up_ind).delta) + ...
                        layer(up_ind).big_delta(1:end-1,:);
                    
                    %% BIG DELTA BIAS's Batch for INPUT's(L(1))
                    layer(up_ind).big_delta_bias =  (-parameter.learning_rate) .* layer(up_ind).delta + ...
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
                    layer(up_ind).big_delta(1:end-1,:) =  (-parameter.learning_rate) .* ...
                        (layer(up_ind-1).a' * layer(up_ind).delta) +...
                        layer(up_ind).big_delta(1:end-1,:);
                    
                    %% BIG DELTA BIAS's Batch for L(2)...L(L)
                    layer(up_ind).big_delta_bias = (-parameter.learning_rate) .* ...
                        layer(up_ind).delta +layer(up_ind).big_delta_bias;
                else % online method
                    %% BIG DELTA Weights ONLINE for L(2)...L(L)
                    delta_W = (-parameter.learning_rate) .* (layer(up_ind-1).a' * layer(up_ind).delta) ;
                    delta_theta = layer(up_ind).delta ;
                    
                end
            end
             %%Update Weight's layer i or update weights from i-1 to i
            if parameter.method == 0 % online method
                % Update Weight's
                layer(up_ind).wts(1:end-1,:) =  layer(up_ind).wts(1:end-1,:) +...
                    delta_W + (parameter.alfa  * layer(up_ind).delta_W_last(1:end-1,:)) -...
                    parameter.lambda * parameter.learning_rate * (layer(up_ind).wts(1:end-1,:));          
                layer(up_ind).delta_W_last(1:end-1,:) = delta_W;
                delta_W = zeros();
                % Update Bias
                layer(up_ind).wts(end,:) = layer(up_ind).wts(end,:) +...
                    delta_theta + (parameter.alfa  * layer(up_ind).delta_W_last(end,:));
                layer(up_ind).delta_W_last(end,:)  = delta_theta;
            end % end if
            up_ind=up_ind-1;
        end
        
        % ===========  Update Weights========================
        
%         up_ind=L;
%         while(up_ind>1)
%             %%
%            
%             up_ind = up_ind-1;
%         end
        
        
        
    end
    
    %%
    if parameter.method == 1 % batch method
        for i=2:L
            % Update Weight's
            layer(i).wts(1:end-1,:) = (1-(parameter.lambda * parameter.learning_rate)) * (layer(i).wts(1:end-1,:))+...
                (1/samples) *layer(i).big_delta(1:end-1,:) + (parameter.alfa  *  layer(i).delta_W_last(1:end-1,:));
            % Last DELTA W Weights
            layer(i).delta_W_last(1:end-1,:) = (1/samples) *layer(i).big_delta(1:end-1,:);
            layer(i).big_delta= zeros(layer(i-1).Size+1,layer(i).Size);
            % Update Bias
            layer(i).wts(end,:) = layer(i).wts(end,:)+ (1/samples)*layer(i).big_delta_bias +...
                (parameter.alfa  *  layer(i).delta_W_last(end,:));
            % Last DELTA W Weights
            layer(i).delta_W_last(end,:) = (1/samples)*layer(i).big_delta_bias;
            layer(i).big_delta_bias=zeros(1,layer(i).Size);
            
        end
    end
    
    
     %% TEST & Accuracy & MSE
    
    images = trainig_inputs(:,1:number_of_training_samples);
    
    Train_or_Test = 0;% accuracy on Train Data
    Accuracy_Train(epoch) = Test(layer,training_samples,Train_or_Test,L,labels,images,tanh_or_sigmoid)/training_samples;
    %
    
    
    Train_or_Test = 1;% accuracy on Test Data
    Accuracy_Test(epoch) = Test(layer,test_samples,Train_or_Test,L,test_labels,test_images,tanh_or_sigmoid)/test_samples;
    %
    Train_or_Test = 2;% accuracy on Validation Data
    Accuracy_Validation(epoch) = Test(layer,validation_samples,Train_or_Test,L,validation_labels,...
        validation_images,tanh_or_sigmoid)/validation_samples;
    
    % Compute Overal MSE
    MSE(epoch) = (sum(layer(L).MSE(:))^0.5) / training_samples;
    
    if epoch >1
        % Create multiple lines using matrix input to plot
        legend('show');
        plot1 = plot(Accuracy_Train(1:epoch-1));hold on;
        set(plot1,'DisplayName','Accuracy Train','Color',[0 1 0]);
        
        plot2 = plot(Accuracy_Test(1:epoch-1));hold on;
        set(plot2,'DisplayName','Accuracy Test','Color',[1 0 0]);
        
        plot3 = plot(Accuracy_Validation(1:epoch-1));hold on;
        set(plot3,'DisplayName','Accuracy Validation','Color',[0 0 0.5]);
        legend('show');
        set(legend,...
            'Position',[0.139580285377526 0.818740401582967 0.118594433997767 0.0839733720985485]);
        drawnow
    end
    
    % adaptive learning rate
    if epoch>1
        if (Accuracy_Train(epoch)/Accuracy_Train(epoch-1))<1
            parameter.learning_rate = 1.05*parameter.learning_rate;
        elseif ((Accuracy_Train(epoch)/Accuracy_Train(epoch-1))>=1) & ((Accuracy_Train(epoch)/Accuracy_Train(epoch-1))<=1.04)
            parameter.learning_rate = parameter.learning_rate;
        else
            parameter.learning_rate = 0.7*parameter.learning_rate;
        end
    end
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

% Create multiple lines using matrix input to plot
legend('show');
plot1 = plot(Accuracy_Train(1:epoch));hold on;
set(plot1,'DisplayName','Accuracy Train','Color',[0 1 0]);

plot2 = plot(Accuracy_Test(1:epoch));hold on;
set(plot2,'DisplayName','Accuracy Test','Color',[1 0 0]);

plot3 = plot(Accuracy_Validation(1:epoch));hold on;
set(plot3,'DisplayName','Accuracy Validation','Color',[0 0 0.5]);
legend('show');
set(legend,...
    'Position',[0.139580285377526 0.818740401582967 0.118594433997767 0.0839733720985485]);
drawnow

% displayData(layer(L).wts(:,end-1));

toc;

