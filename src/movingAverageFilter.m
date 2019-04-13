function filtered = movingAverageFilter(x, N)
    kernel = ones(1,N)/N;
    filtered = filter(kernel,1,x);
end

