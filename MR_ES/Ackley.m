function [f] = Ackley(x,u)
%%  Ackley's function
    f  =  -20*exp(-0.2*sqrt(0.5*(x(1,:).^2 + x(2,:).^2))) - exp(0.5*(cos(2*pi*x(1,:)) + cos(2*pi*x(2,:)))) + 20 + exp(1);
end

