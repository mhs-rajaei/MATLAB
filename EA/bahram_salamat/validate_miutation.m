function [x]=validate_miutation(n,ranges,x)
   for  e= 1:n
        
        if x(e,i) < ranges(e,1)
            x(e,i) = ranges(e,1);
        end
        if x(e,i) > ranges(e,2)
            x(e,i) = ranges(e,2);
        end
    end
end