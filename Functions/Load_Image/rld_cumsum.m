function out = rld_cumsum(vals,runlens)
index = zeros(1,sum(runlens));
index([1 cumsum(runlens(1:end-1))+1]) = 1;
out = vals(cumsum(index));
end