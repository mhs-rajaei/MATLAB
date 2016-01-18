function [grade_test,MSE,wts]=Batch(Xtrain,wts,parameter,Xlabels,Xtest)

    MSE = zeros(1,parameter.iteration);
    % grade vector
    grade=zeros(1,20);
    % error vector
    error=zeros(1,20);

    % Delta for batch method
    Delta=zeros(1,7);
    % learning...
    for epoch=1:parameter.iteration
        % regerssion on trainin set
        for i=1:20
            grade(1,i)=Xtrain(i,:)*wts';
        end
        % calulate error
        error = Xlabels' - grade;
        % calulate delta rule
        Delta = (parameter.learning_rate .* error * Xtrain) + Delta;
        wts = wts + (1/20) .* Delta;  
        % Compute Overal MSE
        error = error.^2;
        MSE(epoch) = (sum(error(:))) ./ 20;
        Delta = zeros();
    end
    
    % regression on test set
    grade_test=zeros(1,4);
    for i=1:4
        grade_test(1,i)=Xtest(i,:)*wts';
    end
end