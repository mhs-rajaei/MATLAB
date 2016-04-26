%% =========== computing the eroor rate and accuracy =============
function counter = Test(layer,number_of_sampels,Train_or_Test,L,labels,dataset,tanh_or_sigmoid)

layer(1).a=dataset';

counter=0;

for num_in=1:number_of_sampels
    for c=2:L
            if c==2
                layer(c).z = (layer(c-1).a(:,num_in))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            else
                layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
            end        
            if tanh_or_sigmoid==1 %tanh
                layer(c).a = tanhyp(layer(c).z);
            else %sigmoid
                layer(c).a = sigmoid(layer(c).z);
            end
        end
    test = Max_Rand_Activation(layer(L).a,labels(num_in,:));
    counter = counter + test;
end

if Train_or_Test == 1
    fprintf('Test Data Accuracy:\n');
elseif Train_or_Test == 0
    fprintf('Trainig Data Accuracy:\n');
elseif Train_or_Test == 2
    fprintf('Validation Data Accuracy:\n');
end

fprintf(num2str((counter/number_of_sampels)*100));

fprintf('\n');

end


