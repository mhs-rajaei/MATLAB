function j=Target_Finder(a,tlabels,l)
    y=Target(tlabels,l);
    j=zeros(1,10);
    for i=1:10
        j(i)=(y(i)*log(a(i)) - (1-y(i))*log(1-a(i)));
    end
    
    
    t = Rand_Activation(a,l);
    
    
    
end