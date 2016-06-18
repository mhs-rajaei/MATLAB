function [parents, objective_fun_values, offsprings, MEOEG,j] = evolution_strategy(fun, mu, lambda, gen, sel, xover_obj,...
    xover_strategy, u, objective_value,output_vector_len, n, limits,e,sc,m_xover_type,pm)
%% Initialization:
[parents,objective_fun_values,offsprings,par_error,MEOEG,e,sigma, alpha] = initialize(mu, n, limits,gen,u,objective_value,output_vector_len,e);

j      = 1;                           % Gnerations counter
jj     = 0;                           % Stagnation counter

%% Begin ES
while ((j < gen) && (min(par_error) > e))
    %% Print report:
    fprintf('\tGeneration j = %4d,  fitness = %g\n',j,min(par_error));
    
    %% Crossover and mutation types
    switch m_xover_type
        %% Crossover first then Mutation:
        case 1
            %% Crossover:
            [offsprings{j+1},xover_sigma,xover_alpha] = xover_and_mut(n,lambda,xover_obj,xover_strategy,mu,parents{j},sigma,alpha);
            
            %% Mutation:
            [mut_offspring,mut_sigma,mut_alpha] = xover_and_mut(n,lambda,offsprings{j+1},xover_sigma,xover_alpha,limits);
            
            %% Evaluation:
            new_value = zeros(output_vector_len,lambda);
            for i = 1:lambda
                new_value(:,i) = Ackley(mut_offspring(:,i),u);
            end
            off_error = abs(objective_value - new_value(1,:));
            
            %% Survivor_selection
            [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, off_error, par_error, mut_offspring, mut_sigma, parents{j}, sigma, mut_alpha, alpha);
        %% Just crossover:
        case 2
            %% Crossover:
            [offsprings{j+1},xover_sigma,xover_alpha] = xover_and_mut(n,lambda,xover_obj,xover_strategy,mu,parents{j},sigma,alpha);
            
            %% Evaluation:
            new_value = zeros(output_vector_len,lambda);
            for i = 1:lambda
                new_value(:,i) = Ackley(offsprings{j+1}(:,i),u);
            end
            off_error = abs(objective_value - new_value(1,:));
            
            %% Survivor_selection
            [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, off_error, par_error, offsprings{j+1}, xover_sigma, parents{j}, sigma, xover_alpha, alpha);
        %% Just mutation:
        case 3
            %% Mutation:
            lambda = mu;
            [mut_offspring,mut_sigma,mut_alpha] = xover_and_mut(n,lambda,parents{j},sigma,alpha,limits);
            
            %% Evaluation:
            new_value = zeros(output_vector_len,lambda);
            for i = 1:lambda
                new_value(:,i) = Ackley(mut_offspring(:,i),u);
            end
            off_error = abs(objective_value - new_value(1,:));
            
            %% Survivor_selection
            [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, off_error, par_error, mut_offspring, mut_sigma, parents{j}, sigma, mut_alpha, alpha);
        %% Probability mutation or crossover    
        case 4
            tmp = randi(100);
            if ((tmp/100) > pm)
                %% Crossover:
                [offsprings{j+1},xover_sigma,xover_alpha] = xover_and_mut(n,lambda,xover_obj,xover_strategy,mu,parents{j},sigma,alpha);
                
                %% Evaluation:
                new_value = zeros(output_vector_len,lambda);
                for i = 1:lambda
                    new_value(:,i) = Ackley(offsprings{j+1}(:,i),u);
                end
                off_error = abs(objective_value - new_value(1,:));
                
                %% Survivor_selection
                [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, off_error, par_error, offsprings{j+1}, xover_sigma, parents{j}, sigma, xover_alpha, alpha);
            %%    
            else
                %% Mutation:
                lambda = mu;
                [mut_offspring,mut_sigma,mut_alpha] = xover_and_mut(n,lambda,parents{j},sigma,alpha,limits);
                
                %% Evaluation:
                new_value = zeros(output_vector_len,lambda);
                for i = 1:lambda
                    new_value(:,i) = Ackley(mut_offspring(:,i),u);
                end
                off_error = abs(objective_value - new_value(1,:));
                
                %% Survivor_selection
                [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, off_error, par_error, mut_offspring, mut_sigma, parents{j}, sigma, mut_alpha, alpha);
                
            end
            
            %% No supported mutation and crossover type
        otherwise
            error('wrong mutation and crossover type');
    end
    
    
    %% Store better results:
    fun_values = zeros(output_vector_len,mu);               % allocate space for function evaluation
    for i = 1:mu
        fun_values(:,i) = fun(parents{j+1}(:,i),u);
    end
    objective_fun_values{j+1} = fun_values;                 % next approximation
    par_error = abs(objective_value - fun_values(1,:));        % error
    
    MEOEG(j+1) = min(par_error);
    
    %% Stagnation criterion:
    if (MEOEG(j) == MEOEG(j+1))
        jj = jj+1;
    else
        jj = 0;
    end
    
    j = j+1; % Increase generation counter
    
    if (jj == sc)% Check stagnation criterion
        fprintf('\n\n\t Error remains constant for 100 consecutive generations\n\n');
        break
    end
    
    
end

end