function [MI]=R_matrix(rotate_m,n)
MI = eye(n);
    for m = 1:n-1
        for q = m+1:n
            R= eye(n);
            R([m q], [m q]) =[  cos(rotate_m(m,m))  -sin(rotate_m (m,q))
                                sin(rotate_m(q,m)) cos(rotate_m (q,q)) ];
                
            MI =  MI*R;
        end
    end