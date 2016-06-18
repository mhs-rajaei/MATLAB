%% In The Name of ALLAH

% in this code I use some peace of cmaes code written by Gilberto Alejandro Ortiz Garcia 
%% Beginning
clear, clc

%% Setting initial parameters
output_vector_len  = 1;     % Length of the handle function vector (length(fun) x 1 vector)'fun(x,y)'
mu  = 100;                  % Parent population size
lambda  = 700;              % Offspring population size
gen     =500;               % Number of generations
sel     = '+';              % (mu, lambda) or (mu + lambda) survivor selection sel_scheme 
xover_objective = 2;        % Type of recombination to use on object variables(1: Discrete recombination, 2: Average recombination)
xover_strategy = 1;         % Type of recombination to use on strategy parameters
u       = 0;                % External excitation
e     = 1e-10;              % Epsilon zero
sc = 100;                   % Stagnation criterion
pm = 0.9;                   % Mutation probability
m_xover_type = 2;           % (Crossover first then Mutation: 1), (Just crossover: 2), (Just mutation: 3), (probability mutation or crossover: 4)
%% Function parameters
 state    = 2;                           % States
 limits = repmat([-30 30], state, 1);    % Boundaries
 objective_value    = 0;                 % objective function values (f(x_min) = objective_value)

%% Run "Evolutionary Strategy" (ES):
[parents, objective_fun_values, offsprings, MEOEG,idx] = evolution_strategy(@Ackley, mu, lambda,...
    gen, sel, xover_objective, xover_strategy, u, objective_value, ...
    output_vector_len, state, limits,e,sc,m_xover_type,pm);

