%% =========== computing the eroor rate and accuracy =============
function result = Test(layer,number_of_sampels,Train_or_Test,L,labels,dataset,tanh_or_sigmoid)

layer(1).a=dataset;

% counter=0;
TP = 0;% True Positive
FP = 0;% False Positive
FN =0;% False Negetive
TN= 0;% True Negetive
for num_in=1:number_of_sampels

     for c=2:L
            if c==2
                layer(c).z = (layer(c-1).a(:,num_in))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            else
                layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            end
            
            if isnan(layer(c).z)
                fprintf('\n');
                fprintf('\n');
                fprintf('Please Change input parameter to prevent NaN in Calculation');
                error('Error We Find NaN in Calculation!!!!!!!!!!!!!!!');
            end
            
            if tanh_or_sigmoid==1 %tanh
                layer(c).a = tanhyp(layer(c).z);
            else %sigmoid
                layer(c).a = sigmoid(layer(c).z);
            end
     end
    
        
    max_as_classifire= zeros(1,size(labels,2));
    [~, index] = max(layer(L).a, [], 2);
    max_as_classifire(index)=1;
    
    %test = Max_Rand_Activation(layer(L).a,labels(num_in,:));
     % True Positive
     if labels(num_in,1) == 1 && max_as_classifire(1,1) == 1
         TP = TP + 1;
         
         % True Negative
     else if labels(num_in,2) == 1 && max_as_classifire(1,2) == 1
             TN = TN + 1;
             % False Positive
         else if labels(num_in,1) == 0 && max_as_classifire(1,1) == 1
                 FP = FP + 1;
                 
                 % False Negative
             else if labels(num_in,2) == 0 && max_as_classifire(1,2) == 1
                     FN = FN + 1;
                 end
             end
         end
     end
     
    
%     counter = counter + TP;
end

if Train_or_Test == 1
    fprintf('Test Data Accuracy:\t');
elseif Train_or_Test == 0
    fprintf('Trainig Data Accuracy:\t');
elseif Train_or_Test == 2
    fprintf('Test2 Data Accuracy:\t');
end

fprintf(num2str(((TP+TN)/number_of_sampels)*100));
fprintf('\t, TP: \t');
fprintf(num2str(TP));
fprintf('\t, TN: \t');
fprintf(num2str(TN));
fprintf('\t, FP: \t');
fprintf(num2str(FP));
fprintf('\t, FN: \t');
fprintf(num2str(FN));

fprintf('\n');

result.TP = TP;
result.TN = TN;
result.FP = FP;
result.FN = FN;


end


