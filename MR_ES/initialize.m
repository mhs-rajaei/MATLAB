function [parents,objective_fun_values,offsprings,par_error,MEOEG,e,sigma, alpha] = initialize(mu, n, limits,gen,u,objective_value,output_vector_len,e)
%   This function just validates the sizes of the matries init_points and sigma. Also,
%   computes the rotation angles matrix 'alpha'.
%
%% Generate initial population:
init_points = zeros(n,mu);
for i = 1:n
    init_points(i,:) = unifrnd(limits(i,1), limits(i,2), 1, mu);      % initialization
end

%% Generate covariance matrix
sigma  = cell(1,mu);
for i = 1:mu
    % Generate random symmetric covariance matrices
    tmp      = rand(n,n);
    sigma{i} = tmp + tmp';
end


%% Compute 'alpha' matrices from the covariance matrices
alpha = cell(1,mu);
for i = 1:mu
    alpha{i} = zeros(n);
    for j = 1:n-1
        for k = j+1:n
            alpha{i}(j,k) = 0.5*atan2(2*sigma{i}(j,k),(sigma{i}(j,j)^2 - sigma{i}(k,k)^2));
        end
    end
end

%%

parents = cell(1,gen);                % allocate space in memory for parents
objective_fun_values = cell(1,gen);                  % allocate space in memory for objective_fun_values
offsprings   = cell(1,gen);                  % allocate space to store the offspring population

parents{1} = init_points;                       % first point
fun_values = zeros(output_vector_len,mu);                 % allocate space for function evaluation
for i = 1:mu
    fun_values(:,i) = Ackley(init_points(:,i),u);
end
objective_fun_values{1} = fun_values;                     % first approximation
offsprings{1}   = zeros(n,1);


par_error    = abs(objective_value - fun_values(1,:));       % initial error
MEOEG    = zeros(gen,1);                % allocate space in memory for minimum error every generation
MEOEG(1) = min(par_error);

end
