function [grade_test,wts]=ML(Xtrain,wts,Xlabels,Xtest)

    % update weight's
    wts =((Xtrain'*Xtrain)^-1)*(Xtrain'*Xlabels);
    
    % regression
    grade_test=zeros(1,4);
    for i=1:4
        grade_test(1,i)=Xtest(i,:)*wts;
    end
end