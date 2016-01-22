function [scores] = cnnPredict(cnnModel,predImage)
% Get batch size and number of images
if ~isfield(cnnModel,'info')
    cnnModel.info.opts.batchSize = 1;
end
batchSize = cnnModel.info.opts.batchSize;
n_obs = size(predImage,4);


% Preallocate scores
resTemp = vl_simplenn(cnnModel.net, cnnPreprocess(predImage(:,:,:,1)), [], []);
scores = zeros([size(resTemp(end-2).x), n_obs]);

% Make predictions
batchNumber = 0;

for ii = 1:batchSize:n_obs
    idx = ii:min(ii+batchSize-1,n_obs);
	batchImages = predImage(:,:,:,idx);
    im = cnnPreprocess(batchImages);    
	
    train_res = vl_simplenn(cnnModel.net, im, [], []);
    scores(:,:,:,idx) = squeeze(gather(train_res(end-2).x));
    batchNumber = batchNumber + 1;   
end

scores = squeeze(gather(scores))';

function im = cnnPreprocess(batchImages)
    % Preprocess images
    im = single(batchImages);
    im = imresize(im, cnnModel.net.normalization.imageSize(1:2));
	im = bsxfun(@minus,im,cnnModel.net.normalization.averageImage);
end

end
