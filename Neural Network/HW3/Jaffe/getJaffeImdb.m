function imdb = getJaffeImdb(TrainDir, ValDir, imageSize)
Timset = imageSet(TrainDir,'recursive');
Vimset = imageSet(ValDir,'recursive');

imCounter =sum([Timset(:).Count])+sum([Vimset(:).Count]);
Images = zeros([imageSize, imCounter ],'single');
labels = zeros(1, imCounter);
set = zeros(1, imCounter); 


% Load and resize images for prediction
counter = 0;
for ii = 1:numel(Timset)
  for jj = 1:Timset(ii).Count
      counter = counter +1; 
      Images(:,:,:, counter) = imresize(single(read(Timset(ii),jj)),imageSize(1:2));
      labels(counter) = ii;
      set(counter) = 1;
  end
end
for ii = 1:numel(Vimset)
  for jj = 1:Vimset(ii).Count
      counter = counter +1; 
      Images(:,:,:, counter) = imresize(single(read(Vimset(ii),jj)),imageSize(1:2));
      labels(counter) = ii;
      set(counter) = 3;
  end
end

data = Images;
dataMean = mean(data(:,:,:,set == 1), 4);
data = bsxfun(@minus, data, dataMean);
classes = cell(1,length(Timset));
for i = 1 : length(Timset)
    classes{i} = Timset(i).Description;
end
r=randperm(length(set), length(set));
imdb.images.data = data(:,:,:,r);
imdb.images.data_mean = dataMean;
imdb.images.labels = labels(r) ;
imdb.images.set = set(r) ;
imdb.meta.sets = {'train', 'val', 'test'} ;
imdb.meta.classes = classes;