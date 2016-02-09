function [Pass_or_Fail_status,MSE,wts]=Logistic_Classification(Xtrain,wts,parameter,Xlabels,Xtest)

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

    % Delta for batch method
    Delta=zeros(1,7);
    % learning...
    for epoch=1:parameter.iteration
        for i=1:20
            grade(1,i)=sigmoid(Xtrain(i,:)*wts');
        end
        
        error = (Xlabels' - grade) .* ((grade) .* (1-grade));
        Delta = (parameter.learning_rate .* error * Xtrain) + Delta;
        wts = wts + (1/20) .* Delta;
           
        % Compute Overal MSE
        error = error.^2;
        MSE(epoch) = (sum(error(:))) ./ 20;
        Delta = zeros();
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