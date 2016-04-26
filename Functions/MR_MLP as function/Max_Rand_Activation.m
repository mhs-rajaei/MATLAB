function test=Max_Rand_Activation(a,label)
    %Max Activation
    activation= zeros(1,size(label,2));
    [~, index] = max(a, [], 2);
    activation(index)=1;
    
    %Target label
    target= label;
    
    if target == activation
        test = 1;
    else
        test=0;
    end
        
end
