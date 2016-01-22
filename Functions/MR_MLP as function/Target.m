%% =========== Returns the target vector =============
function t=Target(n,l)
%this function het the size of the output layer and the value of output
%neuron and set it from the first output neuron
    t= zeros(1,l);
    t(n+1)=1;
    
end
