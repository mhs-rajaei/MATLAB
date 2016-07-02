% In the name of ALLAH
% ReadCDB: Reads a .cdb file and stores them in "Data" and "Lables"
clear all;
clc;
ShowImages = true;
SaveImages = false;
filename = 'F:\Documents\MATLAB\Data\MNIST\Farsi Digit Dataset\Test 20000.cdb';

fid = fopen(filename, 'rb');
%read private header
yy = fread(fid, 1, 'uint16');
m = fread(fid, 1, 'uint8');
d = fread(fid, 1, 'uint8');
W = fread(fid, 1, 'uint8');
H = fread(fid, 1, 'uint8');
TotalRec = fread(fid, 1, 'uint32');
LetterCount = fread(fid, 128, 'uint32');
imgType = fread(fid, 1, 'uint8');%0: binary, 1: gray
Comments = fread(fid, 256, 'int8');
Reserved = fread(fid, 245, 'uint8');
if( (W > 0) && (H > 0))
    normal = true;
else
    normal = false;
end;

Data = cell(TotalRec,1);
labels = zeros(TotalRec,1);

for i = 1:TotalRec
    StartByte = fread(fid, 1); %must be 255
    labels(i) = fread(fid, 1);
    if (~normal)
        W = fread(fid, 1);
        H = fread(fid, 1);
    end;
    ByteCount = fread(fid, 1, 'uint16');
    Data{i} = uint8(zeros(H, W));

    if(imgType == 0) %Binary
        for y = 1:H
            bWhite = true;
            counter = 0;
            while (counter < W)
                WBcount = fread(fid, 1);
                x = 1;
                while(x <= WBcount)
                    if(bWhite)
                        Data{i}(y, x+counter) = 0; %Background
                    else
                        Data{i}(y, x+counter) = 255; %ForeGround
                    end;%if
                    x = x+1;
                end;%while(x <= WBcount)
                bWhite = ~bWhite; %black white black white ...
                counter = counter + WBcount;
            end;%while (counter < W)
        end;%y
    else %GrayScale mode
        Data{i} = transpose(reshape(uint8(fread(fid, W*H)), W, H));
    end;%else
%     if ShowImages
%         imshow(Data{i});
%         title(sprintf('%d (%d*%d)', labels(i), W, H));
%         if(SaveImages)
%             imwrite((Data{i}), sprintf('\\%d_%d.bmp',i,labels(i)));
%         end
% %         pause;
%     end    
end;%i
fclose(fid);
image = zeros();

test_images(:,:,:) = zeros(32,32,20000);
for i=1:size(Data,1)
    image= imresize(Data{i},[32,32]); %resize size(fixd size)
    converted_image_2_double = im2double(image);
    % Normalize the Image:
    im_Range = getrangefromclass(converted_image_2_double(1));
    Max_range = im_Range(2);
    Min_range = im_Range(1);
    nomalized_image = (converted_image_2_double - min(converted_image_2_double(:)))*...
        (Max_range - Min_range)/(max(converted_image_2_double(:)) - min(converted_image_2_double(:))) + Min_range;
    test_images(:,:,i) = im2double(nomalized_image);
end


test_labels = labels;
