function [xip,covariance_p,rotate_p] = crossover(n,mu,lambda,xi,covariance_,rotate_)

xip    = zeros(n,lambda);
[idx  ie]=size(xip);
covariance_p = cell(1,lambda);
rotate_p = cell(1,lambda);

for i = 1:ie
    Rsamp= randsample(1:mu,2);
     covariance_p{i} = covariance_{Rsamp(1)} + (covariance_{Rsamp(2)} - covariance_{Rsamp(1)})/2;
    rotate_p{i} = rotate_{Rsamp(1)} + (rotate_{Rsamp(2)} - rotate_{Rsamp(1)})/2;
    [p,m]= find(abs(rotate_p{i}) > pi);
    rotate_p{i}(p,m) = -sign(rotate_p{i}(p,m))*pi;
    [p,m]= find(covariance_p{i} <= 0);
    covariance_p{i}(p,m) = 0.1;
    for j = 1:n
        idx= randsample(Rsamp,1);
        xip(j,i)  = xi(j,idx);
    end
end
end
