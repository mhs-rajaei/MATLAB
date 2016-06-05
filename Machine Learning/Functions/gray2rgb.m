% % Function to turn grayscale images to RGB
% %
% %    Copyright (C) 2013  Anestis Papazoglou
% %
% %    You can redistribute and/or modify this software for non-commercial use
% %    under the terms of the GNU General Public License as published by
% %    the Free Software Foundation, either version 3 of the License, or
% %    (at your option) any later version.
% %
% %    This program is distributed in the hope that it will be useful,
% %    but WITHOUT ANY WARRANTY; without even the implied warranty of
% %    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% %    GNU General Public License for more details.
% %
% %    You should have received a copy of the GNU General Public License
% %    along with this program.  If not, see <http://www.gnu.org/licenses/>.
% %
% %    For commercial use, contact the author for licensing options.
% %
% %    Contact: a.papazoglou@sms.ed.ac.uk
% %
% function result = gray2rgb( image, verbal )

function result = gray2rgb( image )
%
% if( nargin < 2 )
%     verbal = false;
% end

% Check RGB or Grayscale
if( size( image, 3 ) == 3 )
    %     if( verbal )
    fprintf( 'Warning, input image already has 3 channels...\n' );
    %     end
    
    result = image;
    return
end
%add 3 channel : copy the 1 channel image value for all channels
result = zeros( size( image, 1 ), size( image, 2 ), 3, 'uint8' );
for( i = 1: 3 )
    result( :, :, i ) = image;
end

% figure;imshow(result);title('gray2rgb');

%% Check RGB or Grayscale
% [rows, columns, numberOfColorChannels] = size('3.tiff');
% if numberOfColorChannels > 1
%     fprintf('input image already has 3 channels...(image is RGB)\n');
% else 
%     fprintf('input image has 1 channel(image is Grayscale)\n');
% end
end