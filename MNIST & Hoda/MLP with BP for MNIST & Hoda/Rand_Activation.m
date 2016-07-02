function t = Rand_Activation(a,l)
   %t thershold = 0.7
   t = zeros(1,l);
   for i=1:l
       if a(i)>=.7
           t(i)=1;
       end
   end
   
    
end
