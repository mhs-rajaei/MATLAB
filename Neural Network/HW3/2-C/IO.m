function R_I = IO()
clear all
clc
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
counter2 = number_of_samples;
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
    
    R_I.test_image{Q+counter2,1}=myImgNorm;
    R_I.test_image{Q+counter2,2}='Civil';
    
end
% R_I.counter = counter;
[train_size , ~] =size(R_I.train_image);
for i=1:train_size
    if (mod(i,2)==0) & ((i+counter)<=train_size)
        t1 = R_I.train_image{i+counter,1};
        R_I.temp_train_image{i,1} = R_I.train_image{i+counter,1};
        t2 = R_I.train_image{i+counter,2};
        R_I.temp_train_image{i,2} = R_I.train_image{i+counter,2};
    end
    
    if (mod(i,2)==0) & ((i-counter)>0)
        t1 = R_I.train_image{i-counter,1};
        R_I.temp_train_image{i,1} = R_I.train_image{i-counter,1};
        t2 = R_I.train_image{i-counter,2};
        R_I.temp_train_image{i,2} = R_I.train_image{i-counter,2};
    end
    


    if (mod(i,2)~=0)
        t3= R_I.train_image{i,1};
        R_I.temp_train_image{i,1} = R_I.train_image{i,1};
        t4 = R_I.train_image{i,2};
        R_I.temp_train_image{i,2} = R_I.train_image{i,2};
    end 
end



%%

% yek dar myan Test Data   
[test_size , ~] =size(R_I.test_image);
for i=1:test_size
    if (mod(i,2)==0) & ((i+counter2)<=test_size)
%         t1 = R_I.test_image{i+counter,1};
        R_I.temp_test_image{i,1} = R_I.test_image{i+counter2,1};
%         t2 = R_I.test_image{i+counter,2};
        R_I.temp_test_image{i,2} = R_I.test_image{i+counter2,2};
    end
    
    if (mod(i,2)==0) & ((i-counter2)>0)
%         t1 = R_I.test_image{i-counter,1};
        R_I.temp_test_image{i,1} = R_I.test_image{i-counter2,1};
%         t2 = R_I.test_image{i-counter,2};
        R_I.temp_test_image{i,2} = R_I.test_image{i-counter2,2};
    end
    


    if (mod(i,2)~=0)
%         t3= R_I.train_image{i,1};
        R_I.temp_test_image{i,1} = R_I.test_image{i,1};
%         t4 = R_I.train_image{i,2};
        R_I.temp_test_image{i,2} = R_I.test_image{i,2};
    end


    if (mod(i,2)~=0)
%         t3= R_I.test_image{i,1};
        R_I.temp_test_image{i,1} = R_I.test_image{i,1};
%         t4 = R_I.test_image{i,2};
        R_I.temp_test_image{i,2} = R_I.test_image{i,2};
    end
    
    
end



%%


R_I.train_image = R_I.temp_train_image;
R_I.test_image =  R_I.temp_test_image;
% for i=1:train_size
%     imshow(R_I.temp_train_image{i,1});
%     title(R_I.temp_train_image{i,2});
%     pause;
% end

end










