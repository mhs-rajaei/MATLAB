%% =========== Returns the gradient of the tanh function =============
%    tanh x = 1 - tanh2 x
function g = tanhypGradient(z)

% g = zeros(size(z));
% 
% g = 1 - (z.^2) ;

g = zeros(size(z));

g = 1 - (tanh(z).^2) ;


end
