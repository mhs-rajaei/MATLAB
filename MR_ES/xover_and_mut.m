function [ xip_xm,sigmap_sigmam,alphap_alpham ] = xover_and_mut(n,lambda,type_obj_xr,type_str_sigmar,mu_alphar,xi_limits,sigma,alpha )
%% Beginning
if (nargin ==8)
%% Set crossover var's
type_obj=type_obj_xr;
type_str=type_str_sigmar;
mu=mu_alphar;
xi=xi_limits;

%% Allocating space in memory for vector 'xip', and cells 'sigmap', 'alphap'
xip    = zeros(n,lambda);
sigmap = cell(1,lambda);
alphap = cell(1,lambda);

%% Recombination of object variables
switch type_obj
  %% No recombination

  %% Discrete recombination
  case 1
    for i = 1:lambda
      tmp       = randsample(1:mu,2);
      for j = 1:n
        idx       = randsample(tmp,1);
        xip(j,i)  = xi(j,idx);
      end
    end


  %% Intermediate recombination
  case 2
    for i = 1:lambda
      tmp       = randsample(1:mu,2);
      xip(:,i)  = xi(:,tmp(1))  + (xi(:,tmp(2))  - xi(:,tmp(1)))/2;
    end

  

  %% No supported recombination type
  otherwise
    error('wrong crossover type');
end

%% Recombination of strategy parameters
switch type_str

  %% Discrete recombination
  case 1
    for i = 1:lambda
      tmp       = randsample(1:mu,2);
      for j = 1:n
        for jj = j:n
          idx             = randsample(tmp,1);
          sigmap{i}(j,jj) = sigma{idx}(j,jj);
          sigmap{i}(jj,j) = sigma{idx}(j,jj);
          alphap{i}(j,jj) = alpha{idx}(j,jj);
        end
      end
    end


  %% Intermediate recombination
  case 2
    for i = 1:lambda
      tmp       = randsample(1:mu,2);
      sigmap{i} = sigma{tmp(1)} + (sigma{tmp(2)} - sigma{tmp(1)})/2;
      alphap{i} = alpha{tmp(1)} + (alpha{tmp(2)} - alpha{tmp(1)})/2;

      % Validate rotation angles (they must be between [-pi, pi]):
      [p,m]          = find(abs(alphap{i}) > pi);
      alphap{i}(p,m) = alphap{i}(p,m) - 2*pi*(alphap{i}(p,m)/abs(alphap{i}(p,m)));
      
      % Validate standard deviations (they must be greater than zero):
      [p,m]          = find(sigmap{i} <= 0);
      sigmap{i}(p,m) = 0.1;
    end


  %% No supported recombination type
  otherwise
    error('wrong crossover type');
end

%% Set outputs
xip_xm=xip;
sigmap_sigmam=sigmap;
alphap_alpham=alphap;

%% Mutation
elseif (nargin == 6 )
%% Set mutation var's
xr=type_obj_xr;
sigmar=type_str_sigmar;
alphar=mu_alphar;
limits=xi_limits;
%% Mutation factors:
tau   = 1/(sqrt(2*sqrt(n)));          % learning rate
taup  = 1/(sqrt(2*n));                % learning rate
beta  = 5*pi/180;                     % 5 degrees (in radians)

%% Mutate:
xm     = zeros(n,lambda);
sigmam = cell(1,lambda);
alpham = cell(1,lambda);

for i = 1:lambda
  tmp       = randn(n,n);
  sigmam{i} = sigmar{i}.*exp(taup*randn + tau*(tmp + tmp'));
  tmp       = rand(n,n);
  alpham{i} = alphar{i} + beta*triu((tmp + tmp'),1);
  
  %% Coordinate transformation with respect to axes 'i' and 'j' and angle
  %  'alpha_ij'
  R = eye(n);
  for m = 1:n-1
    for q = m+1:n
      T               =  eye(n);
      T([m q], [m q]) =  [  cos(alpham{i}(m,m))     -sin(alpham{i}(m,q))
                            sin(alpham{i}(q,m))      cos(alpham{i}(q,q)) ];
      R               =  R*T;
    end
  end

  xm(:,i) = xr(:,i) + R*sqrt(diag(diag(sigmam{i})))*randn(n,1);
  
  %% Take in account boundaries (limits)
  for ii = 1:n
    % Lower boundary
    if xm(ii,i) < limits(ii,1)
      xm(ii,i) = limits(ii,1);
    end
    % Upper boundary
    if xm(ii,i) > limits(ii,2)
      xm(ii,i) = limits(ii,2);
    end
  end

end

%% Set outputs
xip_xm=xm;
sigmap_sigmam=sigmam;
alphap_alpham=alpham;


else
         error('Number of input arguments is wrong');
         
end






















end

