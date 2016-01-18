clc
clear
close all
format shortG
%% Insert Data

load fisheriris
X=meas;         % Inputs
Y=species;      % Targets

%% KNN Parameters

MaxK=25;
MaxRun=5;

%% Main Prog

KNNmodel=cell(MaxK,MaxRun);
cvmodel=cell(MaxK,MaxRun);
TotalResubLoss=zeros(MaxK,MaxRun);
TotalKFoldLoss=zeros(MaxK,MaxRun);

for k=1:MaxK
    for run=1:MaxRun
    KNNmodel{k,run}=ClassificationKNN.fit(X,Y,'NumNeighbors',k);
    cvmodel{k,run}=crossval(KNNmodel{k,run});
    TotalResubLoss(k,run)=resubLoss(KNNmodel{k,run});
    TotalKFoldLoss(k,run)=kfoldLoss(cvmodel{k,run});
    end
end

ResubLoss=mean(TotalResubLoss,2);
KFoldLoss=mean(TotalKFoldLoss,2);

%% Select Best K

[BestValue,BestK]=min(KFoldLoss);

disp(['Best Value = ' num2str(BestValue) ])
disp(['Best K = ' num2str(BestK) ])


%%  Results

figure;
plot(ResubLoss,'r','LineWidth',2);
hold on;
plot(KFoldLoss,'b','LineWidth',2);
legend('Resub Loss','k-Fold Loss');
xlabel('Number of Neighbors - k');
ylabel('Loss');





