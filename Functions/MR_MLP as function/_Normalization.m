function Normalization(Max_range,Min_range,Vector)
    % Normalize Vector

    nomalized_image = (Vector - min(Vector(:)))*...
        (Max_range - Min_range)/(max(Vector(:)) - min(Vector(:))) + Min_range;
end