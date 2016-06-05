function [z]=evaluation(lambda,xm)

z = zeros(1,lambda);
for i = 1:lambda
    z(:,i) = func(xm(:,i));
end


