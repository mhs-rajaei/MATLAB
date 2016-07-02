%tanh(x) = sinh(x)/cosh(x) = ( ex - e-x )/( ex + e-x )
%% =========== Compute tanh Function =============
function g = tanhyp(z)
% g = (exp(z)-exp(-z)) ./ (exp(z)+exp(-z));
g = tanh(z);
end
