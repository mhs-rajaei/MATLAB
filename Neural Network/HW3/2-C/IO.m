function R_I = IO()

R_I = struct('train_image',[],'test_image_class1',[],'test_image_class2',[]);



tr_class1=randperm(67,40);
tes_class1=1:67;
tes_class1(tr_class1)=[];
tr_class2=randperm(67,40);
tes_class2=1:67;
tes_class2(tr_class2)=[];
%read class1
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C\2_Class\Military'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);
myimages_class1={};
for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    
    
    %% normalize method 1
    myImg = im2double(A);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    myimages_class1{Q}=myImgNorm;
   
    
    
    
end
%read class2
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C\2_Class\Civil'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);
myimages_class2={};
%class 1
for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    
    
    %% normalize method 1
    myImg = im2double(A);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    myimages_class2{Q}=myImgNorm;
end

%%
j=0;t1=0;t2=0;
%class 2
for i=1:67
    if i~=tes_class1(:)
        j=j+1;
        R_I.train_image{j,1}=myimages_class1{i};
        R_I.train_image{j,2}='Military';
    else
        t1=t1+1;
        R_I.test_image_class1{t1,1}=myimages_class1{i};
        R_I.test_image_class1{t1,2}='Military';
    end
    %%
    if i~=tes_class2(:)
        j=j+1;
        R_I.train_image{j,1}=myimages_class2{i};
        R_I.train_image{j,2}='Civil';
    else
        t2=t2+1;
        R_I.test_image_class2{t2,1}=myimages_class2{i};
        R_I.test_image_class2{t2,2}='Civil';
    end
end


% R_I.train_image = R_I.train_image;
% R_I.test_image_class1 = R_I.test_image_class1;
% R_I.test_image_class2 = R_I.test_image_class2;

end










