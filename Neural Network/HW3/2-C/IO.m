function R_I = IO()

R_I = struct('train_image',[],'test_image',[]);


%read class1
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C\2_Class\Military'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);

counter = number_of_samples;
for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    myImg = im2double(A);
    %     myImgNorm = featureNormalize(myImg);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    %     myimages_class1{Q}=myImgNorm;
    R_I.train_image{Q,1}=myImgNorm;
    R_I.train_image{Q,2}='Military';
end
%read class2
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C\2_Class\Civil'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);

for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    
    myImg = im2double(A);
    %     myImgNorm = featureNormalize(myImg);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    %     myimages_class2{Q}=myImgNorm;
    
    R_I.train_image{Q+counter,1}=myImgNorm;
    R_I.train_image{Q+counter,2}='Civil';
    
end

%read class1 test data
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C\2_Class\Military\test data'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);
counter = number_of_samples;
for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    
    myImg = im2double(A);
    %     myImgNorm = featureNormalize(myImg);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    %     myimages_class2{Q}=myImgNorm;
    
    R_I.test_image{Q,1}=myImgNorm;
    R_I.test_image{Q,2}='Military';
    
end

%read class2 test data
cd 'F:\Documents\MATLAB\Neural Network\HW3\2-C\2_Class\Civil\test data'
image_files=dir('*.jpg');
dimension=size(image_files);
number_of_samples=dimension(1);

for Q=1:number_of_samples
    file_name=image_files(Q).name;
    A=imread(file_name);
    A = imresize(A, [240 240]);
    
    myImg = im2double(A);
    %     myImgNorm = featureNormalize(myImg);
    % Normalize the Image:
    myRange = getrangefromclass(myImg(1));
    newMax = myRange(2);
    newMin = myRange(1);
    myImgNorm = (myImg - min(myImg(:)))*(newMax - newMin)/(max(myImg(:)) - min(myImg(:))) + newMin;
    %     myimages_class2{Q}=myImgNorm;
    
    R_I.test_image{Q+counter,1}=myImgNorm;
    R_I.test_image{Q+counter,2}='Civil';
    
end



end










