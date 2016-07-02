function test=Max_Rand_Activation(a,l,num_in)
    %Max Activation
    activation= zeros(1,l);
    [~, index] = max(a, [], 2);
    activation(index)=1;
    
    %Target label
    target= zeros(1,l);
    target(num_in+1)=1;
    
    if target == activation
        test = 1;
    else
        test=0;
    end
        
end
