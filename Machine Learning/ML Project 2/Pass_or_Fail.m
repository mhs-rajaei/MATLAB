function [Pass_or_Fail_status,MSE,wts] =Pass_or_Fail(Xtrain,wts,parameter,Xlabels,Xtest)

    for i=1:20
        if Xlabels(i)>=12
           Xlabels(i) = 1;
        else
            Xlabels(i) = 0;
        end
    end
    MSE = zeros(1,parameter.iteration);
    % grade vector
    grade=zeros(1,20);
    % error vector
    error=zeros(1,20);
    % learning...
    for epoch=1:parameter.iteration
        for i=1:20
            grade(1,i)=Xtrain(i,:)*wts';
            error(1,i) =Xlabels(i) - grade(1,i) ;
            wts = wts + (parameter.learning_rate * error(1,i) * Xtrain(i,:));
        end 
        % Compute Overal MSE
        error = error.^2;
        MSE(epoch) = (sum(error(:))) ./ 20;
    end
    Pass_or_Fail_status = zeros(1,4);
    % regression
    grade_test=zeros(1,4);
    for i=1:4
        grade_test(1,i)=Xtest(i,:)*wts';
        if grade_test(1,i)>=0
            Pass_or_Fail_status(1,i) = 1;
        end
    end
end