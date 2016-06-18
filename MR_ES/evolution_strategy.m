function [parents, objective_fun_values, off, MEOEG,j] = evolution_strategy(fun, mu, lambda, gen, sel, xover_obj,...
    xover_strategy, u, objective_value,output_vector_len, n, limits,e)
%   INPUT DATA:
%   - fun:       Objective function (handle function: f(x,u))
%   - mu:      Parent population size (positive integer number)
%   - lambda:  Offspring population size (positive integer number)
%   - gen:     Number of generations (positive integer number)
%   - sel:     Selection sel_scheme
%   - xover_obj:      Type of recombination to use on object variables(1: Discrete recombination, 2: Average recombination)
%   - xover_strategy: Type of recombination to use on strategy parameters
%   - u:       External excitation (if it does not exist, type 0 (zero))
%   - objective_value:     Vector with the desired results
%   - output_vector_len:      Length of the handle function vector (length(fun) x 1 vector)
%   - n:       Length of the vector init_points (positive integer number)
%   - limits:  Matrix with the limits of the variables (nx2 matrix). The first column is the lower boundary, the second column is the upper boundary.
%   - init_points:     Starting point (n*mu matrix)
%   - sigma:   Cell with covariance matrices (1 x mu cell; each cell has to have an nxn symmetric matrix)
%
%   OUTPUT DATA:
%
%   - parents:   Cell with the parent population, and whose last component
%              minimizes the objective function 'fun' vector)
%   - objective_fun_valuess:   Cell with the values of the Objective Function 'fun'
%              (length(f) x 1 vector)
%   - offsprings:     Cell with the offsprings population in each generation
%   - MEOEG:     Vector with the minimum error of each generation (gen x 1
%              vector)


%% Initialization:
[parents,objective_fun_values,off,par_error,MEOEG,e,sigma, alpha] = initialize(mu, n, limits,gen,u,objective_value,output_vector_len,e);

j      = 1;                           % Gnerations counter
jj     = 0;                           % Stagnation counter

%% Begin ES
while ((j < gen) && (min(par_error) > e))
    %% Print report:
    fprintf('\tGeneration j = %4d,  fitness = %g\n',j,min(par_error));
    
    %% Recombine:
    [xr,sigmar,alphar] = xover_and_mut(n,lambda,xover_obj,xover_strategy,mu,parents{j},sigma,alpha);
    off{j+1}           = xr;            % offspring population
    
    %% Mutation:
    [xm,sigmam,alpham] = xover_and_mut(n,lambda,xr,sigmar,alphar,limits);
    %   mutation(n,lambda,xr,sigmar,alphar,limits);
    
    %% Evaluation:
    phie = zeros(output_vector_len,lambda);
    for i = 1:lambda
        phie(:,i) = Ackley(xm(:,i),u);
    end
    par_errore = abs(objective_value - phie(1,:));
    
    %% Selection:
    [parents{j+1}, sigma, alpha] = survivor_selection(sel, mu, lambda, par_errore, par_error, xm, sigmam, parents{j}, sigma, alpham, alpha);
    
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
    
    if (jj == 100)% Check stagnation criterion
        fprintf('\n\n\tpar_error remains constant for 100 consecutive generations\n\n');
        break
    end
    
end

end