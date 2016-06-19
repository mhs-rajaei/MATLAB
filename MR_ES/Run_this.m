clear, clc
%% In The Name of ALLAH
fprintf('In The Name of ALLAH\n');
% -------------------------------------------------------------------------------
% | I modified CMA ES code Developed by:   Gilberto Alejandro Ortiz Garcia      |
% |                 gialorga@gmail.com                                          |
% |                 Universidad Nacional de Colombia                            |
% |                 Manizales, Colombia.                                        |
% -------------------------------------------------------------------------------


fprintf('in this code I use cmaes code written by Gilberto Alejandro Ortiz Garcia\n ');
% in this code I use some peace of cmaes code written by Gilberto Alejandro Ortiz Garcia
%% Beginning
%% Setting initial parameters
output_vector_len  = 1;     % Length of the handle function vector (length(fun) x 1 vector)'fun(x,y)'
mu  = 50;                  % Parent population size
lambda  = 350;              % Offspring population size
gen     =2000;               % Number of generations
sel     = ',';              % (mu, lambda) or (mu + lambda) survivor selection sel_scheme
xover_objective = 1;        % Type of recombination to use on object variables(1: Discrete recombination, 2: Average recombination)
xover_strategy = 1;         % Type of recombination to use on strategy parameters
u       = 0;                % External excitation
e     = 1e-10;              % Epsilon zero
sc = 500;                   % Stagnation criterion
pm = 0.9;                   % Mutation probability
m_xover_type =1;           % (Crossover first then Mutation: 1), (Just crossover: 2), (Just mutation: 3), (probability mutation or crossover: 4)
%% Function parameters
f = 4; % Function1 or F2 or F3 or F4 or F5
switch f
    case 1
        state    = 10;                           % States
        limits = repmat([-30 30], state, 1);    % Boundaries
        %         objective_value = 0;
        %%
    case 2
        state    = 10;                           % States
        limits = repmat([-65.532 65.532], state, 1);    % Boundaries
        %         objective_value = 0;
        %%
    case 3
        state    = 10;                           % States
        limits = repmat([-5.32 5.32], state, 1);    % Boundaries
        %         objective_value = 0;
        
        %%
    case 4
        state    = 2;                           % States
        limits = repmat([-500 500], state, 1);    % Boundaries
        %         objective_value    =  -10000 ;                 % objective function values (f(x_min) = objective_value)
        
        %%
    case 5
        state    = 5;                           % States
        limits = repmat([0 pi], state, 1);    % Boundaries
        %         objective_value    =  -10000 ;                 % objective function values (f(x_min) = objective_value)
        
        %% No supported function
    otherwise
        error('wrong function selection');
end



%% Run "Evolutionary Strategy" (ES):
[parents, objective_fun_values, offsprings, MEOEG,idx] = evolution_strategy(@F, mu, lambda,...
    gen, sel, xover_objective, xover_strategy, u, ...
    output_vector_len, state, limits,e,sc,m_xover_type,pm,f);

