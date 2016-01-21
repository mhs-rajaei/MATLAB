
min=1;
max=200;

p = randperm(max-min+1,100);

validation_images = trainingLabels(p,1);
% validation_labels = labels(IND);

trainingLabels(p,:) = [];

% labels(IND) = [];

% 
% A=min:max;
% x=zeros(1,100);
% for k=1:100
%      x(k) = randsrc(1,1,A);
%      a= find(A==x(k));
%      A(a)=[];
% end


% 
%  p = min:max;
%  m = length(p);
%  r = zeros(1,n);
%  for k = m:-1:m-n+1
%   q = ceil(k*rand);
%   r((m+1)-k) = p(q); % <-- n random integers go to 'r'
%   p(q) = p(k);
%  end

 
 %--------------------------------------------------------------
% % function p = RandSampNR(min,max,n);
% % -------------------------------------------------------------
% % Generate a random sample of size n from the range of N integers
% % min:max, without replacement, using a rejection loop.
% % Time Complexity is at least O(n^2) and is suitable for small
% % n << N = max-min+1 only. Note that this is a Las Vegas algorithm
% % whose running time is random, because of the rejection while-loop.
% % Space Complexity is O(n).
% %
% % Derek O'Connor, 12 Mar 2011. derekroconnor@eircom.net
% %
% % USE: p = RandSampNR(-2^29,2^29,10^3)
% -------------------------------------------------------------
% p = zeros(1,n);
% N = max-min+1;
% p(1) = min + floor(rand*N);
% for k = 2:n
%       r = min + floor(rand*N);
%       while member(r,p,k-1)
%            r = min + floor(rand*N);
%       end
%       p(k) = r;
% end

% function answer = member(e,v,k)
% answer = false;
% for i = 1:k
%     if v(i) == e
%         answer = true;
%         return
%     end
% end

%---------------------------------------------------------------