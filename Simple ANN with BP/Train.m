% +mini batch   +regularization   +momentum   +adaptive learning rate

%% =========== Forward : Computing Delta's : Update Weights =============

delta_W=zeros();
delta_W_last=zeros();
delta_theta=zeros();
delta_theta_last=zeros();

Accuracy_Train = zeros(1,iteration);
Accuracy_Test = zeros(1,iteration);

samples = number_of_training_samples;
tsamples = size(test_set,2);

index = 1;
MSE = zeros(1,iteration);
layer(L).MSE = zeros(2,samples);
% layer(L).MSE2 = zeros(2,samples);
counter = 0;

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

for epoch=1:iteration % forward and update weight's in number of  iterations
    delta_W=zeros();
    delta_theta=zeros();
    for num_in=1:samples
        %% =========== Forward =============
        counter = counter +1;
        target = Target(train_labels(num_in),layer(L).Size);
        
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
        
        
        % =========== Computing MSE  =================
        layer(L).MSE(:,num_in) = sum((target - layer(L).a).^2);
        %% =========== Computing Delta's  =============
        layer(L).delta = -(target - layer(L).a);
  
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
    
    %%
        
    %% TEST & Accuracy & MSE
    
    Train_or_Test = 0;% accuracy on Train Data
    Accuracy_Train(epoch) = Test(layer,samples,Train_or_Test,L,train_labels,train_set,tanh_or_sigmoid)/samples;

    Train_or_Test = 1;% accuracy on Test Data
    Accuracy_Test(epoch) = Test(layer,tsamples,Train_or_Test,L,test_labels,test_set,tanh_or_sigmoid)/tsamples;
    
    % Compute Overal MSE
    MSE(epoch) = (sum(layer(L).MSE(:))^0.5) / samples;
    
    if epoch >1
        
        % Create multiple lines using matrix input to plot
        plot1 = plot(Accuracy_Train(1:epoch-1));hold on;
        set(plot1,'DisplayName','Accuracy Train','LineWidth',4,'LineStyle',':',...
            'Color',[0.600000023841858 0.200000002980232 0]);
        
        plot2 = plot(Accuracy_Test(1:epoch-1));hold on;
        set(plot2,'DisplayName','Accuracy Test','LineWidth',3,'Color',[0 1 0]);
        
        % Set the remaining axes properties
        set(axes1,'XGrid','on','YGrid','on');
        
        % Create legend
        legend('show');
        set(legend,...
            'Position',[0.139580285377526 0.818740401582967 0.118594433997767 0.0839733720985485]);
        drawnow
    end
    
end

% Create multiple lines using matrix input to plot
plot1 = plot(Accuracy_Train(1:epoch-1));hold on;
set(plot1,'DisplayName','Accuracy Train','LineWidth',4,'LineStyle',':',...
    'Color',[0.600000023841858 0.200000002980232 0]);
plot2 = plot(Accuracy_Test(1:epoch-1));hold on;
set(plot2,'DisplayName','Accuracy Test','LineWidth',3,'Color',[0 1 0]);

% Set the remaining axes properties
set(axes1,'XGrid','on','YGrid','on');
% Create legend
legend('show');
set(legend,...
    'Position',[0.139580285377526 0.818740401582967 0.118594433997767 0.0839733720985485]);
drawnow;


draw_MSE(MSE);


