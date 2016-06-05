function result = createArrays(nArrays, arraySize)
    result = cell(1, nArrays);
    for i = 1 : nArrays
        result{i} = zeros(arraySize);
    end
end