
%% test some pictures

%read live image from your PC
imfile = 'E:\Desktop\9.png'; target_22 = 9;
im = double(rgb2gray(imread(imfile))); % double and convert to grayscale
im= imresize(im,[32,32]); %resize size(fixd size)
% imwrite(im,'E:\Desktop\g7.png');

for i=1:size(im,1)
    for j = 1:size(im,2)
        if im(i,j)==255
            im(i,j)=0;
        else
             im(i,j)=255;
        end
    end
end

image = zeros();


for i=1:size(im,1)
%     image= imresize(im,[32,32]); %resize size(fixd size)
    image = im;
    % Normalize the Image:
    im_Range = getrangefromclass(image(1));
    Max_range = im_Range(2);
    Min_range = im_Range(1);
    nomalized_image = (image - min(image(:)))*...
        (Max_range - Min_range)/(max(image(:)) - min(image(:))) + Min_range;
    persian_test_images = nomalized_image;
end


layer(1).a=reshape(persian_test_images,[1024 1]);
% layer(1).a = im;
answer=0;
    for c=2:L
        if c==2
            layer(c).z = (layer(c-1).a(:,1))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
        else
            layer(c).z = (layer(c-1).a(:))'*(layer(c).wts(1:end-1,:))+(layer(c).bias*layer(c).wts(end,:));
        end
        if tanh_or_sigmoid==1 %tanh
            layer(c).a = tanh(layer(c).z);
        else %sigmoid
            layer(c).a = sigmoid(layer(c).z);
        end
    end
    test = Max_Rand_Activation(layer(L).a,layer(L).Size,target_22);
    answer = test;
    fprintf(num2str(answer));
%
%
%
%
%
%
%
%
%
%
%
%
%
%