%% =========== Returns the gradient of the sigmoid function =============
%   
function g = sigmoidGradient(z)

g = zeros(size(z));

g = sigmoid(z) .* (1 - sigmoid(z));


end
