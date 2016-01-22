function result = gray2rgb2( image )

% Check RGB or Grayscale
if( size( image, 3 ) == 3 )
    
    fprintf( 'Warning, input image already has 3 channels...\n' );

    result = image;
    return
end
%add 3 channel : copy the 1 channel image value for all channels
temp(:,:,1) = image;% Red channel
temp(:,:,2) = image;% Green channel
temp(:,:,3) = image;% Blue channel
result = uint8(255 * mat2gray(temp));
% figure; imshow(result);
% title('gray2rgb2');

end