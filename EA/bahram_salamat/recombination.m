function [xm,covariance_m,rotate_m,xr]=recombination(dim,mu,lambda,xi,covariance_,rotate_,ranges)


    %% crossover:
    [xr,covariance_r,rotate_r] = crossover(dim,mu,lambda,xi,covariance_,rotate_);
   
    
    %% Mutation:
    
   
    [xm,covariance_m,rotate_m] = mutation(dim,lambda,xr,covariance_r,rotate_r,ranges);




end