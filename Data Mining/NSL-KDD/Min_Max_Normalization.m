function [nomalized_v] = Min_Max_Normalization(Vector)
    % Normalize Vector
    % if yor input had NAN please check it: 
        %     if(isnan(opatches(:,i)))
        %            nomalized(:,i)=0;
        %     end
    Max_range = 1;
    Min_range = 0;
    nomalized = (Vector - min(Vector(:)))*...
        (Max_range - Min_range)/(max(Vector(:)) - min(Vector(:))) + Min_range;
    nomalized_v = nomalized;
end