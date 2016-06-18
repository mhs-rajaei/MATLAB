function [new_parents, new_sigma, new_alpha] = survivor_selection(sel_scheme, mu, lambda, off_error, par_error, offspring, mut_sigma, parents, sigma, mut_alpha, alpha)

%   This function carries out the survivor selection process in the "estrategy evolution procedure"

%   INPUT DATA:
%   - sel_scheme: survivor selection scheme:
%                   ',' = (mu, lambda)-selection scheme
%                   '+' = (mu + lambda)-selection scheme
%   - mu:     Parent population size (positive integer number)
%   - lambda: Offspring population size (positive integer number)
%   - off_error:   par_error given by the offspring population (output_vector_len x lambda matrix) - 
%             (output_vector_len: length handle function 'f')
%   - par_error:    par_error given by the parents population (output_vector_len x lambda matrix) - 
%             (output_vector_len: length handle function 'f')
%   - offspring:     Mutataed individuals (n * lambda matrix)
%   - mut_sigma: Mutated standard deviations (nsigma * lambda matrix)
%   - parents:     Parents individuals (n * mu matrix)
%   - sigma:  Parents standard deviations (nsigma * mu matrix)
%   - mut_alpha: Mutated rotation angles (nsigma * lambda matrix)
%   - alpha:  Parents rotation angles (nsigma * mu matrix)
%
%   OUTPUT DATA:
%
%   - parents:     Individuals selected (n x mu matrix)
%   - new_sigma: Covarinces of the individuals selected (1 x mu cell, each cell
%                contains an nxn symmetric matrix)
%   - new_alpha: Rotation angles of the individuals selected (1 x mu cell, each
%                cell contains an nxn symmetric matrix)


%% Beginning
switch sel_scheme
  %% (mu, lambda)-survivor selection scheme
  case ','
    if (mu > lambda)
      error('The parents population size is greater than the offspring population size');
    end
    err = off_error;
    [xmin, idx] = sort(err);
    new_parents = offspring(:,idx(1:mu));
    new_sigma   = mut_sigma(idx(1:mu));
    new_alpha   = mut_alpha(idx(1:mu));

  %% (mu + lambda)-survivor selection scheme
  case '+'
    err         = [off_error par_error];    
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
