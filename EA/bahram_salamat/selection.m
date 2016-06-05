function [s_inv, s_inv_covariance_, s_inv_rotate_] = selection(mu,rec_gen_f, gen_f, xm, covariance_m, x0, covariance_, rotate_m, rotate_)
if(true)
selection_pool_f= [rec_gen_f gen_f];
xaug= [xm x0];
covariance_aug= [covariance_m covariance_];
rotate_aug= [rotate_m rotate_];
[x_s_inv, idx]= sort(selection_pool_f);
s_inv = xaug(:,idx(1:mu));
s_inv_covariance_ = covariance_aug(idx(1:mu));
s_inv_rotate_ = rotate_aug(idx(1:mu));
else
selection_pool_f= [rec_gen_f ];
xaug= [xm ];
covariance_aug= [covariance_m ];
rotate_aug= [rotate_m ];
[x_s_inv, idx]= sort(selection_pool_f);
s_inv = xaug(:,idx(1:mu));
s_inv_covariance_ = covariance_aug(idx(1:mu));
s_inv_rotate_ = rotate_aug(idx(1:mu));    
    
end

end
