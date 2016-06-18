function [new_parents, new_sigma, new_alpha] = survivor_selection(sel_scheme, mu, lambda, ...
    offspring_fitness, parent_fitness, offspring, mut_sigma, parents, sigma, mut_alpha, alpha)
%% Beginning
switch sel_scheme
  %% (mu, lambda)-survivor selection scheme
  case ','
    if (mu > lambda)
      error('The parents population size is greater than the offspring population size');
    end
    err = offspring_fitness;
    [xmin, idx] = sort(err);
    new_parents = offspring(:,idx(1:mu));
    new_sigma   = mut_sigma(idx(1:mu));
    new_alpha   = mut_alpha(idx(1:mu));

  %% (mu + lambda)-survivor selection scheme
  case '+'
    err         = [offspring_fitness parent_fitness];    
    parents_plus_offspring        = [offspring parents];
    parents_plus_offspring_sigma    = [mut_sigma sigma];
    parents_plus_offspring_alpha    = [mut_alpha alpha];
    [xmin, idx] = sort(err);
    new_parents       = parents_plus_offspring(:,idx(1:mu));
    new_sigma   = parents_plus_offspring_sigma(idx(1:mu));
    new_alpha   = parents_plus_offspring_alpha(idx(1:mu));

  %% no suported selection scheme
  otherwise
    error('not supported survivor selection scheme');
end

end
