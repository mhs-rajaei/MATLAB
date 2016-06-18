function [parents, min_sigma, min_alpha] = survivor_selection(scheme, mu, lambda, off_error, par_error, xm, sigmam, x0, sigma, alpham, alpha)
%   This function carries out the survivor selection process in the "estrategy evolution procedure"

%   INPUT DATA:
%   - scheme: survivor selection scheme:
%                   ',' = (mu, lambda)-selection scheme
%                   '+' = (mu + lambda)-selection scheme
%   - mu:     Parent population size (positive integer number)
%   - lambda: Offspring population size (positive integer number)
%   - off_error:   par_error given by the offspring population (output_vector_len x lambda matrix) - 
%             (output_vector_len: length handle function 'f')
%   - par_error:    par_error given by the parents population (output_vector_len x lambda matrix) - 
%             (output_vector_len: length handle function 'f')
%   - xm:     Mutataed individuals (n * lambda matrix)
%   - sigmam: Mutated standard deviations (nsigma * lambda matrix)
%   - x0:     Parents individuals (n * mu matrix)
%   - sigma:  Parents standard deviations (nsigma * mu matrix)
%   - alpham: Mutated rotation angles (nsigma * lambda matrix)
%   - alpha:  Parents rotation angles (nsigma * mu matrix)
%
%   OUTPUT DATA:
%
%   - parents:     Individuals selected (n x mu matrix)
%   - min_sigma: Covarinces of the individuals selected (1 x mu cell, each cell
%                contains an nxn symmetric matrix)
%   - min_alpha: Rotation angles of the individuals selected (1 x mu cell, each
%                cell contains an nxn symmetric matrix)


%% Beginning
switch scheme
  %% (mu, lambda)-survivor selection scheme
  case ','
    if (mu > lambda)
      error('The parents population size is greater than the offspring population size');
    end
    err = off_error;
    [xmin, idx] = sort(err);
    parents       = xm(:,idx(1:mu));
    min_sigma   = sigmam(idx(1:mu));
    min_alpha   = alpham(idx(1:mu));

  %% (mu + lambda)-survivor selection scheme
  case '+'
    err         = [off_error par_error];    
    xaug        = [xm x0];
    sigmaaug    = [sigmam sigma];
    alphaaug    = [alpham alpha];
    [xmin, idx] = sort(err);
    parents       = xaug(:,idx(1:mu));
    min_sigma   = sigmaaug(idx(1:mu));
    min_alpha   = alphaaug(idx(1:mu));

  %% no suported selection scheme
  otherwise
    error('not supported survivorselection scheme');
end

end
