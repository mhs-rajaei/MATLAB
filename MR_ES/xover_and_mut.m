function [ new_offsprings,new_sigma,new_alphap ] = xover_and_mut(n,lambda,type_obj_or_offsprings,...
    type_str_or_sigma,mu_or_alpha,parents_or_limits,sigma,alpha )
%% Beginning
%% Crossover
if (nargin ==8)
    %% Set crossover var's
    type_obj=type_obj_or_offsprings;
    type_str=type_str_or_sigma;
    mu=mu_or_alpha;
    parent=parents_or_limits;
    
    %% Allocating space in memory for vector 'xover_offspring', and cells 'xover_sigma', 'xover_alpha'
    xover_offspring    = zeros(n,lambda);
    xover_sigma = cell(1,lambda);
    xover_alpha = cell(1,lambda);
    
    %% Crossover of object variables
    switch type_obj

        %% Discrete crossover
        case 1
            for i = 1:lambda
                tmp       = randsample(1:mu,2);
                for j = 1:n
                    idx       = randsample(tmp,1);
                    xover_offspring(j,i)  = parent(j,idx);
                end
            end
            
            %% Average crossover
        case 2
%             tmp=zeros();
            for i = 1:lambda
                tmp       = randsample(1:mu,2);
                xover_offspring(:,i)  = parent(:,tmp(1))  + ( parent(:,tmp(2))  - parent(:,tmp(1)) )/2;
            end
            %% No supported crossover type
        otherwise
            error('wrong crossover type');
    end
    
    %% Crossover of strategy parameters
    switch type_str
        
        %% Discrete crossover
        case 1
            for i = 1:lambda
                tmp       = randsample(1:mu,2);
                for j = 1:n
                    for jj = j:n
                        idx             = randsample(tmp,1);
                        xover_sigma{i}(j,jj) = sigma{idx}(j,jj);
                        xover_sigma{i}(jj,j) = sigma{idx}(j,jj);
                        xover_alpha{i}(j,jj) = alpha{idx}(j,jj);
                    end
                end
            end
            
            %% Average crossover
        case 2
            for i = 1:lambda
                tmp       = randsample(1:mu,2);
                xover_sigma{i} = sigma{tmp(1)} + (sigma{tmp(2)} - sigma{tmp(1)})/2;
                xover_alpha{i} = alpha{tmp(1)} + (alpha{tmp(2)} - alpha{tmp(1)})/2;
                
                % Validate rotation angles (they must be between [-pi, pi]):
                [p,m]          = find(abs(xover_alpha{i}) > pi);
                xover_alpha{i}(p,m) = xover_alpha{i}(p,m) - 2*pi*(xover_alpha{i}(p,m)/abs(xover_alpha{i}(p,m)));
                
                % Validate standard deviations (they must be greater than zero):
                [p,m]          = find(xover_sigma{i} <= 0);
                xover_sigma{i}(p,m) = 0.1;
            end
                      
            %% No supported crossover type
        otherwise
            error('wrong crossover type');
    end
    
    %% Set outputs
    new_offsprings=xover_offspring;
    new_sigma=xover_sigma;
    new_alphap=xover_alpha;
    
    %% Mutation
elseif (nargin == 6 )
    %% Set mutation var's
    offspring=type_obj_or_offsprings;
    sigma=type_str_or_sigma;
    alpha=mu_or_alpha;
    limits=parents_or_limits;
    %% Mutation factors:
    tau   = 1/(sqrt(2*sqrt(n)));          % learning rate
    taup  = 1/(sqrt(2*n));                % learning rate
    beta  = 5*pi/180;                     % 5 degrees (in radians)
    
    %% Mutate:
    mut_offspring     = zeros(n,lambda);
    mut_sigma = cell(1,lambda);
    mut_alpha = cell(1,lambda);
    
    for i = 1:lambda
        tmp       = randn(n,n);
        mut_sigma{i} = sigma{i}.*exp(taup*randn + tau*(tmp + tmp'));
        tmp       = rand(n,n);
        mut_alpha{i} = alpha{i} + beta*triu((tmp + tmp'),1);
        
        %% Coordinate transformation with respect to axes 'i' and 'j' and angle
        %  'alpha_ij'
        R = eye(n);
        for m = 1:n-1
            for q = m+1:n
                T               =  eye(n);
                T([m q], [m q]) =  [  cos(mut_alpha{i}(m,m))     -sin(mut_alpha{i}(m,q))
                    sin(mut_alpha{i}(q,m))      cos(mut_alpha{i}(q,q)) ];
                R               =  R*T;
            end
        end
        
        mut_offspring(:,i) = offspring(:,i) + R*sqrt(diag(diag(mut_sigma{i})))*randn(n,1);
        
        %% Take in account boundaries (limits)
        for ii = 1:n
            % Lower boundary
            if mut_offspring(ii,i) < limits(ii,1)
                mut_offspring(ii,i) = limits(ii,1);
            end
            % Upper boundary
            if mut_offspring(ii,i) > limits(ii,2)
                mut_offspring(ii,i) = limits(ii,2);
            end
        end
        
    end
    
    %% Set outputs
    new_offsprings=mut_offspring;
    new_sigma=mut_sigma;
    new_alphap=mut_alpha;
    
    
else
    error('Number of input arguments is wrong');
    
end

end

