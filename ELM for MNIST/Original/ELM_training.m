function [PercentCorrect_train,Y_predicted_train,W_randoms,W_outputs,A] = ELM_training(Flags,L,ImageSize,X,Y,k_train,labels,NumClasses,M,Scaling,RidgeParam,MinMaskSize,RF_Border)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code implements methods described and referenced in the paper at http://arxiv.org/abs/1412.8307

%Author: Assoc Prof Mark D. McDonnell, University of South Australia
%Email: mark.mcdonnell@unisa.edu.au
%Date: January 2015
%Citation: If you find this code useful, please cite the paper described at http://arxiv.org/abs/1412.8307

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Mask = ones(M,L);
if Flags(1) == 1
    %get receptive field masks
    Mask =  zeros(M,L);
    for ii = 1:M
        SquareMask = zeros(ImageSize,ImageSize);
        Inds1 = zeros(2,1);Inds2 = zeros(2,1);
        while (Inds1(2)-Inds1(1))*(Inds2(2)-Inds2(1)) < MinMaskSize
            Inds1 = RF_Border+sort(randperm(ImageSize-2*RF_Border,2));
            Inds2 = RF_Border+sort(randperm(ImageSize-2*RF_Border,2));
        end
        SquareMask(Inds1(1):Inds1(2),Inds2(1):Inds2(2))=1;
        Mask(ii,:) =  SquareMask(:);
    end
end

W_randoms = zeros(M,L);
biases = zeros(M,1);
switch Flags(2)
    case 1
        W_randoms = sign(randn(M,L)); %get bipolar random weights
        W_randoms =  Mask.*W_randoms; %mask random weights
        W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
    case 2
        %get CIW weights
        NumEachClass = sum(Y);
        M_CIWs = round(M*NumEachClass/k_train);
        M0 = sum(M_CIWs);
        if M0 ~= M
           M_CIWs(1) = M_CIWs(1) + M - M0;
        end
        Count = 1;
        for i = 1:NumClasses
            ClassIndices = find(labels==i-1);
            W_randoms(Count:Count+M_CIWs(i)-1,:) = sign(randn(M_CIWs(i),length(ClassIndices)))*X(:,ClassIndices)';
            Count = Count + M_CIWs(i);
        end
        W_randoms =  Mask.*W_randoms; %mask random weights
        W_randoms = Scaling*diag(1./sqrt(eps+sum(W_randoms.^2,2)))*W_randoms; %normalise rows and scale
    case 3
        %Get the Constrained weights
        for i = 1:M
            Norm = 0;
            Inds = ones(2,1);
            while labels(Inds(1)) == labels(Inds(2)) ||  Norm < eps
                Inds = randperm(k_train,2);
                X_Diff = X(:,Inds(1))-X(:,Inds(2));
                Wrow = X_Diff.*Mask(i,:)'; %get masked C random weights
                Norm  = sqrt(sum(Wrow.^2));
            end
            W_randoms(i,:) = Wrow/Norm;
            biases(i) = 0.5*(X(:,Inds(1))+X(:,Inds(2)))'*Wrow/Norm;
        end
        W_randoms = Scaling*W_randoms; %scale the weights (already normalised) 
    otherwise
        disp('error')
        return
end
%to implement biases, set an extra input dimension to 1, and put the biases in the input weights matrix
X = [X;ones(1,k_train)];
W_randoms = [W_randoms biases];

%train the ELM
A = 1./(1+exp(-W_randoms*X)); %get hidden layer activations
W_outputs = (A*Y)'/(A*A'+RidgeParam*eye(M)); %find output weights by solving the for regularised least mean square weights

%test with trained-on data
X = [X;ones(1,k_train)];
Y_predicted_train = W_outputs*A;
[MaxVal,ClassificationID_train] = max(Y_predicted_train); %get output layer response and then classify it
PercentCorrect_train = 100*(1-length(find(ClassificationID_train-1-labels'~=0))/k_train); %calculate the error rate
