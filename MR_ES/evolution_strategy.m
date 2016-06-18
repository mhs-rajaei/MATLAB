function [parents, objective_fun_values, offsprings, MEOEG,j] = evolution_strategy(fun, mu, lambda, gen, sel, xover_obj,...
    xover_strategy, u,output_vector_len, n, limits,e,sc,m_xover_type,pm,f)
%% Initialization:
[parents,objective_fun_values,offsprings,parent_fitness,MEOEG,e,sigma, alpha] = initialize(mu, n, limits,gen,u,output_vector_len,e,f);

j      = 1;                           % Gnerations counter
jj     = 0;                           % Stagnation counter

%% Begin ES
while (j < gen)%&& (abs(MEOEG(j)) > e)
    %% Print report:
    fprintf('\tGeneration j = %4d,  fitness = %g\n',j,MEOEG(j));
    
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
                new_value(:,i) = F(mut_offspring(:,i),u,f);
            end
%             offspring_fitness = abs(objective_value - new_value(1,:));
            offspring_fitness = new_value;
            
            %% Survivor_selection
            [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, offspring_fitness, parent_fitness, mut_offspring, mut_sigma, parents{j}, sigma, mut_alpha, alpha);
        %% Just crossover:
        case 2
            %% Crossover:
            [offsprings{j+1},xover_sigma,xover_alpha] = xover_and_mut(n,lambda,xover_obj,xover_strategy,mu,parents{j},sigma,alpha);
            
            %% Evaluation:
            new_value = zeros(output_vector_len,lambda);
            for i = 1:lambda
                new_value(:,i) = F(offsprings{j+1}(:,i),u,f);
            end
%             offspring_fitness = abs(objective_value - new_value(1,:));
            offspring_fitness = new_value;
            
            %% Survivor_selection
            [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, offspring_fitness, parent_fitness, offsprings{j+1}, xover_sigma, parents{j}, sigma, xover_alpha, alpha);
        %% Just mutation:
        case 3
            %% Mutation:
            lambda = mu;
            [mut_offspring,mut_sigma,mut_alpha] = xover_and_mut(n,lambda,parents{j},sigma,alpha,limits);
            
            %% Evaluation:
            new_value = zeros(output_vector_len,lambda);
            for i = 1:lambda
                new_value(:,i) = F(mut_offspring(:,i),u,f);
            end
%             offspring_fitness = abs(objective_value - new_value(1,:));
            offspring_fitness = new_value;
            
            %% Survivor_selection
            [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, offspring_fitness, parent_fitness, mut_offspring, mut_sigma, parents{j}, sigma, mut_alpha, alpha);
        %% Probability mutation or crossover    
        case 4
            tmp = randi(100);
            if ((tmp/100) > pm)
                %% Crossover:
                [offsprings{j+1},xover_sigma,xover_alpha] = xover_and_mut(n,lambda,xover_obj,xover_strategy,mu,parents{j},sigma,alpha);
                
                %% Evaluation:
                new_value = zeros(output_vector_len,lambda);
                for i = 1:lambda
                    new_value(:,i) = F(offsprings{j+1}(:,i),u,f);
                end
%                 offspring_fitness = abs(objective_value - new_value(1,:));
                offspring_fitness = new_value;
                
                %% Survivor_selection
                [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, offspring_fitness, parent_fitness, offsprings{j+1}, xover_sigma, parents{j}, sigma, xover_alpha, alpha);
            %%    
            else
                %% Mutation:
                lambda = mu;
                [mut_offspring,mut_sigma,mut_alpha] = xover_and_mut(n,lambda,parents{j},sigma,alpha,limits);
                
                %% Evaluation:
                new_value = zeros(output_vector_len,lambda);
                for i = 1:lambda
                    new_value(:,i) = F(mut_offspring(:,i),u,f);
                end
%                 offspring_fitness = abs(objective_value - new_value(1,:));
                offspring_fitness = new_value;
                
                %% Survivor_selection
                [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, offspring_fitness, parent_fitness, mut_offspring, mut_sigma, parents{j}, sigma, mut_alpha, alpha);
                
            end
            
            %% No supported mutation and crossover type
        otherwise
            error('wrong mutation and crossover type');
    end
    
    
    %% Store better results:
    fun_values = zeros(output_vector_len,mu);               % allocate space for function evaluation
    for i = 1:mu
        fun_values(:,i) = fun(parents{j+1}(:,i),u,f);
    end
    objective_fun_values{j+1} = fun_values;                 % next approximation
%     parent_fitness = abs(objective_value - fun_values(1,:));        % error
      parent_fitness = fun_values;  
    
    MEOEG(j+1) = min(parent_fitness);
    
    %% Stagnation criterion:
    if (MEOEG(j) == MEOEG(j+1))
        jj = jj+1;
    else
        jj = 0;
    end
    
    j = j+1; % Increase generation counter
    
    if (jj == sc)% Check stagnation criterion
        fprintf('\n\n\t Error remains constant for %4d consecutive generations\n\n',sc);
        break
    end
    
    
end

end