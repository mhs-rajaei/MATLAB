function [X,covariance_m,rotate_m] = mutation(n,lambda,Xr,covariance_r,rotate_r,ranges)

X     = zeros(n,lambda);
[idx  loop]=size(X);
covariance_m = cell(1,lambda);
bt  = 5*pi/180;
rotate_m = cell(1,lambda);
tou   = 1/(sqrt(2*sqrt(n)));
tou_prim  = 1/(sqrt(2*n));

i=1;
while(i<=loop)
    D = randn(n,n);
    covariance_m{i} = covariance_r{i}.*exp(tou_prim*randn + tou*(D + D'));
    D = rand(n,n);
    rotate_m{i} = rotate_r{i} + bt*triu((D + D'),1);
    [MI]=R_matrix(rotate_m{i},n);
    
    X(:,i) = Xr(:,i) + MI*sqrt(diag(diag(covariance_m{i})))*randn(n,1);
    
    
    for  e= 1:n
        
        if ((X(e,i) - ranges(e,1))<0 ||(X(e,i) - ranges(e,2))>0)
            
            if (X(e,i) - ranges(e,1))< 0
                X(e,i) = ranges(e,1);
            end
            
            if (X(e,i) - ranges(e,2))>0
                X(e,i) = ranges(e,2);
            end
        end
    end
    i=i+1;
end

end
