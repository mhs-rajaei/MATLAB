% randomly show 60 numbers
load('F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\hoda_test_images(20000).mat');
for i=1:60
    subplot(6, 10, i);
    rand_idx = randi(20000);
    imshow(test_images(:,:,rand_idx));
    title(test_labels(rand_idx));
    axis square;
end


