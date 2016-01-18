clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 24;
% Read in a standard MATLAB color demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'peppers.png';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
	% Didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(1, 2, 1);
imshow(rgbImage);
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Ask user for a number.
defaultValue = 5;
titleBar = 'Enter a value';
userPrompt = 'Enter the number of colors: ';
caUserInput = inputdlg(userPrompt, titleBar, 1, {num2str(defaultValue)});
if isempty(caUserInput),return,end; % Bail out if they clicked Cancel.
integerValue = round(str2double(cell2mat(caUserInput)));
% Check for a valid integer.
if isnan(integerValue)
    % They didn't enter a number.  
    % They clicked Cancel, or entered a character, symbols, or something else not allowed.
    integerValue = defaultValue;
    message = sprintf('I said it had to be an integer.\nI will use %d and continue.', integerValue);
    uiwait(warndlg(message));
end
% Call rgb2ind
[indexedImage, customizedColorMap] = rgb2ind(rgbImage, integerValue);
% Display it
subplot(1, 2, 2);
imshow(indexedImage, []);
colormap(customizedColorMap);
colorbar;
caption = sprintf('Indexed image with %d colors', integerValue)
title(caption, 'FontSize', fontSize);