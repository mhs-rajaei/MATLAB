function [Features] = GetFeaturesMatConv(PoolRows,PoolColumns,ImageSize,X,K,W,Q,Filters) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code implements methods described and referenced in the paper at http://arxiv.org/abs/1503.04596

%Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: June 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1503.04596

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%define some dimensions
NumFilters = size(Filters,1);
FullSize = ImageSize+W-1;
 
%get pooling matrix
PoolIndices = zeros(ImageSize+W+Q-2,ImageSize+W+Q-2);
PoolIndices(PoolRows,PoolColumns)=1;
NumFeaturesPerFilter = length(find(PoolIndices(:))==1);

PoolingFilter = ones(Q,Q)/Q^2;
P0 = convmtx2(PoolingFilter,FullSize,FullSize); 
P1 = P0(find(PoolIndices(:)==1),:);
 
%get features
Features = zeros(NumFilters*NumFeaturesPerFilter,K);
for i = 1:NumFilters
    tic
    %get convolution matrix
    T1 = convmtx2(squeeze(Filters(i,:,:)),ImageSize,ImageSize);
    
    %get features
    Features((i-1)*NumFeaturesPerFilter+1:i*NumFeaturesPerFilter,:) = sqrt(P1*((T1*X).^2));
 
    [i toc]
end
 




