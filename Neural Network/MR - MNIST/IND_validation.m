function IND_validation()

Load_Data;

validation_images = images(:,IND);
validation_labels = labels(IND);


train_images = removerows(images','ind',IND);
train_images= train_images';
train_labels = removerows(labels,'ind',IND);

images(:,IND) = [];

end