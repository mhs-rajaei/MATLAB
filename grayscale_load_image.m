function R_I = grayscale_load_image(path,percent_of_test_data,hight,width,zero_one,original)


%% Load data from folder
% Use imageSet to load images stored in pet_images folder
imset = imageSet(path,'recursive');
% Load and resize images for prediction
counter = 0;
[~,im_size] = size(imset);
for j=1:im_size
    for i = 1:imset(j).Count
        counter = counter +1;
        %         images{counter} = read(imset(j),i);%real size
        images2(counter).image= imresize(read(imset(j),i),[hight,width]); %resize size(fixd size)
    end
end

%% Get the image labels
Labels = getImageLabels(imset);
fprintf('class label distribution\n');
summary(Labels); % Display class label distribution

if strcmpi(original,'true')
    R_I.original_images = images2;
    R_I.original_Labels = Labels;
end



%% shuffeing images
min_idx=1;
max_idx=counter;
inedx_of_test = floor((percent_of_test_data*counter)/100);
idx = randperm(max_idx-min_idx+1,inedx_of_test);
% Preallocate arrays with fixed size
images_matrix = zeros(hight,hight,counter);


%% Normalize the Image and convert to grayscale
number_of_convert = 0;
for i=min_idx:max_idx
    
    converted_image_2_double = im2double(rgb2gray(images2(i).image));
    %     myImgNorm = featureNormalize(myImg);
    % Normalize the Image:
    im_Range = getrangefromclass(converted_image_2_double(1));
    Max_range = im_Range(2);
    Min_range = im_Range(1);
    nomalized_image = (converted_image_2_double - min(converted_image_2_double(:)))*...
        (Max_range - Min_range)/(max(converted_image_2_double(:)) - min(converted_image_2_double(:))) + Min_range;

    images_matrix(:,:,i) = im2double(nomalized_image);
  
    
end

  

%shuffle test data's
% training images and test images sepration
test_images = images_matrix(:,:,idx);
images_matrix(:,:,idx) = [];
training_images = images_matrix;
% training labels and test labels sepration
test_Labels = Labels(idx(1,:));
Labels(idx(1,:)) = [];
training_Labels= Labels;

%shuffle tarin data's
[~,label_marix_size] = size(training_Labels);
min_idx=1;
max_idx=label_marix_size;
idx = randperm(max_idx-min_idx+1,label_marix_size);

training_images = training_images(:,:,idx);
training_Labels = training_Labels(idx(1,:));
% %  Display  image and correpondig lable for it
% for i=1:label_marix_size
%             imshow( training_images(:,:,:,i));
%             title(char(training_Labels(i)));
%             pause;
%             close all;
% end
%% R_I output of IO function
R_I.test_images = test_images;
R_I.test_Labels = test_Labels;
R_I.training_images = training_images;
R_I.training_Labels = training_Labels;
%% Labeling as 0 and 1
if strcmpi(zero_one,'true')
    training_target = zeros(label_marix_size,1);
    for i=1:label_marix_size
        if strcmpi(char(training_Labels(i)),'0')
            training_target(i,1) = 0;
        else
            training_target(i,1) = 1;
        end
    end
    
    [test_label_marix_size,~] = size(test_Labels);
    test_target = zeros(test_label_marix_size,1);
    for i=1:test_label_marix_size
        if strcmpi(char(test_Labels(i)),'0')
            test_target(i,1) = 0;
        else
            test_target(i,1) = 1;
        end
    end
    
    R_I.zero_one_training_Labels = training_target;
    R_I.zero_one_testing_Labels = test_target;
end

end