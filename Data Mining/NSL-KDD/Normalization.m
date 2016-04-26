function [normalized_vector] = Normalization(raw)

%%=================== Start Normalization ===========================%
% This code Normalize input vector by MIN_MAX method and do the following:
% 1- read the vector and normalize it using min-max normalization
% 2- return normalized vector
matrix_normalized = zeros(); % store the normalized values
% data = cellfun(@str2num,raw,'UniformOutput',false);
% data = cell2mat(cellfun(@cell2mat, raw, 'UniformOutput', false));
row_count = size(raw,1);   % how many rows
col_count = size(raw,2);   % how many columns
%=========================================================================%
raw_matrix = raw;
%loops to select each feature and normalize it individually
for i=1:col_count
    selected_column = raw_matrix(:,i);
    maximum = max(selected_column);
    minimum = min(selected_column);
%     if maximum > 1
	    for j=1:size(selected_column,1)
		    if selected_column(j) == 0
            matrix_normalized(j,i) = 0;
			else
            matrix_normalized(j,i) = (selected_column(j)-minimum) / (maximum - minimum);
			end
		end
% 	else
% 		for j=1:size(selected_column,1)
% 		    matrix_normalized(j,i) = selected_column(j); % do not normalize and save the values directly
% 		end
% 	end	
end
%==================== End Normalizing =================================%
normalized_vector = matrix_normalized;
end