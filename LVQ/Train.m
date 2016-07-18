%% =========== Forward : Computing Delta's : Update Weights =============
delta_W=zeros();

distance = zeros(1,10);

for epoch=1:iteration % forward and update weight's in number of  iterations
    delta_W=zeros();
    delta_theta=zeros();
    layer(2).a = zeros(1,784);
    for num_in=1:samples
        
        c = 2;
        n = zeros(1,784,10);
        
        for j=1:10
            n(:,:,j) = layer(c-1).a(:,num_in)' - layer(c).wts(j,:);
            distance(1,j) = sum( n(:,:,j).^2) ;
        end
        
        % Finding minimum of distance
        [~, index] = min(distance, [], 2);
        % set output vector
        layer(L).a(1,index) = 1;
        % check output vector if classified correctly set test to 1
        % otherwise set test to 0
        test = Max_Rand_Activation(layer(L).a,layer(L).Size,labels(num_in));
        %% Update weights
        c= 2;
        if test == 1
            delta_W = learning_rate .* ( layer(c-1).a(:,num_in)' - layer(c).wts(index,:) );
        else
            delta_W = -learning_rate .* ( layer(c-1).a(:,num_in)' - layer(c).wts(index,:) );
        end
        
        layer(c).wts(index,:) =  layer(c).wts(index,:) - delta_W ;
        delta_W = zeros();
        layer(L).a = zeros(1,10);
        
        %% Decrease learning rate
        alpha = 0.001;
        learning_rate = learning_rate - alpha;
        
        
    end
end

plot_wts = layer(2).wts;

hist(plot_wts);

