% -mini batch (+regularization +momentum on deltas) -adaptive learning rate 

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
temp = zeros();


validation = 0;
index = 1;
MSE = zeros(1,iteration);
layer(L).MSE = zeros(10,samples);
for epoch=1:iteration % forward and update weight's in number of  iterations
    delta_W=zeros();
    delta_theta=zeros();
    for num_in=1:samples
        % =========== Forward =============
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
            
            if tanh_or_sigmoid==1 %tanh
                layer(c).a = tanhyp(layer(c).z);
            else %sigmoid
                layer(c).a = sigmoid(layer(c).z);
            end
        end
        
        
        % =========== Computing MSE  =============
        layer(L).MSE(:,num_in) = (layer(L).a - target ).^2;
        %========================================================================================
        % =========== Computing Delta's  =============
        % Compute Output Delta
        layer(L).delta=(layer(L).a - target );
        
        % Compute Other Delta except Input Delat
        hl=L-1;
        while(hl>1)
            
            if tanh_or_sigmoid==1 %tanh
                layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                    ( 1 - ((layer(hl).a).^2));
            else %sigmoid
                layer(hl).delta = layer(hl+1).delta * (layer(hl+1).wts(1:end-1,:))' .* ...
                    layer(hl).a .* (1-layer(hl).a);
            end
            hl=hl-1;
        end
        %% ===========  Update Weights =============
        %
        up_ind=L;
        while(up_ind>1)
            if up_ind==2
                delta_W = -parameter.learning_rate.* (layer(up_ind-1).a(:,num_in) * layer(up_ind).delta);
                delta_theta = -parameter.learning_rate .* layer(up_ind).delta;
            else
                delta_W = -parameter.learning_rate.* (layer(up_ind-1).a'* layer(up_ind).delta);
                delta_theta = -parameter.learning_rate .* layer(up_ind).delta;
            end
            %Update Weight's layer i or update weights from i-1 to i
            if parameter.method == 0 % online method
                % Update Weight's
                layer(up_ind).wts(1:end-1,:) =  layer(up_ind).wts(1:end-1,:) + delta_W + parameter.alfa  * layer(up_ind).delta_W_last(1:end-1,:) +...
                    parameter.lambda *(layer(up_ind).wts(1:end-1,:));
                layer(up_ind).delta_W_last(1:end-1,:) = delta_W;
                % Update Bias
                layer(up_ind).wts(end,:) =  layer(up_ind).wts(end,:) + delta_theta + parameter.alfa  * layer(up_ind).delta_W_last(end,:)+...
                    parameter.lambda * (layer(up_ind).wts(end,:));
                layer(up_ind).delta_W_last(end,:) = delta_theta;
                
                
            else % batch method
                % Update Weight's
                layer(up_ind).DW(1:end-1,:) =  layer(up_ind).DW(1:end-1,:) + delta_W + parameter.alfa  * layer(up_ind).delta_W_last(1:end-1,:)+...
                    parameter.lambda *(layer(up_ind).wts(1:end-1,:));
                layer(up_ind).delta_W_last(1:end-1,:) = delta_W;
                % Update Bias
                layer(up_ind).DW(end,:) =  layer(up_ind).DW(end,:) + delta_theta + parameter.alfa  * layer(up_ind).delta_W_last(end,:);
                layer(up_ind).delta_W_last(end,:) = delta_theta;
            end
            up_ind = up_ind-1;
        end
        
    end
    
    if parameter.method == 1 % batch method
        for i=2:L
            % Update Weight's
            layer(i).wts(1:end-1,:) = layer(i).wts(1:end-1,:) + layer(i).DW(1:end-1,:) ./samples;
            % Update Bias
            layer(i).wts(end,:) = layer(i).wts(end,:) + layer(i).DW(end,:) ./samples;
            layer(i).DW = zeros(layer(i-1).Size+1,layer(i).Size);
        end
    end
    %% TEST & Accuracy & MSE
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
        legend('show');
        % Create multiple lines using matrix input to plot
        plot1 = plot(Accuracy_Train(1:epoch-1));hold on;
        set(plot1,'DisplayName','Accuracy Train','Color',[0 1 0]);
        
        plot2 = plot(Accuracy_Test(1:epoch-1));hold on;
        set(plot2,'DisplayName','Accuracy Test','Color',[1 0 1]);
        
        plot3 = plot(Accuracy_Validation(1:epoch-1));hold on;
        set(plot3,'DisplayName','Accuracy Validation','Color',[0 0 0.5]);
        legend('show');
        set(legend,...
            'Position',[0.139580285377526 0.818740401582967 0.118594433997767 0.0839733720985485]);
        drawnow
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
    
end

% Create multiple lines using matrix input to plot
legend('show');
plot1 = plot(Accuracy_Train(1:epoch));hold on;
set(plot1,'DisplayName','Accuracy Train','Color',[0 1 0]);

plot2 = plot(Accuracy_Test(1:epoch));hold on;
set(plot2,'DisplayName','Accuracy Test','Color',[1 0 1]);

plot3 = plot(Accuracy_Validation(1:epoch));hold on;
set(plot3,'DisplayName','Accuracy Validation','Color',[0 0 0.5]);
legend('show');
set(legend,...
    'Position',[0.139580285377526 0.818740401582967 0.118594433997767 0.0839733720985485]);
drawnow

toc;



