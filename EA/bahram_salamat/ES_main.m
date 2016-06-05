function  ES_main()

[initial_x, variance_, rotate_,dim,ranges,mu,lambda,iterate] = intialization();

s_inv = createArrays(iterate, [1 mu]);
s_inv_f = createArrays(iterate, [1 mu]);
off= createArrays(iterate, [1 mu]);
s_inv{1} = initial_x;
fitness = zeros(1,mu);
for i = 1:mu
    fitness(:,i) = func(initial_x(:,i));
end
s_inv_f{1} = fitness;
off{1}   = zeros(dim,1);


gen_f    = fitness(1,:);
all_best_f   = zeros(iterate,1);
all_best_f(1) = min(gen_f);

optimal_gen=0;
best_fitness=min(gen_f);


for iter=1: iterate
    
    [xm,variance_m,rotate_m,xr]=recombination(dim,mu,lambda,s_inv{iter},variance_,rotate_,ranges);
    off{iter+1}           = xr;
    [rec_gen_f]=evaluation(lambda,xm) ;
    
    [s_inv{iter+1}, variance_, rotate_] = selection(mu,rec_gen_f, gen_f, xm, variance_m, s_inv{iter}, variance_, rotate_m, rotate_);
    
    fitness = zeros(1,mu);
    for i = 1:mu
        fitness(:,i) = func(s_inv{iter+1}(:,i));
    end
    
    
    s_inv_f{iter+1} = fitness;
    gen_f = fitness(1,:);
    all_best_f(iter+1) = min(gen_f);
    if min(gen_f)< best_fitness
        optimal_gen=iter;
        best_fitness=min(gen_f);
    end
    
    fprintf('\t%4d,  fitness = %.10f\n',iter,min(gen_f));
    
end
 fprintf('\tparent size= %4d,  dimenstion=%4d , ranges=[%.10f,%.10f]\n \tbestfitness = %.10f\n',mu,dim,ranges(1,1),ranges(1,2),best_fitness);
 fprintf('\tvector <');
optimal=s_inv{iterate+1}(:,1);
 for i=1:dim
 fprintf('\t%g',optimal(i,:));
 end
 fprintf('\t>\n\tgeneration number %d\n',optimal_gen);
 
 

end
